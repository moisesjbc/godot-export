#!/bin/bash

EXPORT_DIRPATH="$BASE_DIRPATH/../export"

PROJECT_FILEPATH=
VERSION=
PLATFORM=


while [[ $# -gt 0 ]]; do
  case $1 in
    -o|--export-dirpath)
      EXPORT_DIRPATH=$(realpath "$2")
      shift
      shift
      ;;
    -i|--project-filepath)
      PROJECT_FILEPATH="$2"
      shift
      shift
      ;;
    -n|--name)
      NAME="$2"
      shift
      shift
      ;;
    -v|--version)
      VERSION="$2"
      shift
      shift
      ;;
    -p|--platform)
      PLATFORM="$2"
      shift
      shift
      ;;
    -h|--help)
      echo "Usage: bash godot-export.sh -i <project-filepath> -o <output-dirpath> -n <name> -v <version> [-p <platform>]"
      exit 0
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

if [ -z "$GODOT_EXECUTABLE" ] || [ ! -f "$GODOT_EXECUTABLE" ]; then
    echo "ERROR: \$GODOT_EXECUTABLE variable is not set or does not point to valid file [$GODOT_EXECUTABLE]"
    exit 1
fi

if [ -z "$PROJECT_FILEPATH" ]; then
    echo "ERROR: Expected a project filepath"
    exit 1
fi

if [ -z "$EXPORT_DIRPATH" ]; then
    echo "ERROR: Expected an export dirpath"
    exit 1
fi

if [ -z "$NAME" ]; then
    echo "ERROR: Expected a name"
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "ERROR: Expected a version"
    exit 1
fi

BASE_DIRPATH=$(dirname $PROJECT_FILEPATH)
ZIP_DIRPATH="$EXPORT_DIRPATH/zip"

rm -r "$ZIP_DIRPATH"
mkdir -p "$ZIP_DIRPATH"

function export_game {
    export_preset=$1
    export_dirname=$2
    executable_filename=$3

    export_dirpath="$EXPORT_DIRPATH"/"$export_dirname"
    rm -r "$export_dirpath"
    mkdir -p "$export_dirpath"
    
    (cd $BASE_DIRPATH && $GODOT_EXECUTABLE --export-release "$export_preset" --output "$export_dirpath"/"$executable_filename")

    zip_filename="${export_dirname}_v${VERSION}.zip"
    zip_filepath="${ZIP_DIRPATH}/${zip_filename}"
    rm "$zip_filepath"
    if [ "$export_preset" == "HTML5" ]; then
        # itch.io expects index.html in root inside zip.
        (cd "$EXPORT_DIRPATH/$export_dirname" && zip -r "$zip_filepath" *)
    else
        (cd "$EXPORT_DIRPATH" && zip -r "$zip_filepath" "$export_dirname")
    fi
}

if [ -z "$PLATFORM" ]; then
    export_game "Linux" "${NAME}_linux" "${NAME}_linux"
    export_game "Windows Desktop" "${NAME}_windows" "${NAME}_windows.exe"
    export_game "Web" "${NAME}_web" "index.html" # itch.io expects an index.html in zip
else
    export_game "$PLATFORM" "${NAME}_html" "index.html" # itch.io expects an index.html in zip
fi


