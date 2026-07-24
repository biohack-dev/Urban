# 🐧 Urban OS

Urban é um sistema operacional portátil baseado em Debian, projetado para ser seu ambiente de trabalho onde quer que você vá. Leve o seu sistema completo no bolso e conecte em qualquer computador.
```
🎯 O Conceito - "Seu sistema, em qualquer lugar"
```

## Urban foi criado para profissionais que precisam de mobilidade total:

    🔌 Conecte em qualquer computador (laboratório, escola, trabalho, cliente)
    💾 Mantenha suas ferramentas, configurações e dados sempre com você
    🚀 Inicialização rápida e ambiente consistente em qualquer hardware
    🔒 Segurança e privacidade - seus dados estão sob seu controle

## ✨ Características

    💾 Ultra compacto: Cabe em um pendrive de apenas 4GB
    💿 Persistência total: Todos os seus dados, arquivos e programas são salvos
    🔄 Universal: Funciona em qualquer PC com suporte a boot USB
    🖥️ Modo texto: Leve e rápido, ideal para servidores e administração
    🔧 Personalizável: Instale apenas o que você precisa
    ⚡ Boot rápido: Pronto para uso em segundos
    🌐 Plug and Play: Reconhece automaticamente diferentes hardwares

## 🚀 Casos de Uso
### 🛠️ Administração de Sistemas

    Ferramentas de rede sempre à mão
    Ambiente de diagnóstico portátil
    Resgate de sistemas com problemas

### 🎓 Educação e Treinamentos

    Ambiente de aprendizado consistente
    Laboratórios práticos sem instalação
    Mesmo sistema em diferentes computadores

### 👨‍💻 Desenvolvimento

    Seu ambiente de desenvolvimento portátil
    Ferramentas e configurações personalizadas
    Projetos sempre disponíveis

### 🔐 Segurança e Privacidade

    Evite deixar rastros em computadores públicos
    Criptografe seus dados
    Controle total do seu sistema

## 🔑 Credenciais de Acesso
```
Usuário	Senha
root	urban
```
⚠️ Importante: Altere a senha do root imediatamente após o primeiro boot:
```
Comando: passwd
```

## 💾 O Sistema de Persistência

O Urban usa um sistema de persistência inteligente que mantém suas alterações entre diferentes computadores:
O que é preservado:

    ✅ Todos os arquivos e documentos
    ✅ Pacotes e programas instalados
    ✅ Configurações do sistema
    ✅ Histórico de comandos
    ✅ Chaves SSH e certificados
    ✅ Scripts e automações

Como funciona:

    Você conecta o pendrive em qualquer computador
    O sistema inicia com sua configuração personalizada
    Todas as alterações são salvas automaticamente
    Pronto para usar em outro computador

## 📥 Instalação
1. Baixe a imagem ISO
bash

wget https://drive.google.com/file/d/1wxym-3-L0caGZhrrZaWC5zj1ZaR-LRf3/view?usp=sharing

2. Descompact com 7zip ou Gzip

3. Grave no pendrive

No Linux:
bash
Identifique o dispositivo (ex: /dev/sdb)
```
lsblk
sudo dd if=urban.iso of=/dev/sdX bs=4M status=progress && sync
```

No Windows:

    Use Rufus (recomendado) ou BalenaEtcher
    Selecione "DD Image" mode no Rufus

    Escolha o pendrive de destino



## 📜 Descrição dos Scripts

make.sh
```
Cria a imagem Urban.img de 4GB, particiona, formata em ext4 e prepara o bootloader.
```

make_base.sh
```
Instala o Debian 12 (Bookworm) via debootstrap dentro da imagem montada.
```

install.sh
```
Instala programas "basicos".
```

montar.sh
```
Monta a imagem, configura os sistemas especiais (dev, proc, sys) e entra no ambiente chroot para customização.
```

desmontar.sh
```
Desmonta todos os sistemas e remove o loop device da imagem.
```
## 🚀 Fluxo Rápido
```
./make.sh          # Cria imagem
./make_base.sh     # Instala Debian
./montar.sh        # Entra no chroot para customizar
./install.sh       # Instalar programas dentro do chroot
./desmontar.sh     # Finaliza
```
