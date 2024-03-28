def get-user-color [] {
    let user_color = { 
        attr: b, 
        fg: (if (is-admin) { 'red' } else { 'green' }), 
    }

    return $user_color
} 

export def prompt-command [] {
    let user_color = get-user-color

    let ssh_indicator = (if 'SSH_CONNECTION' in $env {
        $"(ansi $user_color)[  SSH](ansi reset)"
    } else {
        $"(ansi $user_color)[LOCAL](ansi reset)"
    })

    let user_host = $"(ansi $user_color)(whoami)@(uname -n)(ansi reset)"

    let user_directory_color = { fg: blue, attr: b }
    let directory = $"(ansi $user_directory_color)(pwd | str replace $env.HOME "~")(ansi reset)"

    let git_line = (try {
        let git_branch = (git branch --show-current err> /dev/null | str trim)
        let git_dirty = (git status --porcelain=v1 err> /dev/null | wc -l | into int) > 0
   
        $"($git_branch)(if $git_dirty { "*" } else { "" })"
    } catch {
        ""
    })

    let vcs_color = { fg: yellow }
    # This is a bit unnecessary, but if I decide to support other VCSs in the future
    # it should be relatively easy to tack on
    let vcs_line = (if $git_line != "" { $git_line } else { "" })
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

