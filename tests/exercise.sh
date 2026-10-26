# Sourced by every lessons/*/setup.sh and check.sh.
# setup.sh builds a practice repository in lab/<lesson>/; check.sh tells you whether
# you've done the exercise. Neither reads or changes your own git config: they run
# git with no global or system config, and lessons that practice --global settings
# give you a lab config file instead (source the lab's env.sh first).
set -uo pipefail
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
LESSON=$(basename "$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)")
LAB_ROOT=${LAB_ROOT:-$ROOT/lab}
LAB=$LAB_ROOT/$LESSON

# git with none of your settings: no global/system config, no hooks, no signing,
# and a fixed lab identity. Used to build the scenario and to inspect it.
lgit() {
    GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 \
    GIT_AUTHOR_NAME="Lab Author" GIT_AUTHOR_EMAIL=lab@example.com \
    GIT_COMMITTER_NAME="Lab Author" GIT_COMMITTER_EMAIL=lab@example.com \
    git -c init.defaultBranch=main -c commit.gpgSign=false -c tag.gpgSign=false \
        -c core.hooksPath=/dev/null -c advice.detachedHead=false "$@"
}
# commit FILE TEXT MESSAGE: append TEXT to FILE and commit it.
commit() { printf '%s\n' "$2" >> "$1" && lgit add "$1" && lgit commit -q -m "$3"; }

new_lab() {  # start lab/<lesson> from scratch
    case $LAB in
        "$LAB_ROOT"/?*) rm -rf -- "$LAB" ;;
        *) echo "refusing to clear $LAB" >&2; exit 1 ;;
    esac
    mkdir -p "$LAB"
}
need_lab() { [ -d "$LAB" ] || { echo "No lab yet: run lessons/$LESSON/setup.sh first."; exit 1; }; }
ready() {
    echo "Lab ready: $LAB"
    echo "The exercise is in lessons/$LESSON/README.md. When you're done: lessons/$LESSON/check.sh"
}
pass() { echo "PASS: $*"; exit 0; }
fail() { echo "Not yet: $*"; exit 1; }
# A lab config file standing in for ~/.gitconfig, for lessons about --global settings.
lab_env() {
    mkdir -p "$LAB/home"
    : > "$LAB/home/.gitconfig"
    cat > "$LAB/env.sh" <<EOF
# Source this file (". $LAB/env.sh") so 'git config --global' writes to the lab's
# config file instead of your own ~/.gitconfig. Open a new terminal to undo it.
export GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig"
echo "git config --global now means $LAB/home/.gitconfig"
EOF
}
# git that reads the lab's global config (and the repo's own), for checking those lessons.
egit() { GIT_CONFIG_GLOBAL="$LAB/home/.gitconfig" GIT_CONFIG_NOSYSTEM=1 git "$@"; }
