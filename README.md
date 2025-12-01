# godot-export

*godot-export* is a simple Bash script for exporting a [Godot v4](https://godotengine.org/) project to multiple platforms.

## Usage

1. Set the environment `GODOT_EXECUTABLE` to the Godot v4 binary path. Sample:

        export GODOT_EXECUTABLE=/opt/godot-engine/Godot_v4.5-stable_linux.x86_64

2. In Godot, set one or more of the following export profiles

    - Windows Desktop
    - Linux
    - HTML5

3. All set! Now run the script specifying a name and a version. Sample:

        bash godot-export.sh -i ufo-taxi/godot-project/project.godot -o ufo-taxi/export -n ufo-taxi -v 0.1

If there are no issues, the previous step should produce an *export/* subdirectory at the current directory with the following contents:

- One subdirectory with the uncompressed distribution for every platform, named <game-name>_<platform>. ie. *awesome-game_linux*.
- One `zip/` subdirectory containing one compressed distribution for every platform, named <game-name>_<platform>_<version>. ie. *awesome-game_linux_v1.0.zip*.

## ToDo

- Retrieve export profiles dynamically, so step 2 is no longed required.
- Other?
