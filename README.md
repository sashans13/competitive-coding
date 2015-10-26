# competitive-coding
Bash script which makes testing codes for competitions easier (C++)

## Functionality
Running functions from this script: `r`, `rd`, `ra` or `rad` in a directory that has `src.cpp` file will do next for each function:
* `r [params]`: will compile `src.cpp` and run it with all `[params]` as input files (redirect to stdin)
* `rd [params]`: same as above, but will compile with DEBUG flag
* `ra`: will compile `src.cpp` and run it with all `*.in` files in current directory as input files
* `rad`: same as above, but will compile with DEBUG flag

Other functionality:
* `gimme source`: will copy a template file into current directory as `src.cpp` (see script for location)

## Installation
In your `~/.bash_profile` or any other script that runs when terminal is launched, add the next line:
`. PATH_TO_SCRIPT` i.e.
`. ~/competitive_script.sh`
This will run the script in the current process, so you'll have direct access to functions.

## Warnings
If you already have global commands that would collide with function names of this script (such as programming language R which is run by `r`), you may rename functions `r, rd, ra, rad` into anything else, and they'll be usable out of the box. If you change other functions' names, you'll have the change it in all the lines they're invoked.
