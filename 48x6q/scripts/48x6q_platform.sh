#!/bin/bash

#platform init script for centec e582-48x6q

init_devnum() {
    found=0
    for devnum in 0 1; do
        devname=`cat /sys/bus/i2c/devices/i2c-${devnum}/name`
        # I801 adapter can be at either dffd0000 or dfff0000
        if [[ $devname == 'SMBus I801 adapter at '* ]]; then
            found=1
            break
        fi
    done

    [ $found -eq 0 ] && echo "cannot find I801" && exit 1
}

init_devnum

if [ "$1" == "init" ]; then
    depmod -a
    modprobe i2c-dev
    modprobe i2c-mux-pca954x force_deselect_on_exit=1
	i2cset -y 0 0x58 0x8 0x3f
	i2cset -y 0 0x20 0x1b 0x0
	i2cset -y 0 0x20 0xb 0x0
	i2cset -y 0 0x21 0x19 0x0
	i2cset -y 0 0x21 0x9 0x0
	i2cset -y 0 0x21 0x1c 0x0
	i2cset -y 0 0x21 0xc 0x0
	i2cset -y 0 0x22 0x1a 0x0
	i2cset -y 0 0x22 0xa 0x0
	i2cset -y 0 0x23 0x18 0x0
	i2cset -y 0 0x23 0x8 0x0
	i2cset -y 0 0x23 0x1b 0x0
	i2cset -y 0 0x23 0xb 0x0
    modprobe centec_e582_48x6q_platform
    modprobe dal
    modprobe centec_at24c64
elif [ "$1" == "deinit" ]; then
    modprobe -r centec_at24c64
    modprobe -r dal
    modprobe -r centec_e582_48x6q_platform
    modprobe -r i2c-mux-pca954x
    modprobe -r i2c-dev
else
     echo "e582-48x6q_platform : Invalid option !"
fi
