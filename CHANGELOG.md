## Changelog

### Unreleased

- fix: yesno takes one key on a terminal, Enter for the default
- add .editorconfig
- doc: clarify differences between path-helpers and bash-helpers

### 1.0.6

- fix: include $TMP in trap delete command
- fix: read_env exit with error when APP_ENV is not set

### 1.0.4

- fix composer.json version follows the tag again (1.0.3 still said 1.0.2, composer and Packagist skipped that tag)
- removed ini_parser, no longer used, crudini does its job

### 1.0.3

- new bash-helpers require function, stops unless the given commands are available
- update Debian package follows the Debian layout: files in /usr/share/bash-tools, commands in /usr/bin

### 1.0.2

- update bash-helpers and ini_parser libraries moved to src/lib, next to path-helpers
- new bash-helpers and ini_parser loaders in bin, so source bash-helpers keeps working from the PATH and composer vendor/bin
- update ini_parser checks it is sourced, like bash-helpers

### 1.0.1

- new Debian package, installed from the Magiiic apt repository
- new wtclient script
- new bash-helpers: GNU getopt argument parsing (COMMANDOPTS), caller location in traced logs
- fix scripts reached through links (packages, composer vendor/bin, lerd)
- fix yesno reads its answer from standard input, empty arguments, preset BASE_DIR and APP_ENV respected
- update faster path and boolean helpers, terminal functions moved to src/lib/path-helpers
- update titlecase is now a deprecated wrapper of the title_case function
- removed trash, use gio trash, trash-cli or the macOS trash command instead

### 1.0.0-beta-1

- Functions:
    - **path manipulation**: append_path, prepend_path, add_path, clean_path
    - **colors**: ansi_color $color $style $scope, ansi_reset
    - **colors shortcuts**: ($BLACK, $RED, $GREEN, $BG_BLACK, $BG_RED...)
    - **strings conversion**: transliterate, words, ucfirst, camel_case, constant_case, kebab_case, lower_case, upper_case, pascal_case, screaming_snake_case, snake_case, dot_var
    - **boolean** (understand y/n, yes/no, true/false, ...): is_false, is_true
    - **time**: seconds_to_string, countdown
    - **ui**: error, help, log, readvar, success, usage, yesno
    - **dev**: debug, debug_mode, die, end, get_config, update_env, update_env_keys, urldecode, urlencode
- **Common scripts**, added to vendor binaries: cpuinfo, ini_parser, mail-report, randompassword, stamp, stampfile, tildelete, titlecase, trash, tts
- **Other scripts**, available from repo bin/ directory (mostly backwards-compatibility wrappers for tools available in bash-helpers functions): ucfirst, urlcoder, urldecoder, urlencoder, webnormalize
