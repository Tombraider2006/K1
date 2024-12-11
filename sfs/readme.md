<h3 align="right"><a href="https://www.tinkoff.ru/rm/yakovleva.irina203/51ZSr71845" target="_blank">ваше "спасибо" автору</a></h3>
<h3 align="right"><a href="https://t.me/tombraider2006" target="_blank">телеграм канал автора</a></h3>
<h5 align="right">поставьте "звездочку" проекту. так другим пользователям легче его найти.</h5>


<h1>Способ Номер 1</h1>
При печати на 3D принтере решил обезопасить себя не только паузой при окончании филамента, но также в случае перехлеста или другой причине остановки подачи пластика в экструдер  

Дляя этого был приобретен  датчик филамента ВТТ sfs v2.0




Решил припаяться к материнской плате. 

Так как короб с проводами вскрывать не хотелось, то отрезал контакты от купленного датчика с одной стороны (где их 2) просунул между проводами родного датчика и вытянул провода от родного датчика филамента, заодно протянув провода для нового. 

![](1.jpg)

*Вот это отрезал*

Далее берем SMD резистор 0402 на 100 ом (можно 0805)

Припаиваем резистор  сюда:

![](2.jpg)

![](3.jpg)

*На этой фотографии видно лучше.*

Чтобы проверить правильность пайки - берем тестер и замеряем сопротивление - должно быть 100 Ом

![](4.jpg)

Один щуп сюда, второй на дальнее отверстие разъема
Далее берем 3-пиновый разъём PH2.0 (можно и XH2.54 , но придется чуть подогнуть ножки)

![](5.jpg)

Соединение делаем так - цвета линий соответствуют цвету проводов от датчика.

![](6.jpg)

Из инструкции
Для принтера на klipper и/или стоковой прошивке  вносим правки в `printer.cfg`

Надо закомментировать/удалить код, который прописан был для родного датчика и вписать следующий код:

```
[filament_switch_sensor filament_sensor]
switch_pin: ^PC15
pause_on_runout: False
runout_gcode:
 PAUSE # [pause_resume] is required in printer.cfg
 M117 filament_switch_runout
insert_gcode:
 M117 Filament switch inserted


[filament_motion_sensor encoder_sensor]
switch_pin: ^PA7
detection_length: 5.3
extruder: extruder
pause_on_runout: False
runout_gcode:
 PAUSE # [pause_resume] is required in printer.cfg
 M117 filament_encoder_runout
insert_gcode:
 M117 Filament encoder inserted

 ```
Перезагрузить прошивку и всё должно работать.

Можно поменять синий и зеленый провода местами, при этом не забудьте поменять пины в вышеуказанном коде. 

P.S. Про длину (detection_length) 

Параметр `detection_length: 5.3` 

отвечает за длину в мм за которое должен поступить сигнал от энкодера, если этого не происходит, то датчик дает сигнал о том, что нить перестала двигаться.

Производитель рекомендует поставить 2.88, но по факту подбора у меня перестали быть ложные срабатывания только на 5.3



P.S.S. **Про подтяжки**

В процессе тестирования выяснилось, что нужна подтяжка обоих сигнальных пинов к питанию. Есть 2 варианта - в конфиге перед именем пина дописать "^" (сейчас в коде выше так и указано), либо напаять внутрь SFS (место там есть) физические подтяжки из резисторов 10кОм. По совету сообщества пошел по второму пути, но будет работать и первый способ.

Для способа с резисторами в коде должно быть так:
```
[filament_switch_sensor filament_sensor]
switch_pin: PC15
```

```
[filament_motion_sensor encoder_sensor]
switch_pin: PA7
```

![](7.jpg)

Вид датчика с лицевой стороны

![](8.jpg)

С обратной стороны (еще без резисторов)

![](9.jpg)

результат

![](10.jpg)

Можно и так

[спасибо за мануал](https://telegra.ph/Datchik-filamenta-sfs-20-dlya-k1c-09-30)


<h1>Способ номер 2</h1>

в способе номер 2 мы будем использовать только штатную проводку, точнее, только датчик движения. Если нить заканчивается, то будет определено, что «не движется», и принтер встанет на паузу.
Вам не нужно лезть в материнскую плату, или куда либо еще, чтобы подключить новый датчик. Единственный отрицательной момент в том, что будет гореть иконка  "не вставлен филамент" на экранчике принтера так как мы сменили тип датчика но это будет раздражать только законченных пефекционистов, остальные рыжие 4на4 пикселя переживут.

Разводка по проводам следующая:

![](n2.png)

Далее заходим в `printer.cfg` и ищем строки:

```
[filament_switch_sensor filament_sensor]
pause_on_runout: true
switch_pin: !PC15
runout_gcode:
  {% if printer.extruder.can_extrude|lower == 'true' %}
    G91
    G0 E30 F600
    G90
  {% endif %}
```
эти строки стираем и вписываем вместо них:

```
[filament_motion_sensor filament_sensor]
detection_length: 5.3
extruder:extruder
pause_on_runout: true
switch_pin: ^PC15
runout_gcode:
  RESPOND TYPE=command MSG="Filament runout/blocked!"
  UPDATE_DELAYED_GCODE ID=sfs_alarm DURATION=1
insert_gcode:
  RESPOND TYPE=command MSG="Filament inserted"
  UPDATE_DELAYED_GCODE ID=sfs_alarm DURATION=0

[delayed_gcode sfs_alarm]
# initial_duration: 2
gcode:
  beep # звуковой сигнал если заканчивается филамент во время печати.
```


Строка с `beep` если у вас к1с вам не нужна, у вас нет пищалки. так же будет выдавать ошибку если вы не установили в своем принтере Buzzer Support через Helper Script.  Если у вас нет пищалки или вы не устанавливали - смотрите второй вариант кода ниже.

Мне тут не спалось и решил я что пользователям к1с как то обидно будет что нет у них никакой сигналки при паузе по движению поэтому немного переписал модуль чтобы моргал подсветкой 3 раза. Не супер, но хоть что то.

```
[filament_motion_sensor filament_sensor]
detection_length: 5.3
extruder:extruder
pause_on_runout: true
switch_pin: ^PC15
runout_gcode:
  RESPOND TYPE=command MSG="Filament runout/blocked!"
  UPDATE_DELAYED_GCODE ID=sfs_alarm DURATION=1
insert_gcode:
  RESPOND TYPE=command MSG="Filament inserted"
  UPDATE_DELAYED_GCODE ID=sfs_alarm DURATION=0
  SET_PIN PIN=LED VALUE=1

[delayed_gcode sfs_alarm]
# initial_duration: 0
gcode:
  SET_PIN PIN=LED VALUE=0
  G4 P500
  SET_PIN PIN=LED VALUE=1
  G4 P1000
  SET_PIN PIN=LED VALUE=0
  G4 P500
  SET_PIN PIN=LED VALUE=1
  G4 P1000
  SET_PIN PIN=LED VALUE=0
  G4 P500
  SET_PIN PIN=LED VALUE=1
  G4 P1000
```

модель для установки [скачать тут](BTT_SFS.zip) крепится штатными винтами из комплекта к креплению.

![](2_1.jpg)

![](2_2.jpg)

![](2_3.jpg)

![](2_4.jpg)

![](2_5.jpg)
