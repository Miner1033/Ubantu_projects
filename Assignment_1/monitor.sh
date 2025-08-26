#!/bin/bash

# System Monitoring Script
# প্রতি ৫ সেকেন্ড পর সিস্টেমের তথ্য দেখাবে

while true; do
  echo "Current time: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "System uptime: $(uptime)"
  echo "Free disk space: $(df -h / | awk 'NR==2 {print $4}')"
  echo "Free memory: $(free -m | awk 'NR==2 {print $4}') MB"
  echo "Load average: $(cat /proc/loadavg | awk '{print $1,$2,$3}')"
  echo "-----------------------------------------------"
  
  # Top CPU and memory consuming processes
  echo "Top CPU and memory consuming processes:"
  ps -eo pid,%cpu,%mem,cmd --sort=-%mem | head -n 6
  
  # Check network connectivity
  if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "Network connection is UP"
  else
    echo "Network connection is DOWN"
  fi
  
  echo "-----------------------------------------------"
  sleep 5
done

