#!/bin/bash

# mensagem de aviso
zenity --info \
	--title="AVISO" \
	--text="Esse menu pressupõe que você instalou o Arch (Gnome ou KDE) através do archinstall, assim a maior parte das configurações ja foi realizada"

# Exibe uma caixa de seleção múltipla
opcoes=$(zenity --list --checklist \
  --title="Menu (Projeto Akrata)" \
  --text="Marque as opções desejadas" \
  --width=1000 \
  --height=600 \
  --multiple \
  --separator="," \
  --print-column=2 \
  --hide-column=2 \
  --column="Opções" --column="variavel" --column="Ação" \
  FALSE pkgb "Instalar seleção de pacotes básicos" \
  FALSE swap "Aumentar a swap" \
  FALSE bluetooth "Ativar bluetooth" \
  FALSE firewall "Instalar e ativar o firewall(ufw) e GUI (gufw)" \
  FALSE paccache "Ativar limpeza automatica do cache pacman" \
  FALSE systemdboot "[Caso tenha escolhido o systemd-boot] Ativar a atualização automatica do bootloader" \
  FALSE linuxlts "[Caso tenha escolhido o systemd-boot e um kernel que não seja o LTS] Instalar e adicionar kernel-lts no bootloader")

# Verifica se o usuário cancelou
if [ $? -eq 1 ]; then
  echo "Cancelado pelo usuário."
  exit 1
fi

# atualizando o sistema
cmnds="pacman -Syu --noconfirm;"

IFS="," read -ra comandos <<< "$opcoes"

for opcao in "${comandos[@]}"; do
	case "$opcao" in
		"pkgb")
			proc=$(zenity --list --radiolist \
  			--title="Microcode" \
  			--text="Qual processador você esta usando?" \
  			--print-column=2 \
  			--hide-column=2 \
  			--column="Opções" --column="variavel" --column="Fabricante" \
    			FALSE intel-ucode "Processador Intel" \
			FALSE amd-ucode "Processador AMD")

			cmnds+=" pacman -S --noconfirm flatpak ffmpeg gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer fwupd dosfstools mtools ntfs-3g exfatprogs $proc;"
			;;

		"swap")
			gb=$(zenity --list --radiolist \
  			--title="Swap" \
			--text="Quantos Gb de swap deseja?" \
  			--print-column=2 \
  			--hide-column=2 \
  			--column="Opções" --column="variavel" --column="Quantidade" \
    			FALSE 2 "2Gb" \
			FALSE 4 "4Gb" \
			FALSE 8 "8Gb")

			cmnds+=" echo \"zram-size=\$(( $gb * 1024 ))\" | tee -a /etc/systemd/zram-generator.conf;"
			;;

		"bluetooth")
			cmnds+=" systemctl start bluetooth.service;"
			cmnds+=" systemctl enable bluetooth.service;"
			;;

		"firewall")
		        cmnds+=" pacman -S --noconfirm ufw gufw;"
			cmnds+=" ufw enable;"
			cmnds+=" systemctl enable ufw.service;"
 			;;

		"paccache")
			cmnds+=" pacman -S --noconfirm pacman-contrib;"
        		cmnds+=" systemctl enable --now paccache.timer;"
 			;;

		"systemdboot")
			cmnds+=" systemctl enable systemd-boot-update.service;"
			;;

		"linuxlts")
			cmnds+=" pacman -S --noconfirm linux-lts;"
			cmnds+=" cp /boot/loader/entries/*linux.conf /boot/loader/entries/arch-lts.conf;"
			cmnds+=" sed -i '/^# Created by: archinstall\$/c\\# Created by: projeto-akrata' /boot/loader/entries/arch-lts.conf;"
			cmnds+=" sed -i '/^title   Arch Linux (linux)\$/c\\title   Arch Linux-LTS' /boot/loader/entries/arch-lts.conf;"
			cmnds+=" sed -i '/^linux   \\/vmlinuz-linux\$/c\\linux   /vmlinuz-linux-lts' /boot/loader/entries/arch-lts.conf;"
			cmnds+=" sed -i '/^initrd  \\/initramfs-linux.img\$/c\\initrd  /initramfs-linux-lts.img' /boot/loader/entries/arch-lts.conf;"
			;;

	esac
done

(
	pkexec bash -c "$cmnds"
) |
	zenity --progress \
	--title="Executando as ações" \
	--pulsate \
	--auto-close \
	--auto-kill

# mensagem de aviso
zenity --info \
	--title="AVISO" \
	--text="Processos finalizados"

