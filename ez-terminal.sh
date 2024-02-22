#!/usr/bin/env sh

### Colors
red='\[\e[31m\]'
green='\[\e[32m\]'
blue='\[\e[34m\]'
gray='\[\e[37m\]'
white='\[\e[97m\]'

reset='\[\e[0m\]'

###

light_color() {
    _light_color_value=$1
    printf '%s' "$_light_color_value" | sed 's/\[3/\[9/g'
}

dark_color() {
    _dark_color_value=$1
    printf '%s' "$_dark_color_value" | sed 's/m/;2m/g'
}

bright_color() {
    _bright_color_value=$1
    _bright_color_value=$(printf '%s' "$_bright_color_value" | sed 's/m/;1m/g')
    light_color "$_bright_color_value"
}

find_lscolors() {
    _find_lscolors_string=$1
    _find_lscolors_result=$(dircolors -p | grep -oP "^.?$_find_lscolors_string \K([0-9]|[\;])+")
    printf '\[\e[%sm\]' "$_find_lscolors_result"
}

###

user_color() {
    _user_color_value=${green}

    if [ "$USER" = 'root' ]; then
        _user_color_value=${red}
    fi
    printf '%s' "$_user_color_value"
}

user() {
    _user_color=$(user_color)
    printf '%s\\u%s' "$_user_color" "$reset"
}

prompt_char() {
    _user_color=$(user_color)
    _prompt_char_color=$(bright_color "$_user_color")
    printf '%s\\$%s' "$_prompt_char_color" "$reset"
}

host() {
    _host_color=${white}
    printf '%s\\h%s' "$_host_color" "$reset"
}

current_dir() {
    _current_dir_color=

    if [ -h "$(pwd)" ]; then
        _current_dir_color=$(find_lscolors 'LINK')
    else
        _current_dir_color=$(find_lscolors 'DIR')
    fi

    printf '%s\\w%s' "$_current_dir_color" "$reset"
}

exit_status() {
    _exit_status_value=
    _exit_status_color=$(dark_color "$gray")

    if [ "$exit_code" -ne 0 ]; then
        _exit_status_value="${_exit_status_color}[exit ${exit_code}]\n"
    fi

    printf '%s%s' "$_exit_status_value" "$reset"
}

prompt() {
    exit_code=$?
    PS1="$(exit_status)\n$(user)@$(host) $(current_dir)\n$(prompt_char) "
}

###

PROMPT_COMMAND=prompt