# Benchmark Scripts

This directory contains scripts for benchmarking AI model performance across different hardware configurations.

## Scripts Overview

### `benchmark.sh` - Full Benchmark Suite
Comprehensive benchmark that tests all models with detailed performance metrics:
- **Load Time:** Time to start each model server
- **RAM Usage:** Memory consumption during operation  
- **Tokens/sec:** Inference performance
- **Input/Output Tokens:** Token counts for test prompt

**Usage:**
```bash
./benchmark.sh
```

**Features:**
- Auto-detects XPS (12GB) vs ASUS (8GB) hardware
- Skips incompatible models (e.g., DeepSeek on ASUS)
- Generates detailed markdown report in `.dev/benchmark-results.md`
- Creates logs in `.dev/logs/` for troubleshooting

### `quick-benchmark.sh` - Rapid Testing
Fast benchmark for quick performance checks:
- Tests basic startup time (30s timeout)
- Simple inference test
- Minimal dependencies

**Usage:**
```bash
./quick-benchmark.sh
```

**Output:** `.dev/quick-benchmark.md`

### `compare-benchmarks.sh` - Result Analysis
Analyzes and compares benchmark results across multiple runs:
- Shows recent benchmark history
- Identifies best performers
- Compares XPS vs ASUS performance

**Usage:**
```bash
./compare-benchmarks.sh    # Create comparison report
./compare-benchmarks.sh latest    # Show latest results
./compare-benchmarks.sh clean     # Clean old results
./compare-benchmarks.sh help      # Show help
```

## Benchmark Metrics

### Measured Parameters

| Metric | Description | Units |
|--------|-------------|-------|
| Load Time | Server startup time | Seconds |
| RAM Usage | Memory consumption | MB |
| Tokens/sec | Inference speed | tokens/second |
| Input Tokens | Prompt tokens | Count |
| Output Tokens | Generated tokens | Count |

### Test Prompt
Standard test prompt for all models:
```
"Write a Python function to calculate factorial of a number using recursion. Include error handling for negative inputs."
```

### Expected Performance Ranges

| Model | XPS Load Time | ASUS Load Time | XPS Tokens/sec | ASUS Tokens/sec |
|-------|---------------|----------------|----------------|----------------|
| TinyLlama 1.1B | 2-5s | 3-6s | 25-30 | 20-25 |
| Phi-3 Mini 3.8B | 5-10s | 8-15s | 18-25 | 12-18 |
| Llama 3.2 3B | 6-12s | 10-20s | 15-22 | 10-15 |
| Qwen 2.5 3B | 5-10s | 8-15s | 15-22 | 10-15 |
| DeepSeek Coder 6.7B | 10-20s | N/A | 12-18 | N/A |

## Dependencies

**Full Benchmark:**
```bash
sudo apt install bc netcat-openbsd curl jq
```

**Quick Benchmark:**
```bash
sudo apt install netcat-openbsd curl
```

**Alternative - Use dependency helper:**
```bash
./install-deps.sh
```

## Output Files

### `.dev/benchmark-results.md`
Detailed performance table with:
- Hardware configuration
- Complete metrics for each model
- Success/failure status
- Timestamps

### `.dev/quick-benchmark.md`
Simplified results with:
- Basic startup times
- Simple inference performance
- Pass/fail status

### `.dev/benchmark-comparison.md`
Comparative analysis with:
- Historical performance
- Best performers
- System comparisons
- Trend analysis

## Usage Examples

### Run Complete Benchmark
```bash
cd ~/llama/scripts
./benchmark.sh
```

### Quick Performance Check
```bash
./quick-benchmark.sh
```

### Compare Results
```bash
./compare-benchmarks.sh
./compare-benchmarks.sh latest
```

### Clean Old Results
```bash
./compare-benchmarks.sh clean
```

## Troubleshooting

### Common Issues

1. **Server fails to start**
   - Check model files exist in `~/llama/models/`
   - Verify llama.cpp is compiled: `cd ~/llama/llama.cpp && make`
   - Check logs in `.dev/logs/`

2. **High load times**
   - Check system load with `htop`
   - Ensure sufficient RAM available
   - Try smaller context sizes

3. **Inference failures**
   - Verify server is running: `./status.sh`
   - Check port 8080 availability: `netstat -tlnp | grep 8080`
   - Test manually: `curl http://localhost:8080/completion`

### Performance Tips

- **XPS (12GB):** Can run all models, use larger contexts
- **ASUS (8GB):** Stick to 3B models, keep context ≤ 16K
- **Monitor RAM:** Use `free -h` during benchmarks
- **Background processes:** Close unnecessary applications

## Automation

### Cron Job for Regular Benchmarks
```bash
# Add to crontab for daily benchmarks at 2 AM
0 2 * * * /home/user/llama/scripts/benchmark.sh
```

### Git Hooks for Performance Tracking
```bash
# .git/hooks/post-commit
#!/bin/bash
cd ~/llama/scripts
./quick-benchmark.sh
git add .dev/quick-benchmark.md
git commit -m "Update benchmark results"
```
