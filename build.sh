#!/bin/sh
# Builds index.html from template.html by swapping in Nic's three lab prawn PNGs as data URIs.
# Run from anywhere: sh build.sh
set -e
cd "$(dirname "$0")"
ART="../pixel-editor/art/lab shrimp final"
G=$(base64 -w0 "$ART/shrimp_glasses_final.png")
B=$(base64 -w0 "$ART/shrimp_beaker_final.png")
C=$(base64 -w0 "$ART/shrimp_stretched_clipboard_b2.png")
sed -e "s|__GLASSES__|data:image/png;base64,$G|g" \
    -e "s|__BEAKER__|data:image/png;base64,$B|g" \
    -e "s|__CLIPBOARD__|data:image/png;base64,$C|g" \
    template.html > index.html
# GitHub Pages copy (served from /docs): a full page with the doctype and phone viewport the artifact host adds itself.
mkdir -p docs
{
  printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  cat index.html
} > docs/index.html
echo "Built index.html and docs/index.html"
