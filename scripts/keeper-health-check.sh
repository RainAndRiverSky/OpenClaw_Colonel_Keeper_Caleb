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

jq -c '.[]' services/services.json | while read -r SERVICE
do
  NAME=$(echo "$SERVICE" | jq -r '.name')
  TYPE=$(echo "$SERVICE" | jq -r '.type')
  PROCESS=$(echo "$SERVICE" | jq -r '.process // empty')
  PORT=$(echo "$SERVICE" | jq -r '.port // empty')

  echo "[$NAME]"

  STATUS="OFFLINE"

  if [ "$NAME" = "Keeper" ]
  then
    STATUS="ONLINE"
  else
    case "$TYPE" in
      process)
        if pgrep -f "$PROCESS" > /dev/null 2>&1
        then
          STATUS="ONLINE"
        fi
        ;;
      script)
        if pgrep -f "$PROCESS" > /dev/null 2>&1
        then
          STATUS="ONLINE"
        fi
        ;;
      port)
        if lsof -i :"$PORT" > /dev/null 2>&1
        then
          STATUS="ONLINE"
        fi
        ;;
    esac
  fi

  echo "STATUS: $STATUS"
  echo ""
done

echo "=== End Report ==="

} | tee "$REPORT_FILE" | tee "$HISTORY_FILE"
