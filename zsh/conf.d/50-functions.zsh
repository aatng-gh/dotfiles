# Personal help files live at ~/.config/TOPIC/help.txt.
help() {
  local config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
  local topic="$1"
  local help_file

  if [[ -z "$topic" ]]; then
    print -r -- "Usage: help TOPIC"
    print -r -- ""
    print -r -- "Available topics:"
    for help_file in "$config_root"/*/help.txt(N); do
      print -r -- "  ${help_file:h:t}"
    done
    return
  fi

  help_file="$config_root/$topic/help.txt"
  if [[ ! -f "$help_file" ]]; then
    print -u2 -r -- "No help found for: $topic"
    return 1
  fi

  command cat -- "$help_file"
}

# ---- markdown -> PDF via the official pandoc/typst image (native arm64) ----
# Writes <name>.pdf next to the input <name>.md. The typst engine bundles
# Unicode-rich fonts with automatic fallback, so arrows/checkmarks/symbols
# render without LaTeX font hassles. Extra args pass through to pandoc, e.g.:
#   md2pdf notes.md --toc -V fontsize=11pt
md2pdf() {
  emulate -L zsh
  local in=$1
  [[ -n $in && -f $in ]] || { print -u2 "usage: md2pdf <file.md> [pandoc args...]"; return 1; }
  command -v container >/dev/null 2>&1 \
    || { print -u2 "Apple 'container' not found (see github.com/apple/container)."; return 1; }

  local abs=${in:A} dir base out
  dir=${abs:h}        # absolute dir — container requires absolute mount paths
  base=${abs:t}       # foo.md
  out=${base:r}.pdf   # foo.pdf

  # /data is the image's WORKDIR; --user keeps the output PDF owned by us, not
  # root. A trailing --pdf-engine=… in the extra args overrides typst.
  container run --rm \
    --volume "$dir:/data" \
    --user "$(id -u):$(id -g)" \
    docker.io/pandoc/typst:latest \
    --pdf-engine=typst "$base" -o "$out" "${@:2}" \
  && print -r -- "→ $dir/$out"
}

# ---- live preview: rebuild the PDF on every save ----
# Opens the PDF once (Preview reloads it on focus; Skim reloads instantly), then
# polls mtime and re-renders on change. Extra args pass through to md2pdf.
md2pdf-watch() {
  emulate -L zsh
  local in=$1
  [[ -n $in && -f $in ]] || { print -u2 "usage: md2pdf-watch <file.md> [pandoc args...]"; return 1; }
  md2pdf "$@" && open "${in:A:r}.pdf"
  print -u2 "watching $in — Ctrl-C to stop"
  local last=$(stat -f %m "$in" 2>/dev/null) cur
  while sleep 1; do
    cur=$(stat -f %m "$in" 2>/dev/null)
    [[ $cur == $last ]] && continue
    last=$cur
    md2pdf "$@"
  done
}
