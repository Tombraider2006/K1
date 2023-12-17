#! /bin/bash
if [ ! -d  /usr/data/printer_data/config/adxl_results/ ] #Check if we have an output folder
then
    mkdir /usr/data/printer_data/config/adxl_results/
fi

cd /tmp/
        /usr/data/printer_data/config/shape/scripts/calibrate_shaper.py calibration_data_x*.csv -o /usr/data/printer_data/config/adxl_results/calibration_data_x_`date +%F`.png # check
    echo "done shaper_X"
        /usr/data/printer_data/config/shape/scripts/calibrate_shaper.py calibration_data_y*.csv -o /usr/data/printer_data/config/adxl_results/calibration_data_y_`date +%F`.png # check
    echo "done shaper_Y"
       rm /tmp/calibration_*.csv
    echo "all shapers in folder adxl_results!"