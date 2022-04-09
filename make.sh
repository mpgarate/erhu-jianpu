#!/usr/bin/env bash

set -euxo pipefail

# shellcheck disable=SC2046,SC2086
SCRIPT_DIR="$(dirname $(readlink -e ${BASH_SOURCE[0]}))"

SCORE_NAME=${1:-make_all}

make_score() {
  set -euxo pipefail

  score_name=$1
  score_path="$SCRIPT_DIR/scores/jianpu/$score_name.jianpu"
  scratch_path="$SCRIPT_DIR/scores/scratch"

  rm -rf "$scratch_path"
  mkdir -p "$scratch_path"

  "$SCRIPT_DIR/jianpu-ly.py" "$score_path" > "$scratch_path/$score_name.ly"

  lilypond -o "$scratch_path/$score_name" "$scratch_path/$score_name.ly"

  cp "$scratch_path/$score_name.pdf" "$SCRIPT_DIR/scores/pdf"
  rm -rf "$scratch_path"
}

if [[ "$SCORE_NAME" == "make_all" ]]; then
  for f in scores/jianpu/* ; do
    score_name="$(echo "$(basename "$f")" | cut -d '.' -f 1)"
    $(make_score "$score_name")
  done
else
  $(make_score "$SCORE_NAME")

  echo "Build completed. Open with:"
  echo "xdg-open "$SCRIPT_DIR/scores/pdf/$SCORE_NAME.pdf""
fi
