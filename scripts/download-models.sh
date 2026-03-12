#!/usr/bin/env bash

set -e

MODELS_DIR=~/llama/models
mkdir -p "$MODELS_DIR"

echo "Model Download Helper"
echo "===================="
echo ""
echo "This script will help you download GGUF models to $MODELS_DIR"
echo ""
echo "Available models:"
echo ""
echo "1. Phi-3 Mini 3.8B (Q5_K_M) - 2.8GB - Best balance for both laptops"
echo "2. Llama 3.2 3B (Q5_K_M) - 2.0GB - Coding and general tasks"
echo "3. TinyLlama 1.1B (Q5_K_M) - 638MB - Ultra-fast responses"
echo "4. Qwen 2.5 3B (Q5_K_M) - 2.1GB - Coding, multilingual"
echo "5. DeepSeek Coder 6.7B (Q5_K_M) - 4.8GB - XPS only, code specialist"
echo ""
echo "Download using huggingface-cli (recommended) or wget:"
echo ""

# Check if huggingface-cli is installed
if command -v huggingface-cli &> /dev/null; then
    echo "✓ huggingface-cli found"
    USE_HF=true
else
    echo "✗ huggingface-cli not found"
    echo "  Install with: pip install huggingface-hub[cli]"
    USE_HF=false
fi

echo ""
read -p "Which model do you want to download? (1-5, or 'all' for all models): " choice

download_phi3() {
    echo "Downloading Phi-3 Mini 3.8B (Q5_K_M)..."
    if [ "$USE_HF" = true ]; then
        huggingface-cli download microsoft/Phi-3-mini-4k-instruct-gguf \
            phi-3-mini-4k-instruct-q5_K_M.gguf \
            --local-dir "$MODELS_DIR" \
            --local-dir-use-symlinks False
    else
        wget -P "$MODELS_DIR" \
            "https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/phi-3-mini-4k-instruct-q5_K_M.gguf"
    fi
}

download_llama32() {
    echo "Downloading Llama 3.2 3B (Q5_K_M)..."
    if [ "$USE_HF" = true ]; then
        huggingface-cli download meta-llama/Llama-3.2-3B-Instruct-GGUF \
            llama-3.2-3b-instruct-q5_K_M.gguf \
            --local-dir "$MODELS_DIR" \
            --local-dir-use-symlinks False
    else
        wget -P "$MODELS_DIR" \
            "https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct-GGUF/resolve/main/llama-3.2-3b-instruct-q5_K_M.gguf"
    fi
}

download_tiny() {
    echo "Downloading TinyLlama 1.1B (Q5_K_M)..."
    if [ "$USE_HF" = true ]; then
        huggingface-cli download TinyLlama/TinyLlama-1.1B-Chat-v1.0-GGUF \
            tinyllama-1.1b-chat-q5_K_M.gguf \
            --local-dir "$MODELS_DIR" \
            --local-dir-use-symlinks False
    else
        wget -P "$MODELS_DIR" \
            "https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-q5_K_M.gguf"
    fi
}

download_qwen() {
    echo "Downloading Qwen 2.5 3B (Q5_K_M)..."
    if [ "$USE_HF" = true ]; then
        huggingface-cli download Qwen/Qwen2.5-3B-Instruct-GGUF \
            qwen2.5-3b-instruct-q5_K_M.gguf \
            --local-dir "$MODELS_DIR" \
            --local-dir-use-symlinks False
    else
        wget -P "$MODELS_DIR" \
            "https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF/resolve/main/qwen2.5-3b-instruct-q5_K_M.gguf"
    fi
}

download_deepseek() {
    echo "Downloading DeepSeek Coder 6.7B (Q5_K_M)..."
    if [ "$USE_HF" = true ]; then
        huggingface-cli download deepseek-ai/deepseek-coder-6.7b-instruct-GGUF \
            deepseek-coder-6.7b-instruct-q5_K_M.gguf \
            --local-dir "$MODELS_DIR" \
            --local-dir-use-symlinks False
    else
        wget -P "$MODELS_DIR" \
            "https://huggingface.co/deepseek-ai/deepseek-coder-6.7b-instruct-GGUF/resolve/main/deepseek-coder-6.7b-instruct-q5_K_M.gguf"
    fi
}

case $choice in
    1)
        download_phi3
        ;;
    2)
        download_llama32
        ;;
    3)
        download_tiny
        ;;
    4)
        download_qwen
        ;;
    5)
        download_deepseek
        ;;
    all)
        download_phi3
        download_llama32
        download_tiny
        download_qwen
        download_deepseek
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✓ Download complete!"
echo ""
echo "Models are in: $MODELS_DIR"
echo ""
echo "Run a model with:"
echo "  cd ~/llama/scripts"
echo "  ./run-phi3.sh"
