# Mira ZSH Theme - A modified Bira with time info and a simplified start prompt 
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m %{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n@%m %{$reset_color%}'
    local user_symbol='$'
fi

if [ -z $SSH_CONNECTION ]; then
    local ssh_indicator="$fg[green][LOCAL]$reset_color"
else
    local ssh_indicator="$fg[red][  SSH]$reset_color"
fi

local current_dir='%{$terminfo[bold]$fg[blue]%}%~ %{$reset_color%}'
local git_branch='$(git_prompt_info)'
local time_info='%{$fg[green]%}[%D{%H:%M}]%f'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

PROMPT="${ssh_indicator} ${user_host}${current_dir}${git_branch}
%B${time_info}%b %B${user_symbol}%b "
RPROMPT="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

