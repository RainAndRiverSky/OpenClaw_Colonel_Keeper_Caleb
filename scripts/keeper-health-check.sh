#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

mkdir -p reports
mkdir -p reports/history

REPORT_FILE="reports/latest-health-report.txt"
HISTORY_FILE="reports/history/health-$(date +%Y%m%d-%H%M%S).txt"

{
echo "=== Keeper Health Check ==="
echo "Time: $TIMESTAMP"
echo ""

echo "[HeyDay]"

if lsof -i :3000 > /dev/null 2>&1
then
  echo "STATUS: ONLINE"
else
  echo "STATUS: OFFLINE"
fi

echo ""

echo "[Harbor]"

if pgrep -f "harbor-scheduler.js" > /dev/null
then
  echo "STATUS: ONLINE"
else
  echo "STATUS: OFFLINE"
fi

echo ""

echo "[Ayel Discord]"

if pgrep -f "bot.py" > /dev/null
then
  echo "STATUS: ONLINE"
else
  echo "STATUS: OFFLINE"
fi

echo ""

echo "[Keeper]"
echo "STATUS: ONLINE"

echo ""
echo "=== End Report ==="

} | tee "$REPORT_FILE" | tee "$HISTORY_FILE"
