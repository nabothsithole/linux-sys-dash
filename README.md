# Linux System Monitoring Dashboard

A lightweight, real-time system monitoring dashboard written in pure Bash. No external dependencies (like Python or Node) required—works on almost any Linux distribution out there.

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features
- 📊 **CPU Performance**: Real-time load bar and average temperature.
- 🧠 **Memory Usage**: Visual RAM usage bar with MB/GB stats.
- 📂 **Storage Tracking**: Monitor root partition and a specific folder size.
- 🔝 **Top Processes**: See the top 5 CPU-consuming tasks.
- 🌐 **Network Stats**: Monitor RX/TX data on your active interface.

## Screenshots
![Dashboard Screenshot 1](screenshots/Screenshot%20from%202026-03-09%2009-27-02.png)
![Dashboard Screenshot 2](screenshots/Screenshot%20from%202026-03-09%2009-27-49.png)

## Installation

### 1. Download the script
```bash
curl -O https://raw.githubusercontent.com/nabothsithole/linux-sys-dash/main/sys_dash.sh
```

### 2. Make it executable
```bash
chmod +x sys_dash.sh
```

### 3. (Optional) Install system-wide
To run it by just typing `sysdash` from any folder:
```bash
sudo cp sys_dash.sh /usr/local/bin/sysdash
```

## Usage
Simply run the script:
```bash
./sys_dash.sh
```
Or if installed system-wide:
```bash
sysdash
```

## Requirements
Uses standard Linux tools: `bash`, `top`, `free`, `df`, `awk`, `ps`, and `ip`.

## License
MIT License. Feel free to use and modify!
