#!/usr/bin/env bash
set -e

# Resolución objetivo (recomendada)
W=800
H=450
QUALITY=85

DIR="."

# Detectar ImageMagick
if command -v magick >/dev/null 2>&1; then
  IM="magick"
elif command -v convert >/dev/null 2>&1; then
  IM="convert"
else
  echo "Error: ImageMagick no encontrado (magick / convert)."
  exit 1
fi

echo "Usando: $IM"
echo "Procesando imágenes en: $DIR"

find "$DIR" -maxdepth 1 -type f \( \
  -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \
\) -print0 | while IFS= read -r -d '' img; do

  echo "Adaptando: $(basename "$img")"

  tmp="${img}.tmp.jpg"

  "$IM" "$img" \
    -auto-orient \
    -resize "${W}x${H}"\> \
    -background black \
    -gravity center \
    -extent "${W}x${H}" \
    -strip \
    -quality "$QUALITY" \
    "$tmp"

  # Reemplazar archivo original
  mv -f "$tmp" "$img"
done

echo "Listo. Imágenes adaptadas en su lugar."
