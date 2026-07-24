#!/bin/bash
# =============================================================================
# Script: configurar_urban.sh
# Descricao: Configuracao do sistema Urban Linux
# =============================================================================

# =============================================================================
# VERIFICAR SE E ROOT
# =============================================================================
if [[ $EUID -ne 0 ]]; then
    echo "ERRO: Este script deve ser executado como root!"
    echo "Use: sudo $0"
    exit 1
fi

echo "=========================================="
echo "  Configuracao do Urban Linux"
echo "=========================================="

# =============================================================================
# CRIAR DIRETORIO /boot/extlinux
# =============================================================================
echo ">>> Criando diretorio /boot/extlinux..."
mkdir -p /boot/extlinux
if [ $? -eq 0 ]; then
    echo "OK: Diretorio /boot/extlinux criado"
else
    echo "ERRO: Falha ao criar /boot/extlinux"
    exit 1
fi

# =============================================================================
# CRIAR ARQUIVO /boot/extlinux/extlinux.conf
# =============================================================================
echo ">>> Criando /boot/extlinux/extlinux.conf..."
cat > /boot/extlinux/extlinux.conf << 'EOF'
DEFAULT linux
LABEL linux
SAY Inicializando o Debian Lenny...
KERNEL /vmlinuz
APPEND ro root=LABEL=RAIZ initrd=/initrd.img
EOF

if [ $? -eq 0 ]; then
    echo "OK: Arquivo /boot/extlinux/extlinux.conf criado"
else
    echo "ERRO: Falha ao criar /boot/extlinux/extlinux.conf"
    exit 1
fi

# =============================================================================
# CRIAR ARQUIVO /etc/fstab
# =============================================================================
echo ">>> Criando /etc/fstab..."

# Backup do fstab original se existir
if [ -f /etc/fstab ]; then
    cp /etc/fstab /etc/fstab.backup.$(date +%Y%m%d_%H%M%S)
    echo "Backup do fstab original criado"
fi

cat > /etc/fstab << 'EOF'
# <file system> <mount point>   <type>  <options>         <dump>  <pass>
proc            /proc           proc    defaults          0       0
LABEL=RAIZ      /               ext2    defaults,noatime  0       1
/swapfile       none            swap    sw                0       0
EOF

if [ $? -eq 0 ]; then
    echo "OK: Arquivo /etc/fstab criado"
else
    echo "ERRO: Falha ao criar /etc/fstab"
    exit 1
fi

# =============================================================================
# INSTALAR PACOTES
# =============================================================================
echo ">>> Atualizando lista de pacotes..."
apt-get update

echo ">>> Instalando ntpdate..."
apt-get install ntpdate -y

echo ">>> Instalando suporte a filesystems..."
apt-get install dosfstools ntfs-3g jfsutils reiserfsprogs xfsprogs mbr testdisk -y

echo ">>> Instalando pacotes de rede..."
apt-get install bittwist dnsutils fping ipcalc nmap tcpdump telnet traceroute ifupdown wireless-tools -y

echo ">>> Instalando pacotes de comunicacao..."
apt-get install ftp rsync ssh udpcast -y

echo ">>> Instalando pacotes de uso geral..."
apt-get install wodim clamav kbd ddrescue debootstrap durep fdupes grub-legacy hexedit \
hwinfo less lshw mc genisoimage myrescue magicrescue parted rcconf strace unzip wipe zip -y

echo ">>> Instalando pacotes adicionais..."
apt-get install e2fsprogs hping3 netcat-openbsd wget curl jq bc git libxml2 -y

echo ">>> Instalando pacotes para o Python..."
apt install python3-pip -y
python3 -m pip install --upgrade pip --break-system-packages
pip install aiml --break-system-packages
apt-get install -y python3-requests python3-bs4 python3-lxml python3-feedparser python3-urllib3

# =============================================================================
# VERIFICACAO FINAL
# =============================================================================
echo "=========================================="
echo ">>> Verificacao final..."

if [ -f /boot/extlinux/extlinux.conf ]; then
    echo "OK: /boot/extlinux/extlinux.conf existe"
else
    echo "ERRO: /boot/extlinux/extlinux.conf NAO encontrado"
fi

if [ -f /etc/fstab ]; then
    echo "OK: /etc/fstab existe"
else
    echo "ERRO: /etc/fstab NAO encontrado"
fi

echo "=========================================="
echo "Configuracao concluida com sucesso!"
echo "=========================================="