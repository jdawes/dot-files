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

__git_eread ()
{
    local f="$1"
    shift
    test -r "$f" && read "$@" <"$f"
}

# __git_ps1 accepts 0 or 1 arguments (i.e., format string)
# when called from PS1 using command substitution
# in this mode it prints text to add to bash PS1 prompt (includes branch name)
#
# __git_ps1 requires 2 or 3 arguments when called from PROMPT_COMMAND (pc)
# in that case it _sets_ PS1. The arguments are parts of a PS1 string.
# when two arguments are given, the first is prepended and the second appended
# to the state string when assigned to PS1.
# The optional third parameter will be used as printf format string to further
# customize the output of the git-status string.
# In this mode you can request colored hints using GIT_PS1_SHOWCOLORHINTS=true
__git_ps1 ()
{
    # preserve exit status
    local exit=$?
    local pcmode=no
    local detached=no
    local ps1pc_start='\u@\h:\w '
    local ps1pc_end='\$ '
    local printf_format=' (%s)'

    case "$#" in
        2|3)    pcmode=yes
            ps1pc_start="$1"
            ps1pc_end="$2"
            printf_format="${3:-$printf_format}"
            # set PS1 to a plain prompt so that we can
            # simply return early if the prompt should not
            # be decorated
            PS1="$ps1pc_start$ps1pc_end"
        ;;
        0|1)    printf_format="${1:-$printf_format}"
        ;;
        *)  return $exit
        ;;
    esac

    # ps1_expanded:  This variable is set to 'yes' if the shell
    # subjects the value of PS1 to parameter expansion:
    #
    #   * bash does unless the promptvars option is disabled
    #   * zsh does not unless the PROMPT_SUBST option is set
    #   * POSIX shells always do
    #
    # If the shell would expand the contents of PS1 when drawing
    # the prompt, a raw ref name must not be included in PS1.
    # This protects the user from arbitrary code execution via
    # specially crafted ref names.  For example, a ref named
    # 'refs/heads/$(IFS=_;cmd=sudo_rm_-rf_/;$cmd)' might cause the
    # shell to execute 'sudo rm -rf /' when the prompt is drawn.
    #
    # Instead, the ref name should be placed in a separate global
    # variable (in the __git_ps1_* namespace to avoid colliding
    # with the user's environment) and that variable should be
    # referenced from PS1.  For example:
    #
    #     __git_ps1_foo=$(do_something_to_get_ref_name)
    #     PS1="...stuff...\${__git_ps1_foo}...stuff..."
    #
    # If the shell does not expand the contents of PS1, the raw
    # ref name must be included in PS1.
    #
    # The value of this variable is only relevant when in pcmode.
    #
    # Assume that the shell follows the POSIX specification and
    # expands PS1 unless determined otherwise.  (This is more
    # likely to be correct if the user has a non-bash, non-zsh
    # shell and safer than the alternative if the assumption is
    # incorrect.)
    #
    local ps1_expanded=yes
    [ -z "$ZSH_VERSION" ] || [[ -o PROMPT_SUBST ]] || ps1_expanded=no
    [ -z "$BASH_VERSION" ] || shopt -q promptvars || ps1_expanded=no

    local repo_info rev_parse_exit_code
    repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
        --is-bare-repository --is-inside-work-tree \
        --short HEAD 2>/dev/null)"
    rev_parse_exit_code="$?"

    if [ -z "$repo_info" ]; then
        return $exit
    fi

    local short_sha
    if [ "$rev_parse_exit_code" = "0" ]; then
        short_sha="${repo_info##*$'\n'}"
        repo_info="${repo_info%$'\n'*}"
    fi
    local inside_worktree="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
    local bare_repo="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
    local inside_gitdir="${repo_info##*$'\n'}"
    local g="${repo_info%$'\n'*}"

    if [ "true" = "$inside_worktree" ] &&
       [ -n "${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] &&
       [ "$(git config --bool bash.hideIfPwdIgnored)" != "false" ] &&
       git check-ignore -q .
    then
        return $exit
    fi

    local r=""
    local b=""
    local step=""
    local total=""
    if [ -d "$g/rebase-merge" ]; then
        __git_eread "$g/rebase-merge/head-name" b
        __git_eread "$g/rebase-merge/msgnum" step
        __git_eread "$g/rebase-merge/end" total
        if [ -f "$g/rebase-merge/interactive" ]; then
            r="|REBASE-i"
        else
            r="|REBASE-m"
        fi
    else
        if [ -d "$g/rebase-apply" ]; then
            __git_eread "$g/rebase-apply/next" step
            __git_eread "$g/rebase-apply/last" total
            if [ -f "$g/rebase-apply/rebasing" ]; then
                __git_eread "$g/rebase-apply/head-name" b
                r="|REBASE"
            elif [ -f "$g/rebase-apply/applying" ]; then
                r="|AM"
            else
                r="|AM/REBASE"
            fi
        elif [ -f "$g/MERGE_HEAD" ]; then
            r="|MERGING"
        elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
            r="|CHERRY-PICKING"
        elif [ -f "$g/REVERT_HEAD" ]; then
            r="|REVERTING"
        elif [ -f "$g/BISECT_LOG" ]; then
            r="|BISECTING"
        fi

        if [ -n "$b" ]; then
            :
        elif [ -h "$g/HEAD" ]; then
            # symlink symbolic ref
            b="$(git symbolic-ref HEAD 2>/dev/null)"
        else
            local head=""
            if ! __git_eread "$g/HEAD" head; then
                return $exit
            fi
            # is it a symbolic ref?
            b="${head#ref: }"
            if [ "$head" = "$b" ]; then
                detached=yes
                b="$(
                case "${GIT_PS1_DESCRIBE_STYLE-}" in
                (contains)
                    git describe --contains HEAD ;;
                (branch)
                    git describe --contains --all HEAD ;;
                (describe)
                    git describe HEAD ;;
                (* | default)
                    git describe --tags --exact-match HEAD ;;
                esac 2>/dev/null)" ||

                b="$short_sha..."
                b="($b)"
            fi
        fi
    fi

    if [ -n "$step" ] && [ -n "$total" ]; then
        r="$r $step/$total"
    fi

    local w=""
    local i=""
    local s=""
    local u=""
    local c=""
    local p=""

    if [ "true" = "$inside_gitdir" ]; then
        if [ "true" = "$bare_repo" ]; then
            c="BARE:"
        else
            b="GIT_DIR!"
        fi
    elif [ "true" = "$inside_worktree" ]; then
        if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ] &&
           [ "$(git config --bool bash.showDirtyState)" != "false" ]
        then
            git diff --no-ext-diff --quiet --exit-code || w="*"
            if [ -n "$short_sha" ]; then
                git diff-index --cached --quiet HEAD -- || i="+"
            else
                i="#"
            fi
        fi
        if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ] &&
           git rev-parse --verify --quiet refs/stash >/dev/null
        then
            s="$"
        fi

        if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ] &&
           [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] &&
           git ls-files --others --exclude-standard --error-unmatch -- '*' >/dev/null 2>/dev/null
        then
            u="%${ZSH_VERSION+%}"
        fi

        if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
            __git_ps1_show_upstream
        fi
    fi

    local z="${GIT_PS1_STATESEPARATOR-" "}"

    # NO color option unless in PROMPT_COMMAND mode
    if [ $pcmode = yes ] && [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
        __git_ps1_colorize_gitstring
    fi

    b=${b##refs/heads/}
    if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
        __git_ps1_branch_name=$b
        b="\${__git_ps1_branch_name}"
    fi

    local f="$w$i$s$u"
    local gitstring="$c$b${f:+$z$f}$r$p"

    if [ $pcmode = yes ]; then
        if [ "${__git_printf_supports_v-}" != yes ]; then
            gitstring=$(printf -- "$printf_format" "$gitstring")
        else
            printf -v gitstring -- "$printf_format" "$gitstring"
        fi
        PS1="$ps1pc_start$gitstring$ps1pc_end"
    else
        printf -- "$printf_format" "$gitstring"
    fi

    return $exit
}

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

ps1_fullpath="\
${color_none}\
${ps1_user_color}\\u@\\h\
${ps1_path_color}:\\w\
${ps1_git_color}\$(__git_ps1)"
    PS1="${ps1_status}${ps1_fullpath} $ps1_path_color\$ ${color_none}"
}
