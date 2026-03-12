#!/usr/bin/env bash
killall -q server 2>/dev/null || true

# XPS: 16K–32K context possible
# ASUS: stick to 8K–16K max

if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=32768   # XPS – can push higher
else
  CONTEXT=16384   # ASUS
fi

echo "Starting Llama 3.2 3B Instruct (Q5_K_M) – context: $CONTEXT tokens"

~/llama/llama.cpp/server \
  -m ~/llama/models/llama-3.2-3b-instruct-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \
  --host 0.0.0.0 \
  --port 8080 \
  -fa
