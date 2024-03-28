# Mira 

A modified [bira][1] with time info and a simplified start prompt.

![Mira Example Screenshot](images/SCREENSHOT.png)

# Installation

## Zsh

The easiest way to use this theme is to install [Antigen][2] and add the following to your `.zshrc`:

```sh
antigen theme https://github.com/mbStavola/mira
```

## Nushell

Usage with `nu` requires you clone this repo and copy the `mira.nu` file into your `nu` config directory.

Once that is done, you can simply set the various prompt env vars with the associated Mira function:

```nu
use mira.nu
$env.PROMPT_COMMAND = { mira prompt-command }
$env.PROMPT_COMMAND_RIGHT = { mira prompt-command-right }
$env.PROMPT_INDICATOR = { mira prompt-indicator }
$env.PROMPT_MULTILINE_INDICATOR = { mira multiline-indicator }
```

Additionally, if you prefer, you can set `render_right_prompt_on_last_line` in `config.nu` to have the error code display on the same line as the prompt indicator.


[1]: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#bira
[2]: https://github.com/zsh-users/antigen
