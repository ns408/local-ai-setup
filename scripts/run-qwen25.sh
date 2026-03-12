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

if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=16384
else
  CONTEXT=8192
fi

echo "Starting Qwen 2.5 3B Instruct (Q5_K_M) – context: $CONTEXT tokens"
echo "Using server: $SERVER"

$SERVER \
  -m ~/llama/models/qwen2.5-3b-instruct-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \
  --host 0.0.0.0 \
  --port 8080 \
  -fa auto
