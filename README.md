# Bash Tools

![Version](https://img.shields.io/badge/Version-1.0.2-blue)
![Stable](https://img.shields.io/badge/Stable-1.0.2-green)
![bash](https://img.shields.io/badge/bash-5.x+-red)

A couple of useful tools for bash scripting. Available either directly from the repo clone, or as a composer package.

## Features

**Functions** (source `bash-helpers` to make them available in your script):

- **ui**: error, help, log, readvar, success, usage, yesno
- **colors**: ansi_color $color $style $scope, ansi_reset
- **colors shortcuts**: ($BLACK, $RED, $GREEN, $BG_BLACK, $BG_RED...)
- **path manipulation**: append_path, prepend_path, add_path, clean_path
- **strings conversion**: transliterate, words, ucfirst, camel_case, constant_case, kebab_case, lower_case, upper_case, pascal_case, screaming_snake_case, snake_case, dot_var
- **boolean conversion** (y/n, yes/no, true/false, ...): is_false, is_true
- **time**: seconds_to_string, countdown
- **dev**: debug, debug_mode, die, end, get_config, require, update_env, update_env_keys, urldecode, urlencode

**Common scripts**, added to vendor binaries (`vendor/bin`)

- cpuinfo
- ini_parser
- mail-report
- randompassword
- stamp
- stampfile
- tildelete
- titlecase
- tts

**Other scripts** available from `bash-helpers/bin` directory (mostly backwards-compatibility wrappers for tools available in bash-helpers functions):

- bin/ucfirst
- bin/urlcoder
- bin/urldecoder
- bin/urlencoder
- bin/webnormalize

## Installation in your project

With composer:

```bash
composer require magicoli/bash-tools
```

### Use bash-helpers functions

Put this line at the beginning of your script (_do not run the file directly, source it_), to provide the most common functions to your script.

```bash
#!/usr/bin/env bash
source vendor/bin/bash-helpers
# or, installed globally: source bash-helpers
# or source <path-to-repo>/bin/bash-helpers
```

## Global installation (for use from terminal or any script)

### From the Magiiic apt repository (Debian, Ubuntu)

```bash
curl -fsSL https://apt.magiiic.com/magiiic-packaging.asc | sudo gpg --dearmor -o /usr/share/keyrings/magiiic-packaging.gpg
echo "deb [signed-by=/usr/share/keyrings/magiiic-packaging.gpg] https://apt.magiiic.com stable main" | sudo tee /etc/apt/sources.list.d/magiiic.list
sudo apt update && sudo apt install bash-tools
```

The commands are then in the PATH, and scripts can use `source bash-helpers`. Updates come with the system ones (`sudo apt upgrade`).

### With composer:

```bash
composer global require magicoli/bash-tools"
```

Insert in `~/.bashrc` or `~/.profile`, according to your system:

```bash
# Verify your composer home (usually ~/.composer or ~/.config/composer)
composer config data-dir
composer config -l | grep /bin

# Add composer bin dir to your profile file
# 	export PATH="<composer-home-dir>/vendor/bin:$PATH"
# E.g. one of:
export PATH="~/.composer/vendor/bin:$PATH"
export PATH="~/.config/composer/vendor/bin:$PATH"
```

### Directly from repo directory

Insert in `~/.bashrc` or `~/.profile`, according to your system:

```bash
export PATH="<path-to-repo>/bin:$PATH"
```
