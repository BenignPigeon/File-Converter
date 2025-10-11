#!/bin/bash
set -euo pipefail

CONFIG_DIR="$HOME/.config/Bat-Files"
CONVERTER_DIR="$CONFIG_DIR/File-Converter"
CONFIG_FILE="$CONFIG_DIR/config.ini"

# Create directories if they don't exist
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Directory $CONFIG_DIR does not exist. Creating now..."
    mkdir -p "$CONFIG_DIR"
fi

if [ ! -d "$CONVERTER_DIR" ]; then
    echo "Directory $CONVERTER_DIR does not exist. Creating now..."
    mkdir -p "$CONVERTER_DIR"
fi

# Change to dependencies folder
cd dependencies

# Source universal-parameters.sh 
if [ -f universal-parameters.sh ]; then
    source universal-parameters.sh
else
    echo "universal-parameters.sh not found"
fi

cd ..

# Create config file with default settings if missing
if [ ! -f "$CONFIG_FILE" ]; then
    {
        echo "first_execution=true"
        echo "method=explorer"
        echo "has_ffmpeg=false"
        echo "has_7zip=false"
        echo "has_pdf_to_docx_dependencies=false"
        echo "has_pdf_to_png_dependencies=false"
        echo "has_pdf_ocr_dependencies=false"
        # echo "has_eml_to_pdf_dependencies=false"
        echo "output_path_enabled=0"
        echo "output_path=$HOME/Desktop"
        echo "supported_image_formats=arw,bmp,cr2,dds,dns,exr,heic,ico,jfif,jpg,jpeg,nef,png,psd,raf,svg,tif,tiff,tga,webp"
        echo "supported_audio_formats=aac,aiff,ape,bik,cda,flac,gif,m4a,m4b,mp3,oga,ogg,ogv,opus,wav,wma"
        echo "supported_video_formats=3gp,3gpp,avi,bik,flv,gif,m4v,mkv,mp4,mpg,mpeg,mov,ogv,rm,ts,vob,webm,wmv"
        echo "supported_archive_formats=zip,tar,gz,7z,rar"
        echo "supported_word_formats=docx,odt,doc"
        echo "supported_powerpoint_formats=pptx,ppt"
        echo "supported_excel_formats=xlsx,xls"
    } > "$CONFIG_FILE"
fi

# Read config file
declare -A config

while IFS='=' read -r key value; do
    # skip empty lines and comments
    [[ -z "$key" ]] && continue
    [[ "$key" =~ ^# ]] && continue
    config[$key]="${value//[[:space:]]/}" # trim spaces
done < "$CONFIG_FILE"

# first_execution actions
if [[ "${config[first_execution]:-true}" != "false" ]]; then
    cd dependencies
    if [ -f python-add-path.sh ]; then
        source python-add-path.sh
    else
        echo "python-add-path.sh not found"
    fi
    cd ..

    # update config file to set first_execution=false
    sed -i 's/^first_execution=.*/first_execution=false/' "$CONFIG_FILE"
    config[first_execution]="false"
fi

# Main menu loop
while true; do
    clear
    echo "File Converter"
    echo "===================="
    echo "1. Convert File"
    echo "2. Convert Selection (Specific Pages)"
    echo "3. Compress File"
    echo "4. Settings"
    echo "5. Exit"
    echo

    if [[ "${config[output_path_enabled]}" == "1" ]]; then
        echo "Current output folder: ${config[output_path]}"
    else
        echo "Outputting to the same directory as the file"
    fi

    echo "Current folder selection method: ${config[method]}"
    echo

    read -rp "Enter your choice (1-5): " choice

    case "$choice" in
        1)
            cd convert-file
            ./convert-file.sh
            cd ..
            ;;
        2)
            cd convert-selection
            ./convert-selection.sh
            cd ..
            ;;
        3)
            cd compress-file
            ./compress-file.sh
            cd ..
            ;;
        4)
            cd settings
            ./settings.sh
            cd ..
            ;;
        5)
            exit 0
            ;;
        *)
            echo "Invalid choice, try again."
            sleep 2
            ;;
    esac
done
