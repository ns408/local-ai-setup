#!/usr/bin/env bash
killall -q server 2>/dev/null || true

# Only recommend on XPS (12 GB) – ASUS will swap heavily
if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=8192   # 16K possible but slower
  echo "Starting DeepSeek-Coder 6.7B Instruct (Q5_K_M) – context: $CONTEXT tokens"
  ~/llama/llama.cpp/server \
    -m ~/llama/models/deepseek-coder-6.7b-instruct-q5_K_M.gguf \
    -c $CONTEXT \
    -ngl 0 \
    --host 0.0.0.0 \
    --port 8080 \
    -fa
else
  echo "Not enough RAM (ASUS detected). Use a 3B model instead."
  exit 1
fi
