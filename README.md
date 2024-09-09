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
            -s 1.75     Fractional scaling factor
                        or "auto" to find 1080p
                        equivalent (i.e. 2.0 at
                        2160p)
    mode:
        The name of a kscreen-doctor screen mode
        to search for (such as 1920x1080@60) or
        a preset (4k or fhd).
        Options take precedent over mode.
```

## Examples
### Use for resolution automation in Sunshine game streaming
> **Note:** Due to the exit code, the connection will fail if the client requests a resolution not available on the host

- Do
```
/path/to/screenmode.sh -x "$SUNSHINE_CLIENT_WIDTH" -y "$SUNSHINE_CLIENT_HEIGHT" -r "$SUNSHINE_CLIENT_FPS" -H 0
```

- Undo
```
/path/to/screenmode.sh -x 3840 -y 2160 -r 120 -H 1
```