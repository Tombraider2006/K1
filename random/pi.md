<h2>Зачем нам одноплатник</h2>

Если у вас нет еще умного дома и есть принтер то хорошей покупкой может стать небольшой одноплатный компьютер расширяющий возможности нашего принтера.

Дело в том что на принтере устанавлена сильно кастрированная операционная система, которая не даст воспользоваться благами цивилизации которые возможны с обычным клиппером. Рассматривать примеры мы будем на примере Orange PI мою статью по установке операционной системы на нее можно почитать [тут](https://3d-diy.ru/blog/ustanovka-os-na-orange-pi-3-lts/)

<h3>Telegram Bot</h3>

Уведомления в боте контроль  параметров во время печати, все это и многое другое доступно при использовании телеграм бота. вот пример что можно увидеть при использовании:

![](/random/images/telegram.png)

чтобы это заработало на удаленном сервере необходимо поставить [KIAUH](https://github.com/dw-0/kiauh) создать папку `/home/pi/printer_data/config`  и в ней положить конфиг телеграмм бота `telegram.conf`

содержимое файла:

```
[bot]
server: ваш_IP:7125
bot_token: ваш токен
chat_id: ваш чат айди



[camera]
host: http://ваш_IP:4408//webcam/?action=stream

[progress_notification]
time: 60

[telegram_ui]
buttons: [status,pause,cancel,resume],[files,emergency,macros,shutdown]
silent_progress: true
hidden_macros: ACCURATE_G28, AUTOTUNE_SHAPERS, BED_LEVELING, BED_MESH_CALIBRATE, END_PRINT_POINT, DEFINE_OBJECT, END_CURRENT_OBJECT, END_PRINT, END_PRINT_POINT_WITHOUT_LIFTING, FIRST_FLOOR_PAUSE, FIRST_FLOOR_PAUSE_POSITION, FIRST_FLOOR_RESUME, G29, GET_TIMELAPSE_SETUP, HYPERLAPSE, INPUTSHAPER, KAMP_BED_MESH_SETTINGS, KAMP_PURGE_LINE_SETTINGS, KLIPPER_BACKUP_CONFIG, KLIPPER_RESTORE_CONFIG, LIST_EXCLUDED_OBJECTS, LIST_OBJECTS, LOAD_MATERIAL, LOAD_MATERIAL_CLOSE_FAN2, LOAD_MATERIAL_RESTORE_FAN2, M106, M107, M141, M191, M204, M205, M900, MOONRAKER_BACKUP_DATABASE, MOONRAKER_RESTORE_DATABASE, PID_BED, PRINT_CALIBRATION, PRINT_PREPARE_CLEAR, PRINT_PREPARED, PRINTER_PARAM, QUIT_MATERIAL, REMOVE_ALL_EXCLUDED, RESTORE_E_CURRENT, SET_E_MIN_CURRENT, SET_GCODE_OFFSET, START_CURRENT_OBJECT, START_PRINT, TEST_STREAM_DELAY, TIMELAPSE_RENDER, TUNOFFINPUTSHAPER, TIMELAPSE_TAKE_FRAME, WAIT_TEMP_END, WAIT_TEMP_START, XYZ_READY

silent_commands: true

[status_message_content]
content: progress, height, filament_length, filament_weight, print_duration, eta, finish_time, m117_status, tgnotify_status, last_update_time
sensors: mcu, chamber_temp
heaters: extruder, heater_bed, orange_pi, mcu_temp
fans: fan0, chamber_fan, soc_fan, fan2

```
не забываем поправить ip принтера а также вставить чат айди и токен.  больше инструкций можно найти на [вики проекта](https://github.com/nlef/moonraker-telegram-bot)


<h3>Spoolman</h3>

Spoolman — это самостоятельный веб-сервис, разработанный для того, чтобы помочь вам эффективно управлять катушками филамента для 3D-принтера и контролировать их использование. Он действует как централизованная база данных, которая легко интегрируется с популярным программным обеспечением для 3D-печати, Klipper / Moonraker . При подключении он автоматически обновляет вес катушек по мере печати, предоставляя вам информацию об использовании филамента в режиме реального времени.

Функции:
+ Управление нитью : ведите подробный учет типов филамента, производителей и отдельных катушек.
+ Интеграция API : API REST обеспечивает простую интеграцию с другим программным обеспечением, облегчая автоматизацию рабочих процессов и обмен данными.
+ Обновления в режиме реального времени : будьте в курсе событий благодаря обновлениям в режиме реального времени через Websockets, обеспечивая немедленную обратную связь во время операций печати.
+ Центральная база данных филаментов : поддерживаемая сообществом база данных производителей и нитей упрощает добавление новых катушек в ваш инвентарь. 
+ Веб-клиент : Spoolman включает в себя встроенный веб-клиент, который позволяет вам легко управлять данными:
Просмотр, создание, редактирование и удаление данных о филаментах.
+ Добавьте пользовательские поля, чтобы адаптировать информацию к вашим конкретным потребностям.
+ Печатайте этикетки с QR-кодами для легкой идентификации и отслеживания катушек.

+ Управление несколькими принтерами : позволяет одновременно обрабатывать обновления спула с нескольких принтеров.

![](/random/images/spoolman.png)

после установки [отсюда](https://github.com/Donkie/Spoolman)

необходимо указать в файле `moonraker.conf` следующие строки

```
[spoolman]
server: http://ваш_IP:7912
#   URL to the Spoolman instance. This parameter must be provided.
sync_rate: 5

```
вместо `ваш_IP` указываем ip-адрес сервера spoolman


![](/random/images/spollman2.png)

<h3>KlipperScreen</h3>

Если у вас есть экран с тач скрином ну или лишний монитор с мышкой то ваш одноплатник может выступить в качестве дополнительного экрана вашего принтера, даже если он находится в другой комнате)

![](/random/images/klipperscreen1.png)

Необходимо поставить [KIAUH](https://github.com/dw-0/kiauh) и через него установить klippersreen более подробно можно почитать [тут](https://github.com/KlipperScreen/KlipperScreen)


![](/random/images/klipperscreen2.png)