#!/usr/bin/env bash

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Kill any running servers
kill_llama_servers

# Find server binary
SERVER=$(find_llama_server)
if [ -z "$SERVER" ]; then
    echo "Error: llama server binary not found"
    echo "Expected locations:"
    echo "  ~/llama/llama.cpp/llama-server"
    echo "  ~/llama/llama.cpp/build/bin/llama-server"
    exit 1
fi

# Only recommend on XPS (12 GB) – ASUS will swap heavily
if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=8192   # 16K possible but slower
  echo "Starting DeepSeek-Coder 6.7B Instruct (Q5_K_M) – context: $CONTEXT tokens"
  echo "Using server: $SERVER"
  
  $SERVER \
    -m ~/llama/models/deepseek-coder-6.7b-instruct-q5_K_M.gguf \
    -c $CONTEXT \
    -ngl 0 \
    --host 0.0.0.0 \
    --port 8080 \
    -fa auto
else
  echo "Not enough RAM (ASUS detected). Use a 3B model instead."
  exit 1
fi
