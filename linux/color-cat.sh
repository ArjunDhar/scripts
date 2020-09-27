#!/bin/bash
# https://en.wikipedia.org/wiki/ANSI_escape_code
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

# Uage: color-cat.sh <file>

RED='\033[0;31m'
BLACK='\033[0;30m'
CYAN='\033[0;36m'
YELLOW='\033[0;93m'
YELLOW_BACK='\e[103m'
CAYAN_BACK='\e[106m'
NO_COLOR='\033[0m'

# "\033[0m"
# "\033[31m"
# "\033[1m"

BOLD='\e[1m'
DIM='\e[2m'
UNDERLINE='\e[4m'
BLINK='\e[5m'
INVERTED='\e[7'
HIDDEN='\e[8' # passwords

fileType="$(file "$1" | grep -o 'sh')"
if [ "$fileType" == 'sh' ]; then
    echo -en ${YELLOW_BACK}
else
    echo -en ${CYAN}
fi
cat $1
echo -en ${NO_COLOR}