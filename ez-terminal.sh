### Colors
red="\[\e[31m\]"
green="\[\e[32m\]"
blue="\[\e[34m\]"
white="\[\e[97m\]"

reset="\[\e[0m\]"

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
    echo "${user_color}\$${reset}"
}

host() {
    local host_color=${white}
    echo "${host_color}\h${reset}"
}

current_dir() {
    local current_dir_color=${blue}
    echo "${current_dir_color}\w${reset}"
}

###

PS1="\n$(user)@$(host) $(current_dir)\n$(prompt_char)${reset} "
