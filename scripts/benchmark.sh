#!/bin/bash

# AI Model Benchmark Script
# Tests performance across different models and hardware configurations

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BENCHMARK_DIR="$SCRIPT_DIR/../.dev"
RESULTS_FILE="$BENCHMARK_DIR/benchmark-results.md"
LOG_DIR="$BENCHMARK_DIR/logs"

# Create directories
mkdir -p "$BENCHMARK_DIR" "$LOG_DIR"

# Initialize results file
init_results() {
    cat > "$RESULTS_FILE" << EOF
# AI Model Benchmark Results

Generated on: $(date)

## Hardware Configuration

| System | CPU | RAM | Storage | OS |
|--------|-----|-----|---------|----|
| XPS L412Z | Intel i5-2430M @ 2.40GHz | 12GB DDR3 @ 1333MHz | Samsung SSD 870 EVO | Ubuntu 24.04.4 LTS |
| ASUS U36JC | Intel i5-480M @ 2.67GHz | 8GB DDR3 @ 1067MHz | Samsung SSD 850 | Ubuntu 24.04.4 LTS |

## Performance Metrics

| Model | Parameters | Context | System | RAM Usage | Load Time | Tokens/sec | Input Tokens | Output Tokens | Test Status |
|-------|------------|---------|--------|-----------|-----------|-------------|--------------|---------------|-------------|
EOF
}

# Detect system
detect_system() {
    if free -m | grep -q "Mem:.*12000"; then
        echo "XPS"
    else
        echo "ASUS"
    fi
}

# Get RAM usage
get_ram_usage() {
    local process_name="$1"
    # Wait a moment for process to start
    sleep 2
    # Get RAM usage in MB
    local ram_mb=$(ps aux | grep "$process_name" | grep -v grep | awk '{sum+=$6} END {print sum/1024}')
    echo "${ram_mb:-0}"
}

# Measure load time
measure_load_time() {
    local model_script="$1"
    local log_file="$LOG_DIR/load_time_$(basename "$model_script" .sh).log"
    
    # Start timing
    local start_time=$(date +%s.%N)
    
    # Start the model server
    "$model_script" > "$log_file" 2>&1 &
    local server_pid=$!
    
    # Wait for server to be ready (check for port 8080)
    local timeout=60
    local elapsed=0
    while ! nc -z localhost 8080 2>/dev/null && [ $elapsed -lt $timeout ]; do
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    local end_time=$(date +%s.%N)
    local load_time=$(echo "$end_time - $start_time" | bc -l)
    
    if [ $elapsed -ge $timeout ]; then
        echo "60.0"  # Timeout
    else
        echo "$load_time"
    fi
    
    # Kill the server
    kill $server_pid 2>/dev/null || true
    sleep 2
}

# Run inference test
run_inference_test() {
    local test_prompt="Write a Python function to calculate factorial of a number using recursion. Include error handling for negative inputs."
    local temp_file=$(mktemp)
    
    # Send test prompt and measure response time
    local start_time=$(date +%s.%N)
    
    curl -s -X POST http://localhost:8080/completion \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$test_prompt\", \"n_predict\": 500}" > "$temp_file" 2>/dev/null
    
    local end_time=$(date +%s.%N)
    local response_time=$(echo "$end_time - $start_time" | bc -l)
    
    # Extract token information from response
    local input_tokens=$(jq -r '.prompt_eval_count // 0' "$temp_file" 2>/dev/null || echo "0")
    local output_tokens=$(jq -r '.eval_count // 0' "$temp_file" 2>/dev/null || echo "0")
    
    # Calculate tokens per second
    local tokens_per_sec=0
    if [ "$response_time" != "0" ] && [ "$output_tokens" != "0" ]; then
        tokens_per_sec=$(echo "scale=2; $output_tokens / $response_time" | bc -l)
    fi
    
    echo "$tokens_per_sec|$input_tokens|$output_tokens"
    
    rm -f "$temp_file"
}

# Benchmark a single model
benchmark_model() {
    local model_script="$1"
    local model_name=$(basename "$model_script" .sh)
    local system=$(detect_system)
    
    echo "Benchmarking $model_name on $system..."
    
    # Model parameters mapping
    case "$model_name" in
        "run-phi3") params="3.8B" ;;
        "run-llama32") params="3B" ;;
        "run-tiny") params="1.1B" ;;
        "run-qwen25") params="3B" ;;
        "run-deepseek") params="6.7B" ;;
        *) params="Unknown" ;;
    esac
    
    # Context size mapping
    case "$model_name" in
        "run-phi3") 
            if [ "$system" = "XPS" ]; then context="16384"; else context="8192"; fi ;;
        "run-llama32") 
            if [ "$system" = "XPS" ]; then context="32768"; else context="16384"; fi ;;
        "run-tiny") context="32768" ;;
        "run-qwen25") 
            if [ "$system" = "XPS" ]; then context="16384"; else context="8192"; fi ;;
        "run-deepseek") context="8192" ;;
        *) context="Unknown" ;;
    esac
    
    # Skip DeepSeek on ASUS
    if [ "$model_name" = "run-deepseek" ] && [ "$system" = "ASUS" ]; then
        echo "| $model_name | $params | $context | $system | N/A | N/A | N/A | N/A | N/A | Skipped (insufficient RAM) |" >> "$RESULTS_FILE"
        return
    fi
    
    # Measure load time
    local load_time=$(measure_load_time "$model_script")
    
    # Start server for inference test
    "$model_script" > "$LOG_DIR/${model_name}_server.log" 2>&1 &
    local server_pid=$!
    
    # Wait for server to be ready
    local timeout=60
    local elapsed=0
    while ! nc -z localhost 8080 2>/dev/null && [ $elapsed -lt $timeout ]; do
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    if [ $elapsed -ge $timeout ]; then
        echo "| $model_name | $params | $context | $system | N/A | Failed | N/A | N/A | N/A | Server failed to start |" >> "$RESULTS_FILE"
        kill $server_pid 2>/dev/null || true
        return
    fi
    
    # Get RAM usage
    local ram_usage=$(get_ram_usage "server")
    
    # Run inference test
    local inference_results=$(run_inference_test)
    local tokens_per_sec=$(echo "$inference_results" | cut -d'|' -f1)
    local input_tokens=$(echo "$inference_results" | cut -d'|' -f2)
    local output_tokens=$(echo "$inference_results" | cut -d'|' -f3)
    
    # Kill server
    kill $server_pid 2>/dev/null || true
    sleep 2
    
    # Add results to table
    echo "| $model_name | $params | $context | $system | ${ram_usage}MB | ${load_time}s | ${tokens_per_sec} | $input_tokens | $output_tokens | Success |" >> "$RESULTS_FILE"
    
    echo "✓ $model_name benchmark completed"
}

# Main benchmark execution
main() {
    echo "Starting AI Model Benchmark..."
    echo "System: $(detect_system)"
    echo "Date: $(date)"
    echo ""
    
    # Initialize results file
    init_results
    
    # Get list of model scripts
    local model_scripts=(
        "$SCRIPT_DIR/run-tiny.sh"
        "$SCRIPT_DIR/run-phi3.sh"
        "$SCRIPT_DIR/run-qwen25.sh"
        "$SCRIPT_DIR/run-llama32.sh"
        "$SCRIPT_DIR/run-deepseek.sh"
    )
    
    # Run benchmarks for each model
    for script in "${model_scripts[@]}"; do
        if [ -f "$script" ]; then
            benchmark_model "$script"
            echo "" >> "$RESULTS_FILE"
        else
            echo "Warning: $script not found"
        fi
    done
    
    echo ""
    echo "Benchmark completed!"
    echo "Results saved to: $RESULTS_FILE"
    echo "Logs saved to: $LOG_DIR"
    
    # Display summary
    echo ""
    echo "=== Benchmark Summary ==="
    echo "Total models tested: $(grep -c "Success" "$RESULTS_FILE")"
    echo "Failed tests: $(grep -c "Failed\|Skipped" "$RESULTS_FILE")"
    echo ""
    
    # Show best performing model
    echo "=== Top Performers ==="
    echo "Fastest load time:"
    grep "Success" "$RESULTS_FILE" | sort -k6,6n | head -1 | cut -d'|' -f1,6
    echo ""
    echo "Highest tokens/sec:"
    grep "Success" "$RESULTS_FILE" | sort -k7,7nr | head -1 | cut -d'|' -f1,7
}

# Check dependencies
check_dependencies() {
    local missing=()
    
    command -v bc >/dev/null 2>&1 || missing+=("bc")
    command -v nc >/dev/null 2>&1 || missing+=("netcat-openbsd")
    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v jq >/dev/null 2>&1 || missing+=("jq")
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[*]}"
        echo "Install with: sudo apt install ${missing[*]}"
        exit 1
    fi
}

# Run checks and main
check_dependencies
main "$@"
