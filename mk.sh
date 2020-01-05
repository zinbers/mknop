# 拷贝openwrt rootfs
echo -e "$green \n 提取OpenWrt ROOTFS... $white"
cd ../$out_dir
if df -h | grep $rootfs_dir >/dev/null 2>&1; then
if df -h | grep $rootfs_dir > /dev/null 2>&1; then
    sudo cp -r $rootfs_dir/* openwrt/ && sync
    sudo umount $rootfs_dir
    [ $loop ] && sudo losetup -d $loop
@@ -90,8 +90,12 @@ loop=$(sudo losetup -P -f --show *.img)
    echo -e "$red \n 格式化失败! $white" &&
    exit

sudo mke2fs -F -q -t ext4 -L "BOOT" -m 0 ${loop}p1 >/dev/null 2>&1
sudo mke2fs -F -q -t ext4 -L "ROOTFS" -m 0 ${loop}p2 >/dev/null 2>&1
if [ $device = "n1" ]; then
    sudo mkfs.vfat -n "BOOT" ${loop}p1 > /dev/null 2>&1
elif [ $device = "beikeyun" ]; then
    sudo mke2fs -F -q -t ext4 -L "BOOT" -m 0 ${loop}p1 > /dev/null 2>&1
fi
sudo mke2fs -F -q -t ext4 -L "ROOTFS" -m 0 ${loop}p2 > /dev/null 2>&1

# 挂载分区
sudo mkdir -p $boot_dir
@@ -106,11 +110,11 @@ sudo mv $out_dir/openwrt/* $rootfs_dir
sync

# 取消分区挂载
if df -h | grep $boot_dir >/dev/null 2>&1; then
if df -h | grep $boot_dir > /dev/null 2>&1; then
    sudo umount $boot_dir
fi

if df -h | grep $rootfs_dir >/dev/null 2>&1; then
if df -h | grep $rootfs_dir > /dev/null 2>&1; then
    sudo umount $rootfs_dir
fi

@@ -125,9 +129,9 @@ sudo rm -rf $out_dir/openwrt
if [ $device = "beikeyun" ]; then
    img=$(ls -l $out_dir | grep img | awk '{ print $9 }')
    echo -e "$green \n 写入idb... $white"
    dd if=armbian/beikeyun/loader/idbloader.img of=$out_dir/$img bs=16 seek=2048 conv=notrunc >/dev/null 2>&1
    dd if=armbian/beikeyun/loader/idbloader.img of=$out_dir/$img bs=16 seek=2048 conv=notrunc > /dev/null 2>&1
    echo -e "$green \n 写入uboot... $white"
    dd if=armbian/beikeyun/loader/uboot.img of=$out_dir/$img bs=16 seek=524288 conv=notrunc >/dev/null 2>&1
    dd if=armbian/beikeyun/loader/uboot.img of=$out_dir/$img bs=16 seek=524288 conv=notrunc > /dev/null 2>&1
fi

echo -e "$green \n 制作成功, 输出文件夹 --> $out_dir $white"
