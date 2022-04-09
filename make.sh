#!/usr/bin/env bash

set -euxo pipefail

# shellcheck disable=SC2046,SC2086
SCRIPT_DIR="$(dirname $(readlink -e ${BASH_SOURCE[0]}))"

SCORE_NAME=${1:-make_all}

make_score() {
  set -euxo pipefail

  score_name=$1
  score_dir="$SCRIPT_DIR/scores/$score_name"

  "$SCRIPT_DIR/jianpu-ly.py" "$score_dir/$score_name.jianpu" \
    > "$score_dir/$score_name.ly"

  lilypond -o "$score_dir/$score_name" "$score_dir/$score_name.ly"
}

if [[ "$SCORE_NAME" == "make_all" ]]; then
  for f in scores/*/ ; do
    $(make_score "$(basename "$f")")
  done
else
  $(make_score "$SCORE_NAME")

  echo "Build completed."
  #xdg-open "$SCRIPT_DIR/scores/$SCORE_NAME/$SCORE_NAME.pdf"
fi
