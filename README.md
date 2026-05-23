# spaceship-wsl

If you juggle more than one [WSL](https://learn.microsoft.com/en-us/windows/wsl/) distro, it is easy to forget which Linux environment you are in. This plugin adds a section to [Spaceship Prompt](https://spaceship-prompt.sh/) that shows your distro’s name and icon, so your prompt tells you at a glance.

The section only appears when you are actually on WSL. On a normal Linux machine or macOS, nothing is added.

## What you need

You will need [Zsh](https://www.zsh.org/), [Spaceship Prompt](https://spaceship-prompt.sh/) v4 or newer, and a terminal font from [Nerd Fonts](https://www.nerdfonts.com/) so the distro icons render correctly.

If you use a regular monospace font (for example Cascadia Mono), set `SPACESHIP_WSL_ICON_STYLE` before loading the plugin:

```zsh
SPACESHIP_WSL_ICON_STYLE=emoji   # or ascii, none
```

## Installation

Source this plugin **before** Spaceship initializes the prompt. Spaceship registers sections when the prompt starts; if `spaceship_wsl` is not defined yet, you will see a warning and `wsl` will be removed from `SPACESHIP_PROMPT_ORDER`.

**With [Znap](https://github.com/marlonrichert/zsh-snap):**

```zsh
znap source kevinnio/spaceship-wsl spaceship-wsl.plugin.zsh
znap prompt spaceship-prompt/spaceship-prompt
```

**Manually:**

```zsh
git clone https://github.com/kevinnio/spaceship-wsl.git \
  ${ZSH_CUSTOM:-~/.zsh}/spaceship-wsl
source ${ZSH_CUSTOM:-~/.zsh}/spaceship-wsl/spaceship-wsl.plugin.zsh
# Then run `prompt spaceship` (or your usual Spaceship setup).
```

## Where the section appears

Installing the plugin defines a section called `wsl`, but it does not pick a spot in your prompt for you. You decide that by adding `wsl` to your [prompt order](https://spaceship-prompt.sh/config/prompt/).

A common choice is just before the prompt character:

```zsh
SPACESHIP_PROMPT_ORDER=(
  time user dir host git
  wsl
  char
)
```

Put `wsl` anywhere else in that list if you prefer. You can also show it on the right side with `SPACESHIP_RPROMPT_ORDER`.

To move it without editing your config, Spaceship’s CLI works too:

```zsh
spaceship add --before char wsl
spaceship remove wsl
```

## What it looks like

On WSL, the section shows a distro icon and a label. The label usually comes from `$WSL_DISTRO_NAME`. If that is not set, the plugin reads `/etc/os-release` instead.

Many distros available from `wsl --list --online` ship with matching icons and brand colors—Ubuntu, Debian, Arch, Fedora, openSUSE, Kali, Rocky, AlmaLinux, Oracle Linux, and others. If yours is not in the list, you get a generic Windows-style icon and the color from `SPACESHIP_WSL_COLOR` (cyan by default).

## Customization

Set `SPACESHIP_WSL_SHOW=false` to turn the section off entirely.

`SPACESHIP_WSL_ICON_STYLE` controls icons: `nerd` (default), `emoji`, `ascii`, or `none`. Use `emoji` or `ascii` when your terminal font is not a Nerd Font.

The usual Spaceship options are available: `SPACESHIP_WSL_PREFIX`, `SPACESHIP_WSL_SUFFIX`, `SPACESHIP_WSL_ICON`, and `SPACESHIP_WSL_COLOR` control the fallback icon and color when there is no per-distro match.

To override a specific distro, extend the associative arrays in your `.zshrc`. Keys are lowercase distro IDs (`ubuntu`, `opensuse-leap`, and so on):

```zsh
typeset -gA SPACESHIP_WSL_DISTRO_SYMBOLS SPACESHIP_WSL_DISTRO_COLORS

SPACESHIP_WSL_DISTRO_SYMBOLS[my-distro]=$'\uF17A '
SPACESHIP_WSL_DISTRO_COLORS[my-distro]='#ff6600'
```

The full list of supported WSL distros lives in `SPACESHIP_WSL_DISTROS` inside `spaceship-wsl.plugin.zsh`.

## Tests

```zsh
zsh tests/run_tests.zsh
```

Tests run on GitHub Actions for every push and pull request.

## License

MIT
