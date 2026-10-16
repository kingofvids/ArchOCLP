# ArchOCLP — Linux-side OpenCore Legacy Patcher prototype

**Version:** 0.1.0 · **Runtime:** Python 3.10+ · **Dependencies:** Python standard library only

ArchOCLP is a first-stage Arch Linux project for detecting a Mac from SMBIOS/DMI data and creating a per-model OpenCore build workspace. The current release is a **detector and build planner**, not yet a replacement for upstream OpenCore Legacy Patcher and not yet capable of generating a bootable EFI.

This distinction is intentional. OpenCore configurations are model-specific, and upstream OCLP relies on its own builder, payloads and hardware probing. A generic `config.plist` can fail to boot. ArchOCLP therefore never claims it generated an EFI, never writes to an EFI partition and never changes firmware/NVRAM.

## Quick start on Arch Linux

Python is normally available as `python`; install it if needed:

```bash
sudo pacman -S --needed python
```

Run from this folder:

```bash
./archoclp detect
./archoclp models
./archoclp build --output ~/archoclp-build
```

Optional user-local command installation:

```bash
./install.sh
# then open a new shell if ~/.local/bin was not already in PATH
archoclp detect
```

When run on a detected Mac, `build` automatically uses the model identifier read from `/sys/class/dmi/id`. The tool will also try `dmidecode` as a fallback if installed and readable.

Cross-build a workspace for a target Mac from another machine:

```bash
python archoclp.py build --model MacBookPro9,2 --output ~/archoclp-build
```

Example output:

```text
archoclp-build/
└── MacBookPro9,2/
    ├── manifest.json
    └── REPORT.md
```

`manifest.json` is meant to become the input contract for a future Linux EFI builder. `REPORT.md` gives the identified model and any current profile notes. `models.json` can be edited or replaced to add reviewed model hints.

## Commands

- `detect` — report SMBIOS/DMI values, detected model, host OS and architecture.
- `models` — list the included sample model profiles.
- `build` — make a per-model planning workspace. Despite the command name, v0.1.0 does not emit an EFI.

Useful overrides for testing:

```bash
python archoclp.py detect --sysfs-root ./tests/fixtures/macbookpro92
python archoclp.py build --model MacBookPro9,2 --output ./out
```

## Why this is not a full OCLP port yet

A real Linux port still needs to adapt upstream's configuration builder and asset pipeline, replace/macOS-gate APIs such as I/O Registry probing and NVRAM access, provide verified model-specific settings, fetch version-matched OpenCore/kext/ACPI payloads, and run `ocvalidate`. Root patching of an installed macOS volume is a separate project and is not implemented here.

The official project's supported-model list and build guide are the source of truth:

- https://dortania.github.io/OpenCore-Legacy-Patcher/MODELS.html
- https://dortania.github.io/OpenCore-Legacy-Patcher/BUILD.html
- https://github.com/dortania/OpenCore-Legacy-Patcher

The current sample database contains selected model hints, not the full OCLP model list. It is not evidence that every listed model is supported by every current macOS release. GPU, Wi-Fi/Bluetooth, storage, and OS-version details must be verified on the actual Mac.

## Safety

- This tool has no code that formats disks, mounts EFI partitions, runs `bless`, edits NVRAM, or writes to firmware.
- Never install an EFI you have not validated and tested from removable media.
- Back up important data and retain a known-good boot path before experimenting with OpenCore.

## Tests

```bash
python -m unittest discover -s tests -v
```

## License

MIT license for this prototype; OpenCore Legacy Patcher and its resources remain the property and license of their respective upstream authors. This project is not affiliated with or endorsed by Dortania.
