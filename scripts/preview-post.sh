#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_arg="${1:-drafts/good-stage-1-init.md}"

if [[ "$source_arg" = /* ]]; then
  source_file="$source_arg"
else
  source_file="$repo_dir/$source_arg"
fi

if [[ ! -f "$source_file" ]]; then
  echo "Draft not found: $source_file" >&2
  exit 1
fi

slug="$(basename "${source_file%.md}")"
preview_dir="$repo_dir/.preview"
output_file="$preview_dir/$slug.html"
template_file="$repo_dir/templates/post.html"

render() {
  mkdir -p "$preview_dir"
  pandoc "$source_file" \
    --from=gfm+tex_math_dollars \
    --to=html5 \
    --standalone \
    --toc \
    --toc-depth=2 \
    --mathjax \
    --template="$template_file" \
    --metadata=root=.. \
    --output="$output_file"
  echo "Rendered $output_file"
}

render

if [[ "${2:-}" == "--build-only" ]]; then
  exit 0
fi

watch() {
  while inotifywait -qq -e close_write,create,moved_to \
    "$(dirname "$source_file")" "$repo_dir/templates" "$repo_dir/styles.css"; do
    render || echo "Render failed; waiting for the next edit." >&2
  done
}

cleanup() {
  if [[ -n "${watch_pid:-}" ]]; then
    kill "$watch_pid" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

watch &
watch_pid=$!

echo "Preview: http://localhost:4000/.preview/$slug.html"
echo "Edit:    $source_file"
echo "Press Ctrl+C to stop."
cd "$repo_dir"
python3 -m http.server 4000
