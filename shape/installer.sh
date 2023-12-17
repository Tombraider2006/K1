#!/bin/sh

green=`echo "\033[01;32m"`
red=`echo "\033[01;31m"`
white=`echo "\033[m"`

K1_CONFIG_DIR=/usr/data/printer_data/config
K1_SHAPE_DIR=/usr/data/shape
FT2FONT_PATH=/usr/lib/python3.8/site-packages/matplotlib/ft2font.cpython-38-mipsel-linux-gnu.so
KLIPPY_EXTRA_DIR=/usr/share/klipper/klippy/extras
GCODE_SHELL_CMD=$KLIPPY_EXTRA_DIR/gcode_shell_command.py
SHAPER_CONFIG=$KLIPPY_EXTRA_DIR/calibrate_shaper_config.py



printf "${green}Setting up shape ${white}\n"
cp $K1_SHAPE_DIR/k1_mods/calibrate_shaper_config.py $SHAPER_CONFIG

if [ ! -d "/usr/lib/python3.8/site-packages/matplotlib-2.2.3-py3.8.egg-info" ]; then
    echo "Not replacing mathplotlib ft2font module. PSD graphs might not work"
else
    printf "${green}Replacing mathplotlib ft2font module for plotting PSD graphs ${white}\n"
    cp $K1_SHAPE_DIR/k1_mods/ft2font.cpython-38-mipsel-linux-gnu.so $FT2FONT_PATH
fi

if [ ! -f $GCODE_SHELL_CMD ]; then
    printf "${green}Installing gcode_shell_command.py for klippy ${white}\n"
    cp $K1_SHAPE_DIR/k1_mods/gcode_shell_command.py $GCODE_SHELL_CMD
fi

mkdir -p $K1_CONFIG_DIR/shape/scripts
cp $K1_SHAPE_DIR/scripts/*.cfg $K1_CONFIG_DIR/shape
cp $K1_SHAPE_DIR/scripts/*.py $K1_CONFIG_DIR/shape/scripts
cp $K1_SHAPE_DIR/scripts/*.sh $K1_CONFIG_DIR/shape/scripts

## include shape *.cfg in printer.cfg
if grep -q "include shape" $K1_CONFIG_DIR/printer.cfg ; then
    echo "printer.cfg already includes shape cfgs"
else
    printf "${green}Including shape cfgs in printer.cfg ${white}\n"
    sed -i '/\[include gcode_macro\.cfg\]/a \[include shape/*\.cfg\]' $K1_CONFIG_DIR/printer.cfg
fi

sync

if [ ! -f $K1_SHAPE_DIR/ ]; then
    printf "${red}Installation failed, did not find shape in $K1_SHAPE_DIR. Make sure to extract the shape directory in /usr/data. ${white}\n" 
    exit 1
fi


## request to reboot
printf "Restart Klipper now to pick up the new changes (y/n): "
read confirm
echo

if [ "$confirm" = "y" -o "$confirm" = "Y" ]; then
    echo "Restarting Klipper"
    /etc/init.d/S55klipper_service restart
else
    printf "${red}Some shape functionaly won't work until Klipper is restarted. ${white}\n"
fi

echo "Killing Creality services"

killall master-server
killall wifi-server
killall app-server
killall upgrade-server
killall web-server

printf "${green}Starting shape ${white}\n"