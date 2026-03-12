#!/usr/bin/env bash

# Kill any running llama server
killall -q llama-server 2>/dev/null || true
killall -q server 2>/dev/null || true

# Detect which binary exists
if [ -f ~/llama/llama.cpp/llama-server ]; then
  SERVER=~/llama/llama.cpp/llama-server
elif [ -f ~/llama/llama.cpp/build/bin/llama-server ]; then
  SERVER=~/llama/llama.cpp/build/bin/llama-server
elif [ -f ~/llama/llama.cpp/server ]; then
  SERVER=~/llama/llama.cpp/server
elif [ -f ~/llama/llama.cpp/build/bin/server ]; then
  SERVER=~/llama/llama.cpp/build/bin/server
else
  echo "Error: llama server binary not found"
  echo "Expected locations:"
  echo "  ~/llama/llama.cpp/llama-server"
  echo "  ~/llama/llama.cpp/build/bin/llama-server"
  exit 1
fi

# XPS (12 GB): can use 16K context safely
# ASUS (8 GB): limit to 8K context to avoid heavy swap
if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=16384   # XPS
else
  CONTEXT=8192    # ASUS – safer
fi

echo "Starting Phi-3 Mini (Q5_K_M) – context: $CONTEXT tokens"
echo "Using server: $SERVER"

$SERVER \
  -m ~/llama/models/phi-3-mini-4k-instruct-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \
  --host 0.0.0.0 \
  --port 8080 \
  -fa auto
