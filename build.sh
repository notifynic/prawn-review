#!/bin/sh
# Builds index.html from template.html by swapping in Nic's three lab prawn PNGs as data URIs.
# Run from anywhere: sh build.sh
set -e
cd "$(dirname "$0")"
ART="../pixel-editor/art/lab shrimp final"
G=$(base64 -w0 "$ART/shrimp_glasses_final.png")
B=$(base64 -w0 "$ART/shrimp_beaker_final.png")
C=$(base64 -w0 "$ART/shrimp_stretched_clipboard_b2.png")
# Shrimp Stacking's coat pieces: __COAT_<name>__ for each PNG, __COAT_META__ for coat-pieces.json.
COAT="art/coat-variants"
SED=$(mktemp)
trap 'rm -f "$SED"' EXIT
for f in "$COAT"/*.png; do
  printf 's|__COAT_%s__|data:image/png;base64,%s|g\n' "$(basename "$f" .png)" "$(base64 -w0 "$f")" >> "$SED"
done
printf 's|__COAT_META__|%s|g\n' "$(tr -d '\r\n' < "$COAT/coat-pieces.json")" >> "$SED"
sed -e "s|__GLASSES__|data:image/png;base64,$G|g" \
    -e "s|__BEAKER__|data:image/png;base64,$B|g" \
    -e "s|__CLIPBOARD__|data:image/png;base64,$C|g" \
    -f "$SED" template.html > index.html
if grep -q "__COAT_" index.html; then echo "Missing coat piece: $(grep -o '__COAT_[A-Za-z0-9-]*__' index.html | head -1)" >&2; exit 1; fi
# GitHub Pages copy (served from /docs): a full page with the doctype and phone viewport the artifact host adds itself.
mkdir -p docs
{
  printf '<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  cat index.html
} > docs/index.html
echo "Built index.html and docs/index.html"
