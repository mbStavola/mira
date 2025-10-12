def get-user-color [] {
    let user_color = { 
        attr: b, 
        fg: (if (is-admin) { 'red' } else { 'green' }), 
    }

    return $user_color
} 

def get-jj-line [] {
  try {
      let jj_bookmark = (jj log -r @ --no-graph -T 'bookmarks' err> /dev/null | str trim)
      let jj_id = (jj log -r @ --no-graph -T 'change_id.short()' err> /dev/null | str trim)

      if $jj_bookmark != "" { $"($jj_id) \(($jj_bookmark)\)" } else { $jj_id }
  } catch {
      ""
  }
}

def get-git-line [] {
  try {
      let git_branch = (git branch --show-current err> /dev/null | str trim)
      let git_dirty = (git status --porcelain=v1 err> /dev/null | wc -l | into int) > 0

      $"($git_branch)(if $git_dirty { "*" } else { "" })"
  } catch {
      ""
  }
}

def get-hg-line [] {
  try {
      let hg_id = (hg id -i err> /dev/null | str trim | str replace '+' '')
      let hg_dirty = (hg id -i err> /dev/null | str contains '+')

      $"($hg_id)(if $hg_dirty { "*" } else { "" })"
  } catch {
      ""
  }
}

def get-pijul-line [] {
  try {
      let pijul_channel = (pijul channel err> /dev/null | lines | where $it starts-with '*' | first | str trim |
str replace '* ' '')
      let pijul_dirty = (pijul diff --short err> /dev/null | str length) > 0

      $"($pijul_channel)(if $pijul_dirty { "*" } else { "" })"
  } catch {
      ""
  }
}

def first-non-empty [funcs: list] {
  for func in $funcs {
      let result = (do $func)
      if $result != "" {
          return $result
      }
  }
  return ""
}

export def prompt-command [] {
    let user_color = get-user-color

    let ssh_indicator = (if 'SSH_CONNECTION' in $env {
        $"(ansi $user_color)[  SSH](ansi reset)"
    } else {
        $"(ansi $user_color)[LOCAL](ansi reset)"
    })

    let user_host = $"(ansi $user_color)(whoami)@(uname | get nodename)(ansi reset)"

    let user_directory_color = { fg: blue, attr: b }
    let directory = $"(ansi $user_directory_color)(pwd | str replace $env.HOME "~")(ansi reset)"

    # Try each VCS in order, short-circuiting on first match
    let vcs_line = (first-non-empty [
      {|| get-jj-line },
      {|| get-git-line },
      {|| get-hg-line },
      {|| get-pijul-line }
    ])

    let vcs_color = { fg: yellow }
    let vcs_line = (if $vcs_line != "" {
        $"(ansi $vcs_color)‹($vcs_line)› (ansi reset)"
    } else {
        ""
    })
    
    return $"($ssh_indicator) ($user_host) ($directory) ($vcs_line)\n\n"
}

export def prompt-command-right [] {
    return (if $env.LAST_EXIT_CODE == 0 {
        ""
    } else {
        $"(ansi { fg: red, attr: b })($env.LAST_EXIT_CODE) ↵ (ansi reset)"
    })
}

export def prompt-indicator [] {
    let user_color = get-user-color

    let curr_date = (date now | format date '%H:%M')
    let symbol = (if (is-admin) { "#" } else { "$" })

    return $"(ansi $user_color)[($curr_date)](ansi reset) ($symbol) "
}

export def multiline-indicator [] { return "" }

