# spaceship-wsl

[WSL](https://learn.microsoft.com/en-us/windows/wsl/) distro indicator for [Spaceship Prompt](https://spaceship-prompt.sh/). Shows a Nerd Font distro icon and name at the end of the prompt (before `➜`).

## Requirements

- [Zsh](https://www.zsh.org/)
- [Spaceship Prompt](https://spaceship-prompt.sh/) v4+
- A [Nerd Font](https://www.nerdfonts.com/) terminal font

## Install

### With [Znap](https://github.com/marlonrichert/zsh-snap)

Load **after** Spaceship:

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

## Appearance

On WSL only. Uses `$WSL_DISTRO_NAME` or `/etc/os-release` with per-distro Nerd Font icons (Ubuntu, Debian, Arch, Fedora, …).

## Options

See `spaceship-wsl.plugin.zsh` for `SPACESHIP_WSL_*` variables and `SPACESHIP_WSL_DISTRO_SYMBOLS` / `SPACESHIP_WSL_DISTRO_COLORS` arrays.

## License

MIT
