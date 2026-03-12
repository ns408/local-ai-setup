#!/usr/bin/env bash
killall -q server 2>/dev/null || true

if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=16384
else
  CONTEXT=8192
fi

echo "Starting Qwen 2.5 3B Instruct (Q5_K_M) – context: $CONTEXT tokens"

~/llama/llama.cpp/server \
  -m ~/llama/models/qwen2.5-3b-instruct-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \
  --host 0.0.0.0 \
  --port 8080 \
  -fa
