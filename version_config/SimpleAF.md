[↩️ Back to main menu](../readme.md)

---

# 🚀 Overview and quick start for the Simple AF firmware

> An advanced firmware option — for this variant you need to additionally purchase a Z sensor

<h3 align="right"><a href="https://www.tinkoff.ru/rm/yakovleva.irina203/51ZSr71845" target="_blank">💝 Support the author</a></h3>

---

## 📑 Table of contents

- [📖 Introduction](#-introduction)
- [⚡ Problems of the stock firmware](#-problems-of-the-stock-firmware)
- [✨ Advantages of Simple AF](#-advantages-of-simple-af)
- [🎯 Sensor variants](#-sensor-variants)
- [🔧 Installation](#-installation)
- [📝 Slicer configuration](#-slicer-configuration)
- [💡 Useful macros](#-useful-macros)
- [🎓 Need help?](#-need-help)

---

## 📖 Introduction

Time doesn't stand still, and instead of the Helper Script which was meant to patch obvious holes at the initial sales of the K1 line, [...]

**Purpose of this article:** Explain why the [**Simple AF**](https://pellcorp.github.io/creality-wiki/) firmware is needed, what the benefits are, and how to quickly [...]

---

## ⚡ Problems of the stock firmware

This modification aims to solve several problems present in the stock firmware that cannot be fixed even by [...]

### 1. Long startup and inaccurate testing

The initial Z-axis test, nozzle purge, the "parade" of sensor tests. In the Simple AF firmware the native tests [...]

### 2. KAMP algorithm limitation

Due to the poor implementation of the Z-sensor module, the algorithm works only with grids 3×3, 4×4, 5×5 and so on. Assigned [...]

### 3. Lagging behind modern trends

The Input Shaping algorithm, Adaptive Mesh and much more have received development, unlike the firmware which is still in the same [...]

Cosmetic improvements haven't eliminated the lag, and in some places introduced new problems. *For example, in new firmware builds [...] 

**We are forced to tolerate all this because Creality chose its own path for developing Z-axis sensors which [...]

---

## ✨ Advantages of Simple AF

A few points from the firmware site about the positives of this solution:

1. ✅ **Open source** - Simple AF uses open source software, and all of its source code is public

2. ✅ **Simple configuration** - all macros and configuration files are in the config directory and available to you, nothing is hidden [...]

3. ✅ **Updated Klipper** - the Klipper version we use, although a fork from the main version, regularly [...]

On the Simple AF site you can read about installing various firmware variants and **the main thing is to choose** [...]

---

## 🎯 Sensor variants

### ⚠️ Important recommendation

**I recommend not choosing** `microprobe`, `Klicky`, `Bltouch` if you are chasing speed. The algorithm does not gain much [...]

### Contact sensors (slow):

#### 1. BLTouch
- ✅ The cheapest / requires minimal effort to install the firmware
- ❌ The least accurate (you can get a sensor assembled in the basements of endless China)

#### 2. Klicky
- ✅ Cheap
- ⚠️ Requires time and steady hands
- Accuracy highly depends on build quality
- Slightly reduces the usable bed area

#### 3. Microprobe
- ✅ Branded sensor
- ✅ High accuracy
- ❌ But in most cases such precision is unnecessary
- ❌ Tests will be slow

### Eddy-current sensors (FAST!) ⚡

Variants `Cartographer`, `Beacon`, `BTT Eddy` use eddy-current measurement and are **currently the fastest** [...]

**Speed comparison:**
- Strain sensors: 5×5 = 25 points → ~2–3 minutes
- Eddy-current: 20×20 = 400 points → **8 seconds!**

**Agree, the difference is more than significant.** 🚀

⚠️ **Attention!** If you print on glass — this method is not suitable, because correct detection [...]

#### 1. BTT Eddy

- ✅ The cheapest among eddy-current sensors
- ✅ The simplest installation option
- ⚠️ "Temperature drift" — readings depend on the sensor temperature
- 💡 I have to monitor the first layer at the beginning of a print and quickly compensate using Z-offset
- 🛒 On marketplaces choose the **DUO** variant, not **COIL**!

#### 2. Cartographer

- ✅ Has additional modules inside
- ⚡ Slightly more expensive and slightly faster
- ✅ Less prone to temperature drift (but watching the first layer doesn't hurt)
- 🛒 Search for: **Cartographer v3 USB** (NOT CAN!)
- 📦 The board comes in two parts: **not welded** (not soldered), **low** (compact), **vertical** (flat tall)
- 💡 If you're not sure about the mounting option — take **not welded**, you can solder later

#### 3. Beacon

- ✅ The most accurate option
- ⚠️ Expensive
- **IMO it's unnecessary to overpay**
- Less susceptible to temperature drift (but watching the first layer still helps)

---

## ⚠️ IMPORTANT! ATTENTION!

**All changes you make are at your own risk.** Don't go to the manufacturer asking for warranty support after you damaged the printer by [...]

---

## 🔧 Installation

So, you decided on the sensor type and selected the appropriate firmware variant on the firmware site. You installed and [...]

### 🎬 Video instructions

*For those who prefer video, there are several good YouTube videos:*

- **[Cartographer](https://www.youtube.com/watch?v=GuxMITM9o4I)** — Cartographer installation
- **[BTT Eddy](https://www.youtube.com/watch?v=B17sS1klRxA)** — BTT Eddy installation
- **[Flashing Cartographer from Windows 10-11](https://github.com/Tombraider2006/Ender5Max/blob/main/mans/wsl.md)** — working through WSL

⚠️ *Remember that everything changes, so video instructions may contain inaccuracies in some [...] 

### Installation order:

#### 1. Install the sensor and mounting

Choose the sensor and mount, then install it.

⚠️ **Important for eddy-current sensors:** You should flash firmware into the sensor itself. This procedure should be [...]

#### 2. Factory reset

First we need to bring the firmware back to factory defaults. We can:

**Option A:** Reset via the screen to factory settings

**Option B:** Use the script (will keep root access and saved WiFi networks):

```bash
wget --no-check-certificate https://raw.githubusercontent.com/pellcorp/creality/main/k1/services/S58factoryreset -O /tmp/S58factoryreset
chmod +x /tmp/S58factoryreset
/tmp/S58factoryreset reset
```

**Option C:** If you already have Helper Script installed, just run in the SSH console:

```bash
/etc/init.d/S58factoryreset reset
```

This command will reset the firmware to factory settings. Wait for the line:

`Info: Factory reset was executed successefuly, the printer will restart...`

After that the printer will restart and reconnect.

#### 3. Download required files

Run this block in the SSH console:

```
git config --global http.sslVerify false
git clone https://github.com/pellcorp/creality.git /usr/data/pellcorp
sync

```

#### 4. Choose installation variant

Depending on the sensor and mount, the install command will differ. Check the original [...]

💡 **Tip:** Where possible, pick a mounting option that offsets the sensor from the nozzle **only along one axis** [...]

**Example:** You picked the [BTT Eddy](https://pellcorp.github.io/creality-wiki/btteddy/#probe-installation) sensor and the [Pellcorp](https://www.printabl[...]) mount.

In the mount description we see `X Offset = 0 Y Offset = 24.82`  
Since X offset is 0 — **fewer settings and tests!** ✅

In the SSH console we need to specify the mount type in the installer command.

So instead of:
```bash
/usr/data/pellcorp/k1/installer.sh --install btteddy --mount Mount
```

Our command will look like:
```bash
/usr/data/pellcorp/k1/installer.sh --install btteddy --mount Pellcorp
```

**After this** go make tea, coffee, have a smoke ☕🚬 — the installation takes **from 5 minutes [...]**

⚠️ *If that's not the case and after entering the command it thought for 10 seconds, printed a few lines and stopped — it means you [...] 

---

### After installation

#### Possible MCU firmware update

If at the end of the installation you see the following message:

`WARNING: MCU Firmware updates are pending you need to power cycle your printer!`

This means MCU firmware updates need to be applied and can **only** be done by power-cycling the printer.

After turning the printer off and on again you can check whether the MCU firmware was updated by [...]

✅ If you see this message: `INFO: Your MCU Firmware is up to date` — then everything is fine.

#### ⚠️ Screen calibration

**If!** after flashing the printer prompts you to calibrate the screen — **do not ignore it**, otherwise the touch [...]

#### 5. Post-installation tests

After installation we need to run tests to determine the exact Z position. For this, for each [...]

---

## 💡 Useful macros

### General macros for all firmware:

To avoid looking through an ocean of unnecessary macros, you can use the [**guide**](/macros_helpfull/readme.md) which [...]

### Macro list:

#### `PID_CALIBRATE_HOTEND`
A calibration procedure that ensures the printer will always maintain stable target temperature [...]

#### `PID_CALIBRATE_BED`
PID calibration procedure for stable bed temperature.

#### `BELTS_SHAPER_CALIBRATION`
Performs a resonance test and creates a belt tension graph. More details [**read here**](/random/belts/readme.md)  
⚠️ The difference from the guide is that graphs will be placed in the root folder.

#### `EXCITATE_AXIS_AT_FREQUENCY`
A macro to test at a specific resonance frequency to find assembly defects.

![](/macros_helpfull/image4.jpg)

**How to use:** In the image above you can see default values — at frequency 25 Hz for 10 seconds the axis is shaken [...]

**To perform the test:**
1. Start with 3–5 seconds
2. By trying frequencies (25, 27, 30 Hz...) find the frequency with maximum vibration
3. Set the test time to 30–40 seconds
4. **Feeling the case by hand**, find the node causing resonance
5. Inspect externally to find the problem (loose screw, detached panel, under-tightened bolt, etc.)

#### `INPUT_SHAPER_GRAPHS`
Runs a resonance test and saves it to a graph. More details [**read here**](/shaper/readme.md)  
⚠️ The difference from the guide is that graphs will be stored in the root folder.

#### `INPUT_SHAPER`
Runs a resonance test and writes the result into `printer.cfg`

---

## 📝 Slicer configuration

### Firmware Retraction

This firmware's configuration files already include support for `firmware retraction`, however in the slicer [...]

#### Step 1: Configure in OrcaSlicer

In Orca open printer settings and check **"Use firmware retraction"**

![](/retract/orca1.jpg)

#### Step 2: Add G-code

Then add this block to the printer start G-code:

```gcode
SET_RETRACTION RETRACT_LENGTH=[retraction_length] RETRACT_SPEED=[retraction_speed] UNRETRACT_EXTRA_LENGTH=[retract_restart_extra] UNRETRACT_SPEED=[deretraction_speed]
RESPOND TYPE=command MSG="Retraction length set to [retraction_length]mm" 
RESPOND TYPE=command MSG="Retract speed set to [retraction_speed]/[deretraction_speed]mm/c"
```

![](/retract/orca2.jpg)

⚠️ **Don't forget** to enter the retraction length value for your filament when configuring!

**For example:** 

![](/retract/orca3.jpg)

---

## 🎓 Need help?

If after reading you want to install this firmware but are not confident in your skills — you can contact [...]

---

<div align="center">

**[↩️ Return to main menu](../readme.md)**

</div>
