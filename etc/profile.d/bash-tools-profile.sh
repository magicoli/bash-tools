COMPOSER_HOME=${COMPOSER_HOME:-$(composer config --global home)}

BASH_TOOLS_DIR=$(cd $(dirname ${BASH_SOURCE[0]})/../.. && pwd)

for source in ${BASH_TOOLS_DIR}/etc/bash_completion.d/*; do
    [ -f "$source" ] && source "$source"
done
