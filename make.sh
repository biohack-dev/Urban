#!/bin/bash

IMAGEM='Urban.img'
TAMANHO='4G'
PARTICAO="${IMAGEM}1"

# 1. Criar arquivo vazio do tamanho especificado
echo "Criando arquivo de imagem..."
dd if=/dev/zero of=$IMAGEM bs=1 count=0 seek=$TAMANHO

# 2. Criar tabela de partições (uma partição única ocupando todo o disco)
echo "Criando tabela de partições..."
sudo install-mbr --force $IMAGEM
printf "o\nn\np\n\n\n\na\nw" | sudo fdisk $IMAGEM

# 3. Mapear a imagem para um loop device
echo "Mapeando imagem para loop device..."
sudo kpartx -a $IMAGEM

# 4. Descobrir qual loop device foi criado
LOOP_DEV=$(sudo losetup -l | grep "$IMAGEM" | awk '{print $1}' | head -1)
if [ -z "$LOOP_DEV" ]; then
    echo "Erro: Não foi possível encontrar o loop device"
    exit 1
fi
echo "Loop device encontrado: $LOOP_DEV"

# 5. Aguardar o sistema reconhecer as partições
sleep 2

# 6. Formatar a partição como ext4
echo "Formatando partição..."
PARTICAO_DEV="/dev/mapper/$(basename $LOOP_DEV)p1"
echo "Partição a ser formatada: $PARTICAO_DEV"

if [ -e "$PARTICAO_DEV" ]; then
    sudo mkfs.ext4 -F -L RAIZ $PARTICAO_DEV
else
    echo "Erro: Partição $PARTICAO_DEV não encontrada"
    echo "Dispositivos disponíveis:"
    ls -la /dev/mapper/
    sudo kpartx -d $IMAGEM
    exit 1
fi

# 7. Criar ponto de montagem e montar
echo "Criando ponto de montagem e montando..."
sudo mkdir -p /mnt/urban
sudo mount $PARTICAO_DEV /mnt/urban


sudo apt-get install syslinux extlinux
mkdir -p /mnt/urban/boot/extlinux
extlinux -i /mnt/urban/boot/extlinux

echo "Imagem criada com sucesso! Montada em /mnt/urban"
echo "Para desmontar:"
echo "  sudo umount /mnt/urban"
echo "  sudo kpartx -d $IMAGEM"

# 8. Opcional: Mostrar informações do sistema
echo ""
echo "Informações do sistema de arquivos:"
df -h $PARTICAO_DEV
