# Technical Documentation: Linux System Monitoring Dashboard (SysDash)

## 1. Project Overview
**SysDash** is a lightweight, real-time system monitoring utility developed in pure Bash. It provides a centralized terminal-based dashboard for tracking critical hardware performance metrics without requiring external dependencies like Python, Node.js, or specialized monitoring agents.

## 2. System Architecture
The application follows a **Procedural-Loop Architecture**:
- **Data Acquisition Layer**: Utilizes standard Linux `/proc` filesystem interfaces and core utilities (`top`, `free`, `df`, `ps`, `ip`) to fetch raw system data.
- **Processing Layer**: Employs `awk` and `bc` for real-time data parsing and mathematical calculations (e.g., percentage calculation for progress bars).
- **Presentation Layer**: Uses ANSI escape codes for color-coded terminal output and a dynamic refresh mechanism via a `while` loop.

## 3. Functional Requirements
The system successfully implements the following features:
- **CPU Monitoring**: Real-time load percentage and visual progress bar.
- **Thermal Management**: Real-time average CPU temperature sensing via `/sys/class/thermal/`.
- **Memory Management**: RAM utilization tracking (Used vs. Total) with percentage-based visualization.
- **Storage Analytics**: Root partition usage and specific directory size monitoring (recursive `du`).
- **Process Inspection**: Dynamic listing of the top 5 CPU-consuming processes.
- **Network Telemetry**: Real-time tracking of Received (RX) and Transmitted (TX) bytes on the primary active interface.

## 4. Non-Functional Requirements
- **Portability**: Compatible with any POSIX-compliant shell environment (Bash 4.0+ recommended).
- **Zero-Dependency**: No package manager (apt/yum/pacman) required for core functionality.
- **Low Overhead**: Minimal CPU and memory footprint during execution.
- **Extensibility**: Modular function design allows for easy integration of new metrics (e.g., GPU monitoring, IO wait).

## 5. Technology Stack
| Component | Technology |
| --- | --- |
| **Language** | Bash Scripting |
| **Data Parsing** | AWK, Sed |
| **Networking** | IProute2 |
| **Process Management** | Procps-ng |
| **Math Engine** | BC (Basic Calculator) |

## 6. Implementation Details
### Core Functions:
- `get_temp()`: Aggregates thermal zone data and calculates an average integer value in Celsius.
- `refresh_dashboard()`: The main UI engine that clears the terminal buffer and re-renders all metrics.
- `BAR_SIZE`: A configurable constant that defines the horizontal resolution of the visual progress bars.

## 7. Installation & Deployment
Users can deploy the application via a single-line fetch command:
```bash
curl -O https://raw.githubusercontent.com/nabothsithole/linux-sys-dash/main/sys_dash.sh
```

## 8. Maintenance & Version Control
The project is maintained using Git. The repository follows the `main` branch deployment strategy. All screenshots are stored in the `/screenshots` directory for visual verification of UI consistency across different terminal emulators.

## 9. License
Distributed under the **MIT License**.
