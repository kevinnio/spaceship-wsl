# spaceship-wsl

[WSL](https://learn.microsoft.com/en-us/windows/wsl/) distro indicator for [Spaceship Prompt](https://spaceship-prompt.sh/). Shows a Nerd Font distro icon and distro name when running on WSL.

## Requirements

- [Zsh](https://www.zsh.org/)
- [Spaceship Prompt](https://spaceship-prompt.sh/) v4+
- A [Nerd Font](https://www.nerdfonts.com/) terminal font

## Install

Load **after** Spaceship.

### With [Znap](https://github.com/marlonrichert/zsh-snap)

```zsh
znap prompt spaceship-prompt/spaceship-prompt
znap source kevinnio/spaceship-wsl spaceship-wsl.plugin.zsh
```

### Manual

```zsh
git clone https://github.com/kevinnio/spaceship-wsl.git \
  ${ZSH_CUSTOM:-~/.zsh}/spaceship-wsl
source ${ZSH_CUSTOM:-~/.zsh}/spaceship-wsl/spaceship-wsl.plugin.zsh
```

## Prompt order

This plugin registers the `wsl` section but does not choose where it appears. Add `wsl` to [SPACESHIP_PROMPT_ORDER](https://spaceship-prompt.sh/config/prompt/) (or `SPACESHIP_RPROMPT_ORDER`) in your Spaceship config:

```zsh
SPACESHIP_PROMPT_ORDER=(
  time user dir host git
  wsl
  char
)
```

You can also change placement at runtime:

```zsh
spaceship add --before char wsl   # insert before the prompt character
spaceship remove wsl              # remove from the prompt
```

## Appearance

Shown on WSL only. The label comes from `$WSL_DISTRO_NAME`, or from `/etc/os-release` when that variable is unset.

Per-distro Nerd Font icons and brand colors are built in (Ubuntu, Debian, Arch, Fedora, Alpine, and others). Unknown distros fall back to the Windows logo and `SPACESHIP_WSL_COLOR`.

## Options

| Variable | Default | Description |
| --- | --- | --- |
| `SPACESHIP_WSL_SHOW` | `true` | Show or hide the section |
| `SPACESHIP_WSL_PREFIX` | `$SPACESHIP_PROMPT_DEFAULT_PREFIX` | Prefix before the label |
| `SPACESHIP_WSL_SUFFIX` | `$SPACESHIP_PROMPT_DEFAULT_SUFFIX` | Suffix after the label |
| `SPACESHIP_WSL_SYMBOL` | Windows Nerd Font glyph | Fallback symbol when no distro match |
| `SPACESHIP_WSL_COLOR` | `cyan` | Fallback color when no distro match |

Override icons and colors per distro with associative arrays (keys are lowercase distro IDs, e.g. `ubuntu`, `pop-os`):

```zsh
typeset -gA SPACESHIP_WSL_DISTRO_SYMBOLS SPACESHIP_WSL_DISTRO_COLORS

SPACESHIP_WSL_DISTRO_SYMBOLS[my-distro]=$'\uF17A '
SPACESHIP_WSL_DISTRO_COLORS[my-distro]='#ff6600'
```

See `spaceship-wsl.plugin.zsh` for the full default symbol and color maps.

## License

MIT
