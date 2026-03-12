#!/bin/bash

# Quick Benchmark Script - Simple performance test
# For rapid testing without full infrastructure

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_FILE="$SCRIPT_DIR/../.dev/quick-benchmark.md"

# Create .dev directory
mkdir -p "$(dirname "$RESULTS_FILE")"

# Detect system
detect_system() {
    if free -m | grep -q "Mem:.*12000"; then
        echo "XPS"
    else
        echo "ASUS"
    fi
}

# Quick test for a single model
quick_test() {
    local model_script="$1"
    local model_name=$(basename "$model_script" .sh)
    local system=$(detect_system)
    
    echo "Testing $model_name..."
    
    # Skip DeepSeek on ASUS
    if [ "$model_name" = "run-deepseek" ] && [ "$system" = "ASUS" ]; then
        echo "✗ $model_name: Skipped (insufficient RAM)"
        return
    fi
    
    # Start timing
    local start_time=$(date +%s)
    
    # Start model
    timeout 30 "$model_script" >/dev/null 2>&1 &
    local model_pid=$!
    
    # Wait for server or timeout
    local elapsed=0
    while [ $elapsed -lt 25 ] && ! nc -z localhost 8080 2>/dev/null; do
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    if nc -z localhost 8080 2>/dev/null; then
        # Server started successfully
        local load_time=$((elapsed))
        
        # Quick inference test
        local inference_start=$(date +%s.%N)
        curl -s -X POST http://localhost:8080/completion \
            -H "Content-Type: application/json" \
            -d '{"prompt": "Hello world", "n_predict": 50}' >/dev/null 2>&1
        local inference_end=$(date +%s.%N)
        local inference_time=$(echo "$inference_end - $inference_start" | bc -l 2>/dev/null || echo "1.0")
        
        echo "✓ $model_name: Load ${load_time}s, Inference ${inference_time}s"
        
        # Kill server
        kill $model_pid 2>/dev/null || true
        sleep 1
    else
        echo "✗ $model_name: Failed to start within 30s"
        kill $model_pid 2>/dev/null || true
    fi
}

# Main function
main() {
    echo "=== Quick AI Model Benchmark ==="
    echo "System: $(detect_system)"
    echo "Date: $(date)"
    echo ""
    
    # Initialize results
    cat > "$RESULTS_FILE" << EOF
# Quick Benchmark Results

**System:** $(detect_system)  
**Date:** $(date)  
**Test:** Basic startup and inference performance

## Results

EOF
    
    # Test each model
    local models=("run-tiny.sh" "run-phi3.sh" "run-qwen25.sh" "run-llama32.sh" "run-deepseek.sh")
    
    for model in "${models[@]}"; do
        local script_path="$SCRIPT_DIR/$model"
        if [ -f "$script_path" ]; then
            quick_test "$script_path" | tee -a "$RESULTS_FILE"
            echo "" | tee -a "$RESULTS_FILE"
        fi
    done
    
    echo "Quick benchmark completed!"
    echo "Results saved to: $RESULTS_FILE"
}

# Check basic dependencies
if ! command -v nc >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
    echo "Missing dependencies: netcat-openbsd, curl"
    echo "Install with: sudo apt install netcat-openbsd curl"
    exit 1
fi

main "$@"
