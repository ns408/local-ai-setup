#!/usr/bin/env bash
killall -q server 2>/dev/null || true

# XPS (12 GB): can use 16K context safely
# ASUS (8 GB): limit to 8K context to avoid heavy swap

if free -m | grep -q "Mem:.*12000"; then
  CONTEXT=16384   # XPS
else
  CONTEXT=8192    # ASUS – safer
fi

echo "Starting Phi-3 Mini (Q5_K_M) – context: $CONTEXT tokens"

~/llama/llama.cpp/server \
  -m ~/llama/models/phi-3-mini-4k-instruct-q5_K_M.gguf \
  -c $CONTEXT \
  -ngl 0 \                  # CPU only (change to 35–99 if you get old CUDA working)
  --host 0.0.0.0 \
  --port 8080 \
  -fa                       # Flash attention (speeds up on Intel CPUs)
