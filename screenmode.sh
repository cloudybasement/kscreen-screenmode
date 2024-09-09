#! /bin/bash

# Parameters:
# Positional parameter: Presets (4k, fhd) or kscreen mode name
# flags -x [Resolution Width] -y [Resolution Height] -r [Refresh Rate] -h [HDR 1 or 0] -s [scale 1 - 3]  


# Parse Options
while getopts ':x:y:r:H:s:h' OPTION
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
        H)
            H="$OPTARG"
            ;;
        s)
            s="$OPTARG"
            ;;
        h)
            h=true
            ;;
        ?)
            h=true
            ;;
    esac
done
mode=${@:$OPTIND:1}

# Return help if no arguments
if [[ ( -z "$mode" && -z "$x" && -z "$y" && -z "$r" && -z "$H" && -z "$s" ) || -v h ]]
then
    echo '
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
'
    exit 0;
fi

# Check if mode switch desired
if [[  ! -z "$mode" || -v x || -v y || -v r ]]
then
    # Get screen mode json
    kscreen_modes=$(kscreen-doctor -j)

    # Find mode id based on preset
    if [ "$mode" = "4k" ]
    then
        kscreen_mode_id=$(echo $kscreen_modes | jq -r '.outputs[0].modes | map(select(.name == "3840x2160@120")) | first | .id')
    elif [ "$mode" = "fhd" ]
    then
        kscreen_mode_id=$(echo $kscreen_modes | jq -r '.outputs[0].modes | map(select(.name == "1920x1080@60")) | first | .id')
    elif [ ! -z "$mode" ]
    then
        echo "Looking for screen mode containing $mode"
        kscreen_mode=$(echo $kscreen_modes | jq -r '.outputs[0].modes | map(select(.name | contains("'$mode'"))) | first ')
        kscreen_mode_name=$(echo $kscreen_mode | jq -r '.name')
        kscreen_mode_id=$(echo $kscreen_mode | jq -r '.id')
        if [ "$kscreen_mode_id" != "null" ]
        then
            echo "Found screen mode $kscreen_mode_name with ID $kscreen_mode_id"
        fi
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
        kscreen_mode_id=$(echo $kscreen_mode | jq -r '.id')
        if [ "$kscreen_mode_id" != "null" ]
        then
            echo "Found screen mode $kscreen_mode_name with ID $kscreen_mode_id"
        fi
    fi

    # Set to found screen mode
    if [[ -v kscreen_mode_id && "$kscreen_mode_id" != "null" ]]
    then
        echo "Setting screen to mode $kscreen_mode_id"
        kscreen-doctor output.1.mode.$kscreen_mode_id
    else
        echo "Screen mode not found :("
        exit 1;
    fi
fi


# Set HDR
if [ "$H" = "1" ]
then
    echo "Enabling HDR"
    kscreen-doctor output.1.hdr.enable
    kscreen-doctor output.1.wcg.enable
elif [ "$H" = "0" ]
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
