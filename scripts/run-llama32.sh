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

# XPS: 16K–32K context possible
# ASUS: stick to 8K–16K max
if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=32768   # XPS – can push higher
else
  CONTEXT=16384   # ASUS
fi

echo "Starting Llama 3.2 3B Instruct (Q5_K_M) – context: $CONTEXT tokens"
echo "Using server: $SERVER"

$SERVER \
  -m ~/llama/models/llama-3.2-3b-instruct-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \
  --host 0.0.0.0 \
  --port 8080 \
  -fa auto
