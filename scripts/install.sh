#!/bin/bash

# Local AI Setup - Installation Script
# Optimized for Dell XPS L412Z (12GB) and ASUS U36JC (8GB)

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Local AI Setup Installation ==="
echo "Project directory: $PROJECT_DIR"

# Create directory structure
echo "Creating directory structure..."
mkdir -p ~/llama/{llama.cpp,models,scripts}

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y git build-essential cmake wget curl bc netcat-openbsd jq

# Clone and build llama.cpp
echo "Building llama.cpp..."
cd ~/llama

# Check if llama.cpp exists and has content
if [ ! -d llama.cpp ] || [ ! -f llama.cpp/Makefile ]; then
    echo "Cloning llama.cpp repository..."
    rm -rf llama.cpp  # Remove if empty
    git clone https://github.com/ggerganov/llama.cpp.git
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone llama.cpp repository"
        exit 1
    fi
fi

cd llama.cpp

# Build using Makefile (preferred method)
if [ -f Makefile ]; then
    echo "Building with Makefile..."
    make clean 2>/dev/null || true
    make -j$(nproc) LLAMA_CUBLAS=0
    
    # Check if server binary was created
    if [ ! -f server ]; then
        echo "Error: server binary not created"
        exit 1
    fi
    echo "✓ llama.cpp server built successfully"
else
    echo "Error: Makefile not found in llama.cpp directory"
    exit 1
fi

# Copy launcher scripts
echo "Installing launcher scripts..."
cp "$SCRIPT_DIR"/*.sh ~/llama/scripts/
chmod +x ~/llama/scripts/*.sh

# Create models directory structure
echo "Creating models directory..."
mkdir -p ~/llama/models

# Copy documentation
echo "Installing documentation..."
cp -r "$PROJECT_DIR/docs" ~/llama/
cp "$PROJECT_DIR/README.md" ~/llama/

# Download models (placeholder - user needs to download manually)
echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "1. Download models to ~/llama/models/:"
echo "   - phi-3-mini-4k-instruct-q5_K_M.gguf"
echo "   - llama-3.2-3b-instruct-q5_K_M.gguf"
echo "   - tinyllama-1.1b-chat-q5_K_M.gguf"
echo "   - qwen2.5-3b-instruct-q5_K_M.gguf"
echo "   - deepseek-coder-6.7b-instruct-q5_K_M.gguf"
echo ""
echo "2. Test installation:"
echo "   cd ~/llama/scripts"
echo "   ./run-tiny.sh"
echo ""
echo "3. Run benchmarks:"
echo "   ./benchmark.sh"
