sudo grep ^menuentry /boot/efi/EFI/centos/grub.cfg | cut -f 2 -d \' | awk '{print "["  NR-1  "] " $s}'
read -p "Enter the kernel id: " KERNEL_ID
sudo grub2-set-default $KERNEL_ID
