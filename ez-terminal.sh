### Colors
red="\[\e[31m\]"
green="\[\e[32m\]"
blue="\[\e[34m\]"
white="\[\e[97m\]"

reset="\[\e[0m\]"

###

light_color() {
    local color=$1
    echo "${color/[3/[9}"
}

dark_color() {
    local color=$1
    echo "${color/m/;2m}"
}

bright_color() {
    local color=$1
    color="${color/m/;1m}"
    light_color $color
}

find_lscolors() {
    local string=$1
    local result=$(dircolors -p | grep -oP "^.?$string \K([0-9]|[\;])+")
    echo "\[\e[${result}m\]"
}

###

user_color() {
    local user_color=${green}

    if [ "$USER" = "root" ]; then
        user_color=${red}
    fi
    echo "${user_color}"
}

user() {
    local user_color=$(user_color)
    echo "${user_color}\u${reset}"
}

prompt_char() {
    local user_color=$(user_color)
    local prompt_color=$(bright_color $user_color)
    echo "${prompt_color}\\\$${reset}"
}

host() {
    local host_color=${white}
    echo "${host_color}\h${reset}"
}

current_dir() {
    local current_dir_color=$(find_lscolors 'DIR')
    echo "${current_dir_color}\w${reset}"
}

prompt() {
    PS1="${reset}\n$(user)@$(host) $(current_dir)\n$(prompt_char) "
}

###

PROMPT_COMMAND=prompt
