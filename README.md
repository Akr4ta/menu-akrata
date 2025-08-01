# menu-akrata
Esse menu tem como objetivo ajudar nas configurações básicas do sistema, assim como na instalação de pacotes que considero importantes para o uso do Arch GNU/Linux.

<img src="https://github.com/Akr4ta/menu-akrata/blob/main/menu_img.png" alt="e.g image">

# Usando o menu
Primeiro baixe o zenity (pacote usado para criar a interface gráfica)
> sudo pacman -S zenity

Agora você deve habilitá o menu como um executável.

No Gnome é só clicar com o botão direito, ir em propriedades e selecionar "Executar como programa".

Também é possível ativar por terminal (é necessário estar no mesmo diretório ou indicar ele):
> sudo chmod +x menu_akrata.sh

Por fim a execução pode ser dar clicando com o botão direito e escolhendo "Executar como programa" ou executar pelo terminal:
> ./menu_akrata.sh

# Ações possiveis
## Instalar seleção de pacotes básicos
Essa seção instalara os seguintes pacotes:
* Repositórios adicionais
  * flatpak
* Codecs (para melhorar as capacidades multimídia)
  * ffmpeg gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer
* Gestor de firmwares 
  * fwupd
* Para sistemas de arquivos NTFS (padrão do Windows) e FAT (comum em pendrives)
  * dosfstools mtools ntfs-3g exfatprogs
* Para manter a CPU atualizada
  * intel-ucode ou amd-ucode (a depender a opção selecionada)

## Aumentar a swap
Essa opção vai te dar três opções de tamanho de swap zram, 2Gb, 4Gb, e 8Gb

## Ativar bluetooth
O archinstall ja vai ter instalado os pacotes necessários, porém não ativa o bluetooth, essa opção do menu resolve o problema.

## Instalar e ativar o firewall(ufw) e GUI(gufw)
Irá instalar o ufw e a interface grafica gufw, essa opção também vai ativar com as configurações básicas do ufw.

## Ativar limpeza automatica do cache pacman
O pacman armazena seus pacotes baixados e não remove as versões antigas ou desinstaladas automaticamente, portanto, é necessário limpar deliberadamente esse diretório periodicamente para evitar que essa pasta cresça indefinidamente em tamanho.

O menu ativa o paccache.time, que vai excluir de forma automatica todas as versões em cache de pacotes instalados e desinstalados, excepto para os três mais recentes. 

## [Caso tenha escolhido o systemd-boot] Ativar a atualização automatica do bootloader
Como o nome já indica, essa opção é só para quem escolheu o systemd-boot como bootloader. 

O pacman não atualiza o systemd-boot, apenas instala ele, assim é necessário rodar o comando 'bootctl update' toda vez que uma nova versão do systemd-boot é instalada, só assim ele será de fato atualizado. Outra forma de o manter sempre atualizado, é usando um serviço do systemd, (justamente o que essa opção do menu faz) assim ele será atualizado automaticamente toda vez que o pacman instalar uma nova versão. 

## [Caso tenha escolhido o systemd-boot e um kernel que não seja o LTS] Instalar e adicionar kernel-lts no bootloader
É recomendado ter duas opções de kernel no Arch, o 'linux' como sendo o padrão e o 'linux-lts' como um kernel de segurança caso surja algum problema com o 'linux' padrão. Essa opção do menu instala o kernel lts e adiciona ele no bootloader do systemd-boot.

# Recomentações que não estão no menu
## Cores no terminal e aumentar a quantidade de downloads paralelos
Digite o seguinte comando
> sudo nano /etc/pacman.conf

Descomente (apague o '#') as linhas 'Color' e 'ParallelDownloads', neste ultimo mude a quantidade de 5 para 10 (ou mais se quiser), assim o pacman ira fazer ate 10 downloads paralelos.
Antes:
> #Color

> #ParallelDownloads = 5

Depois:
> Color

> ParallelDownloads = 10
