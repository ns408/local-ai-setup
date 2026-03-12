#!/bin/bash

# Benchmark Comparison Script
# Compares benchmark results across different runs/systems

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEV_DIR="$SCRIPT_DIR/../.dev"
COMPARISON_FILE="$DEV_DIR/benchmark-comparison.md"

# Create comparison report
create_comparison() {
    echo "Creating benchmark comparison..."
    
    cat > "$COMPARISON_FILE" << EOF
# Benchmark Comparison Report

Generated on: $(date)

## Recent Benchmark Runs

EOF
    
    # Find all benchmark result files
    local result_files=($(find "$DEV_DIR" -name "benchmark-results.md" -type f | sort -r | head -5))
    
    if [ ${#result_files[@]} -eq 0 ]; then
        echo "No benchmark results found. Run ./benchmark.sh first."
        return
    fi
    
    # Process each result file
    for file in "${result_files[@]}"; do
        local filename=$(basename "$file")
        local file_date=$(stat -c %y "$file" | cut -d' ' -f1,2 | cut -d'.' -f1)
        
        echo "### $filename ($file_date)" >> "$COMPARISON_FILE"
        echo "" >> "$COMPARISON_FILE"
        
        # Extract performance summary
        echo "**System:** $(grep -A5 "Hardware Configuration" "$file" | tail -1 | cut -d'|' -f1)" >> "$COMPARISON_FILE"
        echo "" >> "$COMPARISON_FILE"
        
        # Create performance table
        echo "| Model | Load Time | Tokens/sec | RAM Usage | Status |" >> "$COMPARISON_FILE"
        echo "|-------|-----------|------------|-----------|--------|" >> "$COMPARISON_FILE"
        
        # Extract successful runs
        grep "Success" "$file" | while IFS='|' read -r model params context system ram load tokens input output status; do
            # Clean up fields
            model=$(echo "$model" | xargs)
            load=$(echo "$load" | xargs)
            tokens=$(echo "$tokens" | xargs)
            ram=$(echo "$ram" | xargs)
            
            echo "| $model | $load | $tokens | $ram | ✓ |" >> "$COMPARISON_FILE"
        done
        
        echo "" >> "$COMPARISON_FILE"
    done
    
    # Add performance summary
    echo "## Performance Summary" >> "$COMPARISON_FILE"
    echo "" >> "$COMPARISON_FILE"
    
    # Find best performers across all runs
    echo "### Best Load Time" >> "$COMPARISON_FILE"
    grep "Success" "${result_files[0]}" | sort -k6,6n | head -1 | while IFS='|' read -r model params context system ram load tokens input output status; do
        model=$(echo "$model" | xargs)
        load=$(echo "$load" | xargs)
        echo "- **$model**: $load" >> "$COMPARISON_FILE"
    done
    echo "" >> "$COMPARISON_FILE"
    
    echo "### Highest Tokens/sec" >> "$COMPARISON_FILE"
    grep "Success" "${result_files[0]}" | sort -k7,7nr | head -1 | while IFS='|' read -r model params context system ram load tokens input output status; do
        model=$(echo "$model" | xargs)
        tokens=$(echo "$tokens" | xargs)
        echo "- **$model**: $tokens" >> "$COMPARISON_FILE"
    done
    echo "" >> "$COMPARISON_FILE"
    
    echo "### System Comparison" >> "$COMPARISON_FILE"
    echo "" >> "$COMPARISON_FILE"
    
    # Compare XPS vs ASUS if both present
    local xps_results=$(grep "XPS" "${result_files[0]}" | grep "Success" | wc -l)
    local asus_results=$(grep "ASUS" "${result_files[0]}" | grep "Success" | wc -l)
    
    echo "- **XPS**: $xps_results successful model tests" >> "$COMPARISON_FILE"
    echo "- **ASUS**: $asus_results successful model tests" >> "$COMPARISON_FILE"
    echo "" >> "$COMPARISON_FILE"
    
    echo "Comparison report saved to: $COMPARISON_FILE"
}

# Show latest results
show_latest() {
    local latest_file=$(find "$DEV_DIR" -name "benchmark-results.md" -type f | sort -r | head -1)
    
    if [ -n "$latest_file" ]; then
        echo "=== Latest Benchmark Results ==="
        echo "File: $(basename "$latest_file")"
        echo "Date: $(stat -c %y "$latest_file" | cut -d' ' -f1,2 | cut -d'.' -f1)"
        echo ""
        
        # Show summary table
        echo "| Model | Load Time | Tokens/sec | Status |"
        echo "|-------|-----------|------------|--------|"
        
        grep "Success\|Failed\|Skipped" "$latest_file" | while IFS='|' read -r model params context system ram load tokens input output status; do
            model=$(echo "$model" | xargs)
            load=$(echo "$load" | xargs)
            tokens=$(echo "$tokens" | xargs)
            status=$(echo "$status" | xargs)
            
            local status_icon="✓"
            if [ "$status" = "Failed" ] || [ "$status" = "Skipped" ]; then
                status_icon="✗"
            fi
            
            echo "| $model | $load | $tokens | $status_icon |"
        done
    else
        echo "No benchmark results found. Run ./benchmark.sh first."
    fi
}

# Clean old results
clean_results() {
    echo "Cleaning old benchmark results..."
    find "$DEV_DIR" -name "benchmark-results*.md" -type f -mtime +7 -delete 2>/dev/null || true
    find "$DEV_DIR" -name "logs" -type d -exec rm -rf {} + 2>/dev/null || true
    echo "Cleaned results older than 7 days."
}

# Main function
main() {
    case "${1:-compare}" in
        "compare")
            create_comparison
            ;;
        "latest")
            show_latest
            ;;
        "clean")
            clean_results
            ;;
        "help"|"-h"|"--help")
            echo "Usage: $0 [compare|latest|clean|help]"
            echo "  compare - Create comparison report (default)"
            echo "  latest  - Show latest benchmark results"
            echo "  clean   - Clean old results"
            echo "  help    - Show this help"
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use '$0 help' for usage information."
            exit 1
            ;;
    esac
}

main "$@"
