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
  local ssh_indicator="$terminfo[bold]$fg[green][LOCAL]$reset_color"
else
  local ssh_indicator="$terminfo[bold]$fg[red][  SSH]$reset_color"
fi

local current_dir='%{$terminfo[bold]$fg[blue]%}%~ %{$reset_color%}'

function jj_prompt_info() {
  if command -v jj &> /dev/null && jj root &> /dev/null 2>&1; then
      local jj_bookmark=$(jj log -r @ --no-graph -T 'bookmarks' 2>/dev/null | tr -d '\n')
      local jj_id=$(jj log -r @ --no-graph -T 'change_id.short()' 2>/dev/null | tr -d '\n')

      if [[ -n "$jj_bookmark" ]]; then
          echo "$jj_bookmark"
      else
          echo "$jj_id"
      fi
  fi
}

function custom_git_prompt_info() {
  if command -v git &> /dev/null && git rev-parse --git-dir &> /dev/null 2>&1; then
      local branch=$(git branch --show-current 2>/dev/null)
      local dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

      if [[ $dirty -gt 0 ]]; then
          echo "${branch}*"
      else
          echo "$branch"
      fi
  fi
}

function custom_hg_prompt_info() {
  if command -v hg &> /dev/null && hg root &> /dev/null 2>&1; then
      local hg_info=$(hg id -i 2>/dev/null)

      if [[ $hg_info == *"+"* ]]; then
          echo "${hg_info%+}*"
      else
          echo "$hg_info"
      fi
  fi
}

function pijul_prompt_info() {
  if command -v pijul &> /dev/null && pijul channel &> /dev/null 2>&1; then
      local channel=$(pijul channel 2>/dev/null | grep '^\*' | sed 's/^\* //')
      local dirty=$(pijul diff --short 2>/dev/null | wc -c | tr -d ' ')

      if [[ $dirty -gt 0 ]]; then
          echo "${channel}*"
      else
          echo "$channel"
      fi
  fi
}

function vcs_prompt_info() {
  local vcs_info=""

  vcs_info=$(jj_prompt_info)
  if [[ -n "$vcs_info" ]]; then
      echo "%{$fg[yellow]%}‹${vcs_info}› %{$reset_color%}"
      return
  fi

  vcs_info=$(custom_git_prompt_info)
  if [[ -n "$vcs_info" ]]; then
      echo "%{$fg[yellow]%}‹${vcs_info}› %{$reset_color%}"
      return
  fi

  vcs_info=$(custom_hg_prompt_info)
  if [[ -n "$vcs_info" ]]; then
      echo "%{$fg[yellow]%}‹${vcs_info}› %{$reset_color%}"
      return
  fi

  vcs_info=$(pijul_prompt_info)
  if [[ -n "$vcs_info" ]]; then
      echo "%{$fg[yellow]%}‹${vcs_info}› %{$reset_color%}"
      return
  fi
}

local vcs_branch='$(vcs_prompt_info)'
local time_info='%{$fg[green]%}[%D{%H:%M}]%f'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

PROMPT="${ssh_indicator} ${user_host}${current_dir}${vcs_branch}
%B${time_info}%b %B${user_symbol}%b "
RPROMPT="%B${return_code}%b"

