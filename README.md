# OpenType

Open-source typing tutor - Reverse engineered from TypingMaster v2.0.1

## Download (any Linux distro)

**AppImage (recommended — no install, runs everywhere):**

```bash
chmod +x OpenType-1.4.0-x86_64.AppImage
./OpenType-1.4.0-x86_64.AppImage
```

**Debian/Ubuntu package (Ubuntu 24.04+, Mint 22+, amd64):**

```bash
sudo apt install ./opentype-1.4.0-amd64.deb
OpenType
```

**Flatpak (sandboxed, distro-independent):**

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install org.kde.Platform//6.8 org.kde.Sdk//6.8
flatpak-builder --user --install build-dir io.github.AmiXDme.OpenType.yml
flatpak run io.github.AmiXDme.OpenType
```

> Note: the AppImage bundles its own Qt 6 libraries, so it runs on Ubuntu,
> Fedora, Arch, Mint and others without installing dependencies. It was built
> on a recent distro, so very old releases (pre-2023 glibc) should prefer the
> Flatpak instead.

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
- App icon artwork: original TypingMaster icon by Keshav Bhatt (used with attribution; will be replaced with original artwork on request)

## License

MIT License - See [LICENSE](LICENSE) for details
