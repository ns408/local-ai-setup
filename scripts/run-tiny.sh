#!/usr/bin/env bash
killall -q server 2>/dev/null || true

# TinyLlama is so small both machines can handle large context
CONTEXT=32768

echo "Starting TinyLlama 1.1B Chat (Q5_K_M) – context: $CONTEXT tokens"

~/llama/llama.cpp/server \
  -m ~/llama/models/tinyllama-1.1b-chat-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \
  --host 0.0.0.0 \
  --port 8080 \
  -fa
