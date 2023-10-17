**Как сделать график шейперов. алгоритм действий.**


 в файле gcode_macro.cfg   ищем секцию;
[gcode_macro INPUTSHAPER]
стираем всю ересь до следующей секции и вместо нее пишем:

```
[gcode_macro INPUTSHAPER]
gcode:
  G90
  G28
  SHAPER_CALIBRATE
  CXSAVE_CONFIG
```
в секции 
```
[gcode_macro AUTOTUNE_SHAPERS]
#variable_autotune_shapers: 'ei'
gcode:
```

ставим # перед второй строчкой как указано выше

проводим тест шейперов  с экрана или с веб интерфейса  макросом 
`INPUTSHAPER`
 

с помощью программы доступа по ssh достаем 2 файла  .csv из папки /tmp

качаем отсюда програмку 

https://github.com/theycallmek/Klipper-Input-Shaping-Assistant 

подсовываем ей файлы  - профит у нас есть графики шейперов.
как правильно читать и как правильно подобрать шейпер написано тут

https://github.com/Tombraider2006/klipperFB6/tree/main/accel_graph

после этого идем в вебинтерфейс и заходим в printer.cfg в самый низ конфига. там будет секция 
#*# [input_shaper]

там мы по своему разумению меняем на те шейперы которые вы подобрали.

**profit!**
