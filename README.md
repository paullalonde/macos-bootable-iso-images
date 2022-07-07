# MacOS Installer Images

Contains utility scripts to construct ISO images containing a macOS installer.

Each script copies the installer app into the ISO image it's building.
So you need to have the app available locally at its normal location (i.e. `/Applications`).

Currently supported versions:

- macOS 10.15 Catalina
- macOS 11 Big Sur
- macOS 12 Monterey

### Requirements

Obviously, these scripts only run on macOS.
As of this writing, they have only been tested on macOS Monterey.

### Obtaining the installer app

Apple makes available download links for non-current versions of macOS.
The links are on [this page](https://support.apple.com/en-us/HT211683).

To download the installer app:

1. Click the link.
   This will take you to a Mac App Store web page, which will then open the Mac App Store locally.
1. Click the **GET** button.
   This will open System Preferences, initiating the download.

Download links:

- [macOS Catalina](https://apps.apple.com/ca/app/macos-catalina/id1466841314?mt=12)
- [macOS Big Sur](https://apps.apple.com/ca/app/macos-big-sur/id1526878132?mt=12)
- [macOS Monterey](https://apps.apple.com/app/macos-monterey/id1576738294?mt=12)

### Building the ISO image

Once the installer app is available locally, run its script.
There is a different script for each supported version of macOS:

- `bin/make-bootable-iso.catalina.sh`
- `bin/make-bootable-iso.bigsur.sh`
- `bin/make-bootable-iso.monterey.sh`

Once the script has finished, the ISO file is in the images directory, along with its SHA256 checksum.

### Troubleshooting

Disk Utility may interfere with the operation of the scripts.
Specifically, it may prevent volumes used in the ISO construction process from being detached.
It's best to quit it before running a script.
