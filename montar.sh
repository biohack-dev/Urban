#!/bin/bash

IMAGEM='./Urban.img'
PARTICAO_DEV="/dev/mapper/loop0p1"

# Verificar se a imagem existe
if [ ! -f "$IMAGEM" ]; then
    echo "Erro: Imagem $IMAGEM não encontrada!"
    echo "Execute primeiro o script de criação da imagem."
    exit 1
fi

# Mapear a imagem para loop device
echo "Mapeando imagem para loop device..."
sudo kpartx -a $IMAGEM

# Aguardar o sistema reconhecer as partições
sleep 2

# Verificar se a partição foi criada
if [ ! -e "$PARTICAO_DEV" ]; then
    echo "Erro: Partição $PARTICAO_DEV não encontrada!"
    echo "Dispositivos disponíveis:"
    ls -la /dev/mapper/
    exit 1
fi

# Criar ponto de montagem
echo "Criando ponto de montagem..."
sudo mkdir -p /mnt/urban

# Montar a partição
echo "Montando sistema de arquivos..."
sudo mount $PARTICAO_DEV /mnt/urban

# Montar sistemas de arquivos especiais para o chroot
echo "Montando sistemas de arquivos especiais..."
sudo mount --bind /dev /mnt/urban/dev
sudo mount --bind /dev/pts /mnt/urban/dev/pts
sudo mount -t proc proc /mnt/urban/proc
sudo mount -t sysfs sysfs /mnt/urban/sys

# Entrar no ambiente chroot
echo "Entrando no ambiente chroot..."
echo "Para sair do chroot, digite 'exit'"
sudo chroot /mnt/urban /bin/bash

# Limpeza (executada após sair do chroot)
echo "Desmontando sistemas..."
sudo umount /mnt/urban/dev/pts 2>/dev/null
sudo umount /mnt/urban/dev 2>/dev/null
sudo umount /mnt/urban/proc 2>/dev/null
sudo umount /mnt/urban/sys 2>/dev/null
sudo umount /mnt/urban 2>/dev/null

# Remover o mapeamento do loop
echo "Removendo mapeamento do loop..."
sudo kpartx -d $IMAGEM

echo "Urban desmontado com sucesso!"
