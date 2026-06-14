#!/bin/bash

HISTORY_DIR="reports/history"

TOTAL_REPORTS=$(find "$HISTORY_DIR" -type f | wc -l | tr -d ' ')
LATEST_REPORT=$(ls -t "$HISTORY_DIR" 2>/dev/null | head -n 1)

echo "=== Keeper Summary ==="
echo ""
echo "Total Reports: $TOTAL_REPORTS"
echo ""

if [ -n "$LATEST_REPORT" ]; then
  echo "Newest Report:"
  echo "$LATEST_REPORT"
else
  echo "No reports found."
fi

echo ""
echo "=== End Summary ==="
