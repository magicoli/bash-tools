#!/usr/bin/env bash
# yesno: on a terminal one key answers, with no Enter, and Enter takes the default; a line is read when the input is not
# a terminal. The terminal is a pseudo-terminal: the keys are sent without Enter, so a prompt that waits for it times out.
#
# Run with: tests/lib/bashunit tests/yesno-test.sh

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# The status of yesno ARGS after the keys typed on a terminal, "timeout" when it still waits
typed() { # keys, yesno arguments...
    local keys=$1
    shift
    python3 - "$keys" "$ROOT/src/lib/path-helpers" "$@" <<'PY'
import os, pty, select, sys, time

keys = sys.argv[1].encode().decode('unicode_escape').encode()
script = '. "$1"; shift; yesno "$@"; echo "status=$?"'
pid, fd = pty.fork()
if pid == 0:
    os.execvp('bash', ['bash', '-c', script, 'bash'] + sys.argv[2:])

def read_until(marker, seconds):
    out, end = b'', time.time() + seconds
    while marker not in out and time.time() < end:
        if select.select([fd], [], [], 0.2)[0]:
            try:
                data = os.read(fd, 1024)
            except OSError:
                break
            if not data:
                break
            out += data
    return out

read_until(b') ', 5)
for key in keys:
    os.write(fd, bytes([key]))
out = read_until(b'status=', 3)
text = out.decode(errors='replace')
print(text.split('status=')[1].strip()[:1] if 'status=' in text else 'timeout')
PY
}

function test_y_answers_yes_without_enter() {
    assert_equals "0" "$(typed 'y' 'Go on?')"
}

function test_n_answers_no_without_enter() {
    assert_equals "1" "$(typed 'n' 'Go on?')"
}

function test_a_capital_letter_counts() {
    assert_equals "0" "$(typed 'Y' 'Go on?')"
}

function test_enter_takes_the_default_no() {
    assert_equals "1" "$(typed '\r' 'Go on?')"
}

function test_enter_takes_the_default_yes() {
    assert_equals "0" "$(typed '\r' y 'Go on?')"
}

function test_any_other_key_is_no_even_with_yes_as_default() {
    assert_equals "1" "$(typed 'x' y 'Go on?')"
}

function test_a_line_is_read_when_the_input_is_not_a_terminal() {
    local answers
    answers=$(printf 'y\nn\nyes\n\n' | bash -c '. "$1"; for i in 1 2 3 4; do yesno "Go on?" && echo yes || echo no; done' bash "$ROOT/src/lib/path-helpers" 2>/dev/null | tr '\n' ' ')
    assert_equals "yes no yes no " "$answers"
}

function test_the_default_applies_to_an_empty_line_and_to_the_end_of_the_input() {
    local answers
    answers=$(printf '\n' | bash -c '. "$1"; yesno y "Go on?" && echo yes || echo no; yesno y "Again?" && echo yes || echo no' bash "$ROOT/src/lib/path-helpers" 2>/dev/null | tr '\n' ' ')
    assert_equals "yes yes " "$answers"
}
