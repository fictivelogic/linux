#/bin/bash

KERNEL=kernel8

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs

sudo ../usbboot/rpiboot

echo "sleeping to ensure drives are mounted"
sleep 10

sudo env PATH=$PATH make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=/media/samuel/rootfs/ modules_install

echo "Copying Kernel..."
cp arch/arm64/boot/Image /media/samuel/boot/$KERNEL.img
echo "Copying DTB..."
cp arch/arm64/boot/dts/broadcom/*.dtb /media/samuel/boot/
echo "Copying overlays..."
cp arch/arm64/boot/dts/overlays/*.dtb* /media/samuel/boot/overlays/
echo "Copying README..."
cp arch/arm64/boot/dts/overlays/README /media/samuel/boot/overlays/

sleep 1 

echo "Unmounting..."
sudo umount /media/samuel/boot
sudo umount /media/samuel/rootfs

echo "DONE."
