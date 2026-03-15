#!/bin/bash
# ─────────────────────────────────────────────────────────────────
# update_granites.sh
# Scans /home/sravani_ksys/images/granites/ for image files,
# parses filenames like "S K Blue - G005.jpg" into JSON entries,
# then writes /var/www/html/granites.json
#
# Usage:
#   chmod +x update_granites.sh
#   sudo ./update_granites.sh
#
# Run this every time you add new granite images.
# ─────────────────────────────────────────────────────────────────

IMAGES_DIR="/var/www/html/images/granites/"
OUTPUT_FILE="/var/www/html/granites.json"

echo "Scanning: $IMAGES_DIR"
echo ""

# Start JSON array
json="[\n"
first=true

for filepath in "$IMAGES_DIR"/*.{jpg,jpeg,png,JPG,JPEG,PNG}; do
  # Skip if glob found nothing
  [ -e "$filepath" ] || continue

  filename=$(basename "$filepath")
  extension="${filename##*.}"

  # Remove extension to get stem e.g. "S K Blue - G005"
  stem="${filename%.*}"

  # Parse: everything before " - " is the name, after is the code
  # Format expected: "Variety Name - GXXX"
  if [[ "$stem" =~ ^(.+)[[:space:]]-[[:space:]](G[0-9]+)$ ]]; then
    name="${BASH_REMATCH[1]}"
    code="${BASH_REMATCH[2]}"
  else
    # Fallback: use full stem as name, no code
    name="$stem"
    code="N/A"
    echo "  WARNING: Could not parse code from '$filename' — expected format: 'Name - GXXX.jpg'"
  fi

  echo "  ✓ $code  |  $name  |  $filename"

  # Build JSON entry
  entry="  {\n    \"code\": \"$code\",\n    \"name\": \"$name\",\n    \"image\": \"$filename\",\n    \"origin\": \"\"\n  }"

  if [ "$first" = true ]; then
    json+="$entry"
    first=false
  else
    json+=",\n$entry"
  fi
done

json+="\n]"

# Write output
echo -e "$json" > "$OUTPUT_FILE"

echo ""
echo "✅ Done! Written to $OUTPUT_FILE"
echo "   Reload your Granites page to see the changes."
