# OpenType

Open-source typing tutor - Reverse engineered from TypingMaster v2.0.1

## Features

- 4 practice modes: Words, Timed, Quote, Adaptive Drills
- 80+ themes with auto dark/light switching
- Per-key heatmap with accuracy tracking
- WPM, accuracy, and session statistics
- Multiple user profiles
- CSV export
- Focus mode for distraction-free typing

## Build

### Requirements

- CMake 3.16+
- Qt6 (6.2+)
- C++17 compiler
- libxkbcommon-dev
- libpulse-dev

### Build Instructions

```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### Run

```bash
./OpenType
```

## Technology Stack

- **Framework**: Qt6/QML
- **Language**: C++17
- **Build**: CMake
- **UI**: Qt Quick Controls 2

## Credits

- Original TypingMaster: Keshav Bhatt (KTechpit)
- https://github.com/keshavbhatt/typingmaster-packaging
- https://flathub.org/en/apps/com.ktechpit.typingmaster

## License

MIT License - See [LICENSE](LICENSE) for details
