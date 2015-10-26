#!/bin/bash
shopt -s nullglob

# this script will mask any existing global commands
# that collide with function names; in order to
# avoid this, just rename next functions:
# [r, rd, ra, rad]
# if you change other functions' names, you'll
# have to change all the lines where they're invoked

# Check if "src.cpp" exists in current working directory
function check_correct_folder()
{
    local src_noext="$PWD/src"
    if [ ! -f "$src_noext.cpp" ]; then
        return 1
    fi
}

# param1: $src_noext
# param2: $is_debug [true | false]
function compile()
{
    if [ $# -ne 2 ]; then
        printf "Sorry, wrong number of params.\n"
        return 1
    fi

    local src_noext=$1
    local is_debug=$2

    if [ ! -f "$src_noext.cpp" ]; then
        printf "Sorry, file doesn't exist, are you in the right directory?\n"
        return 1
    fi

    if [ "$is_debug" = true ]; then
        g++ "$src_noext.cpp" -o "$src_noext" -DLOCAL -DDEBUG
    else
        g++ "$src_noext.cpp" -o "$src_noext" -DLOCAL
    fi

    if [ $? -ne 0 ]; then
        # if compiling failed
        return 1
    fi
}

# param1: $src_noext
# param2: $is_debug
# param3: $should_run_all
# [optional] params as param4: input files
function run_program()
{
    check_correct_folder
    if [ $? -ne 0 ]; then
        printf "File src.cpp doesn't exist, are you in the right directory?\n"
        return 1
    fi

    if [ $# -lt 3 -a $# -gt 4 ]; then
        printf "Wrong number of argrrrrr\n"
        return 1
    fi

    local src_noext=$1
    local is_debug=$2
    local should_run_all=$3
    if [ ! "$should_run_all" = true -a $# -eq 3 ]; then
        printf "Call run_program with valid args!\n"
        return 1
    fi
    local input_path=$4

    if [ ! -f "$src_noext.cpp" ]; then
        echo "src2 $src_noext.cpp"
        printf "Sorry, file doesn't exist, have you been playing with the script?\n"
        return 1
    fi

    clear
    if [ -f "$src_noext" ]; then
        rm "$src_noext"
    fi
    compile "$src_noext" "$is_debug"
    compiled=$?

    # if not compiled
    if [ "$compiled" -ne 0 ]; then
        return 1
    fi

    printf "Running executable...\n\n"
    if [ "$should_run_all" = true ]; then
        for i in *.in; do
            printf "input $i\n"
            cat "$PWD/$i" | "$src_noext"
            printf "\n"
        done
    else
        # take tail without first 3 args
        for i in ${@:4}; do
            printf "input $i\n"
            cat "$PWD/$i" | "$src_noext"
            printf "\n"
        done
    fi
}


# [list] param1: input files
# Run
function r()
{
    if [ $# -lt 1 ]; then
        printf "Please provide at least one input file.\n"
        return 1
    fi

    run_program "$PWD/src" false false $@
}

# [list] param1: input files
# Run with DEBUG flag
function rd()
{
    if [ $# -lt 1 ]; then
        printf "Please provide at least one input file.\n"
        return 1
    fi

    run_program "$PWD/src" true false $@
}

# Run all
function ra()
{
    run_program "$PWD/src" false true
}

# Run all with DEBUG flag
function rad()
{
    run_program "$PWD/src" true true
}

# Copy 
function gimme()
{
    template_path="${HOME}/competitive-coding/competitive_template.cpp"

    if [ $# -ne 1 ]; then
        printf "Provide a valid number of arguments\n"
        return 1;
    fi

    if [ $1 = "source" ]; then
        if [ ! -f "$template_path" ]; then
            printf "Could not find template, is the path correct? Check the script!\n"
            return 1
        fi

        cp "$template_path" "$PWD/src.cpp"
    elif [ $1 = "cf" ]; then
        # codeforces
        declare -a arr=("a" "b" "c" "d" "e")
        for dir in "${arr[@]}"; do
            mkdir "$dir"
            if [ ! -f "$template_path" ]; then
                printf "Could not find template, is the path correct? Check the script!\n"
                return 1
            fi

            if [ ! -f "$PWD/$dir/src.cpp" ]; then
                cp "$template_path" "$PWD/$dir/src.cpp"
                if [ $? -eq 0 ]; then
                    printf "Created $PWD/$dir/src.cpp\n"
                fi
            fi
        done
    else
        printf "Misspelt that, didn't ya?\n"
    fi
}

function edit-vimrc()
{
    mvim ~/.vimrc
}

function edit-template()
{
    template_path="${HOME}/competitive-coding/competitive_template.cpp"

    if [ ! -f "$template_path" ]; then
        printf "Could not find template, is the path correct? Check the script!\n"
        return 1
    fi
    mvim "$template_path"
}
