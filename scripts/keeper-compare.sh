#!/bin/bash

LATEST=$(ls -1t reports/history/*.txt | sed -n '1p')
PREVIOUS=$(ls -1t reports/history/*.txt | sed -n '2p')

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
OUTPUT_FILE="reports/comparisons/comparison-$TIMESTAMP.txt"

echo "=== Keeper Change Report ===" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "LATEST REPORT: $LATEST" >> "$OUTPUT_FILE"
echo "PREVIOUS REPORT: $PREVIOUS" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

if [ -z "$PREVIOUS" ]
then
  echo "Not enough historical reports to compare." | tee -a "$OUTPUT_FILE"
  exit 0
fi

LATEST_SERVICES=$(grep '^\[' "$LATEST" | tr -d '[]')
PREVIOUS_SERVICES=$(grep '^\[' "$PREVIOUS" | tr -d '[]')

LATEST_STATUS_MAP=$(awk '
/^\[/ {
  service=$0
  gsub(/\[|\]/, "", service)
}
/^STATUS:/ {
  status=$2
  print service "=" status
}
' "$LATEST")

PREVIOUS_STATUS_MAP=$(awk '
/^\[/ {
  service=$0
  gsub(/\[|\]/, "", service)
}
/^STATUS:/ {
  status=$2
  print service "=" status
}
' "$PREVIOUS")

NEW_SERVICES=$(comm -23 \
  <(echo "$LATEST_SERVICES" | sort) \
  <(echo "$PREVIOUS_SERVICES" | sort))

REMOVED_SERVICES=$(comm -13 \
  <(echo "$LATEST_SERVICES" | sort) \
  <(echo "$PREVIOUS_SERVICES" | sort))

STATUS_CHANGES=$(join -t= \
  <(echo "$PREVIOUS_STATUS_MAP" | sort) \
  <(echo "$LATEST_STATUS_MAP" | sort) | \
awk -F= '
NF == 3 && $2 != $3 {
  print $1
  print $2 " → " $3
  print ""
}
')

echo "=== Keeper Change Report ==="
echo ""
echo "LATEST REPORT: $LATEST"
echo "PREVIOUS REPORT: $PREVIOUS"
echo ""

echo "NEW SERVICES:"
echo "-------------"

echo "NEW SERVICES:" >> "$OUTPUT_FILE"
echo "-------------" >> "$OUTPUT_FILE"

if [ -n "$NEW_SERVICES" ]
then
  echo "$NEW_SERVICES"
  echo "$NEW_SERVICES" >> "$OUTPUT_FILE"
else
  echo "None"
  echo "None" >> "$OUTPUT_FILE"
fi

echo ""
echo "REMOVED SERVICES:"
echo "-----------------"

echo "" >> "$OUTPUT_FILE"
echo "REMOVED SERVICES:" >> "$OUTPUT_FILE"
echo "-----------------" >> "$OUTPUT_FILE"

if [ -n "$REMOVED_SERVICES" ]
then
  echo "$REMOVED_SERVICES"
  echo "$REMOVED_SERVICES" >> "$OUTPUT_FILE"
else
  echo "None"
  echo "None" >> "$OUTPUT_FILE"
fi

echo ""
echo "STATUS CHANGES:"
echo "---------------"

echo "" >> "$OUTPUT_FILE"
echo "STATUS CHANGES:" >> "$OUTPUT_FILE"
echo "---------------" >> "$OUTPUT_FILE"

if [ -n "$STATUS_CHANGES" ]
then
  echo "$STATUS_CHANGES"
  echo "$STATUS_CHANGES" >> "$OUTPUT_FILE"
else
  echo "None"
  echo "None" >> "$OUTPUT_FILE"
fi

echo ""
echo "Archived to: $OUTPUT_FILE"
