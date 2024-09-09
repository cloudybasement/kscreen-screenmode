#! /bin/bash

# Parameters:
# Positional parameter: Presets (4k, fhd) or kscreen mode name
# flags -x [Resolution Width] -y [Resolution Height] -r [Refresh Rate] -h [HDR 1 or 0] -s [scale 1 - 3]  


# Parse Options
while getopts 'x:y:r:h:s:' OPTION
do
    case "$OPTION" in
        x)
            x="$OPTARG"
            ;;
        y)
            y="$OPTARG"
            ;;
        r)
            r="$OPTARG"
            ;;
        h)
            h="$OPTARG"
            ;;
        s)
            s="$OPTARG"
            ;;
    esac
done

# Return help if no arguments
if [[ -z $1 && -z x && -z y && -z r && -z h && -z s ]]
then
    echo 'Usage:   screenmode -xyrhs [MODE/PRESET]
            -x 1920 -- Horizontal Resolution
            -y 1080 -- Vertical Resolution
            -r 60   -- Refresh Rate
            -h 1    -- HDR Enabled
            -s 1.75 -- Fractional Scaling
fi

# Get screen mode json
kscreen_modes=$(kscreen-doctor -j)

# Find mode id based on preset
if [ "$1" = "4k" ]
then
    kscreen_mode_id=$(echo $kscreen_modes | jq -r '.outputs[0].modes | map(select(.name == "3840x2160@120")) | first | .id')
elif [ "$1" = "fhd" ]
then
    kscreen_mode_id=$(echo $kscreen_modes | jq -r '.outputs[0].modes | map(select(.name == "1920x1080@60")) | first | .id')
elif [ ! -z "$1" ]
then
    echo "Looking for screen mode containing ${1}"
    kscreen_mode=$(echo $kscreen_modes | jq -r '.outputs[0].modes | map(select(.name | contains("'$1'"))) | first ')
    kscreen_mode_name=$(echo $kscreen_mode | jq -r '.name')
    echo "Found screen mode $kscreen_mode_name"
    kscreen_mode_id=$(echo $kscreen_mode | jq -r '.id')
fi

# Find mode id based on arguments
if [[ -v x || -v y || -v r ]]
then
    echo "Looking for screen mode containing ${x}x${y}@${r}"
    kscreen_mode=$(echo $kscreen_modes | jq -r '.outputs[0].modes
    |
    map(
        select(
            (.name | contains("'"${x}x"'"))
            and
            (.name | contains("'"${y}@"'"))
            and
            (.name | contains("'"@${r}"'"))
        )
    )
    |
    first')
    kscreen_mode_name=$(echo $kscreen_mode | jq -r '.name')
    echo "Found screen mode $kscreen_mode_name"
    kscreen_mode_id=$(echo $kscreen_mode | jq -r '.id')
fi

# Set to found screen mode
if [[ -v kscreen_mode_id && "$kscreen_mode_id" != "null" ]]
then
    echo "Setting screen to mode $kscreen_mode_id"
    kscreen-doctor output.1.mode.$kscreen_mode_id
else
    echo "Screen mode not found :("
fi


# Set HDR
if [ "$h" = "1" ]
then
    echo "Enabling HDR"
    kscreen-doctor output.1.hdr.enable
    kscreen-doctor output.1.wcg.enable
elif [ "$h" = "0" ]
then
    echo "Disabling HDR"
    kscreen-doctor output.1.hdr.disable
    kscreen-doctor output.1.wcg.disable
fi

# Set scale
if [[ -v s ]]
then
    echo "Setting scale to $s"
    kscreen-doctor output.1.scale.$s
fi
