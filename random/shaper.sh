#!/bin/sh

# Очистка экрана
clear

# Цвета
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

CFG="/usr/data/printer_data/config/printer.cfg"
KLIPPER_PATH="/usr/share/klipper/klippy"
EXTRAS_PATH="$KLIPPER_PATH/extras"

echo_green() { printf "$GREEN$1$RESET\n"; }
echo_red()   { printf "$RED$1$RESET\n"; }
echo_yellow(){ printf "$YELLOW$1$RESET\n"; }

loading_animation() {
    msg="$1"
    printf "%s" "$msg"
    i=0
    while [ $i -lt 3 ]; do
        printf "."
        sleep 1
        i=$((i + 1))
    done
    printf "\n"
}

update_k1s_k1max() {
    echo_green "=== Обновление Klipper модулей для K1 / K1C / K1 Max ==="

    cd "$KLIPPER_PATH" || { echo_red "Ошибка: не найден $KLIPPER_PATH"; return 1; }

    if [ -f "$KLIPPER_PATH/toolhead.py.bak" ]; then
        echo_yellow "[!] Найден toolhead.py.bak — обновление уже проводилось"
    else
        loading_animation "Резервное копирование toolhead.py"
        mv toolhead.py toolhead.py.bak 2>/dev/null
        rm -f toolhead.pyc
    fi

    loading_animation "Загрузка нового toolhead.py"
    wget --no-check-certificate -q -P "$KLIPPER_PATH"       https://raw.githubusercontent.com/Konstant-3d/K1C-mods/refs/heads/main/usr/share/klipper/klippy/toolhead.py || { echo_red "Ошибка загрузки toolhead.py"; return 1; }
    chmod 644 toolhead.py

    cd "$EXTRAS_PATH" || { echo_red "Ошибка: не найден $EXTRAS_PATH"; return 1; }

    if [ -f "$EXTRAS_PATH/resonance_tester.py.bak" ] || [ -f "$EXTRAS_PATH/shaper_calibrate.py.bak" ]; then
        echo_yellow "[!] Найдены .bak-файлы extras — обновление уже проводилось"
    else
        loading_animation "Резервное копирование extras"
        mv resonance_tester.py resonance_tester.py.bak 2>/dev/null
        mv shaper_calibrate.py shaper_calibrate.py.bak 2>/dev/null
        rm -f resonance_tester.pyc shaper_calibrate.pyc
    fi

    loading_animation "Загрузка новых extras"
    wget --no-check-certificate -q -P "$EXTRAS_PATH"       https://raw.githubusercontent.com/Konstant-3d/K1C-mods/refs/heads/main/usr/share/klipper/klippy/extras/resonance_tester.py || { echo_red "Ошибка загрузки resonance_tester.py"; return 1; }
    wget --no-check-certificate -q -P "$EXTRAS_PATH"       https://raw.githubusercontent.com/Konstant-3d/K1C-mods/refs/heads/main/usr/share/klipper/klippy/extras/shaper_calibrate.py || { echo_red "Ошибка загрузки shaper_calibrate.py"; return 1; }
    chmod 644 resonance_tester.py shaper_calibrate.py

    loading_animation "Применение патча printer.cfg"
    sed -i 's/accel_per_hz: 75/accel_per_hz: 60/' "$CFG"

    grep -q "sweeping_period: 0" "$CFG"
    if [ $? -ne 0 ]; then
        sed -i '/resonance_tester/{
        n
        n
        n
        n
        n
        n
        a\
        sweeping_period: 0
        }' "$CFG"
        echo_green "Добавлен параметр sweeping_period: 0"
    else
        echo_yellow "Параметр sweeping_period: 0 уже существует — пропуск"
    fi

    echo_green "=== Обновление завершено успешно! ==="
    return 0
}

update_k1se() {
    echo_yellow "=== Установка обновлений для K1SE (прошивка 1.3.5.11) ==="

    cd "$KLIPPER_PATH" || { echo_red "Ошибка: не найден $KLIPPER_PATH"; return 1; }

    mv toolhead.py toolhead.py.bak1 2>/dev/null

    wget --no-check-certificate -q -P "$KLIPPER_PATH"       https://raw.githubusercontent.com/Konstant-3d/K1C-mods/refs/heads/main/usr/share/klipper/klippy/toolhead_1_3_5_11.py || { echo_red "Ошибка загрузки toolhead_1_3_5_11.py"; return 1; }

    mv "$KLIPPER_PATH/toolhead_1_3_5_11.py" "$KLIPPER_PATH/toolhead.py"
    chmod 644 toolhead.py

    echo_green "=== Изменения применены. Перезагрузка... ==="
    reboot
    return 0
}

rollback() {
    echo_yellow "=== Откат изменений для K1 / K1C / K1 Max ==="

    if [ ! -f "$CFG" ]; then
        echo_red "Файл $CFG не найден!"
        return 1
    fi

    cp "$CFG" "$CFG.bak"

    sed -i 's/accel_per_hz: 60/accel_per_hz: 75/' "$CFG"
    sed -i '/sweeping_period: 0/d' "$CFG"

    echo_green "=== Откат завершён успешно! ==="
    return 0
}

# === Меню ===
while true; do
    clear
    # === Шапка ===
    printf "$GREEN"
    printf "=======================================================\n"
    printf " /\\_/\\   K1 / K1C / K1 Max Mods\n"
    printf "( o.o )  (by Tom Tomich)\n"
    printf " > ^ <   Автоматическое обновление и откат алгоритм shaper\n"
    printf "=======================================================\n"
    printf "$RESET\n"

    printf "\n$GREENВыберите действие:$RESET\n"
    printf "  1) Установить обновление для K1 / K1C / K1 Max\n"
    printf "  2) Установка обновлений для K1SE (1.3.5.11) только!\n"
    printf "  3) Откатить изменения\n"
    printf "  4) Выйти\n"
    printf "Введите номер: "
    read choice

    case "$choice" in
        1)
            update_k1s_k1max
            [ $? -eq 0 ] && echo_green "✔ Установка выполнена" || echo_red "✘ Ошибка установки"
            printf "\nНажмите Enter для продолжения..."
            read dummy
            ;;
        2)
            update_k1se
            printf "\nНажмите Enter для продолжения..."
            read dummy
            ;;
        3)
            rollback
            [ $? -eq 0 ] && echo_green "✔ Откат выполнен" || echo_red "✘ Ошибка отката"
            printf "\nНажмите Enter для продолжения..."
            read dummy
            ;;
        4)
            echo_green "Выход из программы."
            exit 0
            ;;
        *)
            echo_red "Неверный выбор, попробуйте снова."
            printf "\nНажмите Enter для продолжения..."
            read dummy
            ;;
    esac
done
