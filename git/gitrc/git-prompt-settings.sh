#!bash
# This is just the prompt/colour settings for the git prompt

export PS1="\[\e[01;32m\]\u@\h\[\e[01;34m\] \w \$\[\e[00m\] "
PROMPT_COMMAND="prompt_f"

export GIT_PS1_SHOWDIRTYSTATE=1
#Turn off untracked files... too slow
export GIT_PS1_SHOWUNTRACKEDFILES=false
#This is supposed to show when your upstream is out of date... doesn't work
#export GIT_PS1_SHOWUPSTREAM="verbose git"

color_red="\[\e[31;1m\]"
color_green="\[\e[32;40m\]"
color_yellow="\[\e[33;40m\]"
color_blue="\[\e[34;40m\]"
color_magenta="\[\e[35;40m\]"
color_cyan="\[\e[36;40m\]"
color_red_bold="\[\e[31;1m\]"
color_green_bold="\[\e[32;1m\]"
color_yellow_bold="\[\e[33;1m\]"
color_blue_bold="\[\e[34;1m\]"
color_magenta_bold="\[\e[35;1m\]"
color_cyan_bold="\[\e[36;1m\]"
color_none="\[\e[0m\]"

prompt_f ()
{
    local EXIT_STATUS=$?

    if [[ $PS1 == *EXPECT* ]]; then
        return
    fi

    local ps1_status_color ps1_status ps1_path_color ps1_user_color ps1_fullpath ps1_git_color

    # Path color always blue
    ps1_path_color=${color_cyan}

    # If exit status is not 0, then print status code and change prompt to red
    if [ $EXIT_STATUS -eq 0 ]; then
        ps1_user_color=${color_green_bold}
        ps1_status=""
    else
        ps1_user_color=${color_red_bold}
        ps1_status_color=${color_red}
        ps1_status="${ps1_status_color}[$EXIT_STATUS] "
    fi

    # If git repo has changed, change prompt color
    ps1_git_color=${color_yellow}

#ps1_fullpath="\
#${color_none}\
#${ps1_user_color}\\u@\\h\
#${ps1_git_color}$(__git_ps1) \
#${ps1_path_color}\\w"
#
#    PS1="${ps1_status}${ps1_fullpath} $ps1_path_color\$ ${color_none}"
#}

ps1_fullpath="\
${color_none}\
${ps1_user_color}\\u@\\h\
${ps1_path_color}\\w"

    PS1="${ps1_status}${ps1_fullpath} $ps1_path_color\$ ${color_none}"
}
