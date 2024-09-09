# Screenmode setting utility for kscreen-doctor (KDE Plasma 6)

This script uses kscreen-doctor on KDE Plasma 6 desktops to find and set the screen mode for the desired resolution and refresh rate, as well as set the HDR state and scaling.

## Dependencies
- bash
- kscreen-doctor
- jq

## Usage
```
usage: screenmode.sh [options] [mode]
    options:
        General
            -h          Print this help text
        Screen mode
        The screen mode will be set to the first
        one that matches all provided criteria
            -x 1920     Horizontal Resolution
            -y 1080     Vertical Resolution
            -r 60       Refresh Rate
        Screen settings
            -H 1        HDR Enabled
            -s 1.75     Fractional Scaling
    mode:
        The name of a kscreen-doctor screen mode
        to search for (such as 1920x1080@60) or
        a preset (4k or fhd).
        Options take precedent over mode.
```