#!/usr/bin/env bash
# Собирает PDF-шпаргалки из HTML-исходников в этом каталоге.
# Использование: src/build.sh [имя ...]   (без аргументов — собрать все)
set -euo pipefail

cd "$(dirname "$0")/.."
CHROME="${CHROME:-$(command -v chromium || command -v chromium-browser || command -v google-chrome || echo /opt/pw-browsers/chromium-1194/chrome-linux/chrome)}"

targets=("$@")
if [ ${#targets[@]} -eq 0 ]; then
  mapfile -t targets < <(find src -name '*-ru.html' -printf '%f\n' | sed 's/\.html$//' | sort)
fi

for name in "${targets[@]}"; do
  src="src/${name}.html"
  out="pdf/${name}.pdf"
  [ -f "$src" ] || { echo "нет файла $src" >&2; exit 1; }
  "$CHROME" --headless --disable-gpu --no-sandbox --no-pdf-header-footer \
    --print-to-pdf="$out" "file://$PWD/$src" 2>/dev/null
  echo "$out"
done
