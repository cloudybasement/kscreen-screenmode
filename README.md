# Screenmode setting utility for kscreen-doctor (KDE Plasma 6)

This script uses kscreen-doctor to find and set the resolution, refresh rate, HDR state and scaling matching criteria provided by the user.

## Usage
```
usage: screenmode.sh [options] [mode]
        options:
            -h          Print this help text
            -x 1920     Horizontal Resolution
            -y 1080     Vertical Resolution
            -r 60       Refresh Rate
            -H 1        HDR Enabled
            -s 1.75     Fractional Scaling
        mode:
            The name of a kscreen-doctor screen mode
            to search for (such as 1920x1080@60) or
            a preset (4k or fhd).
            Options take precedent over mode.
```