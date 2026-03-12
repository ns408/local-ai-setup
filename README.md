# Local AI Setup

Optimized local AI model deployment for Dell XPS L412Z (12GB) and ASUS U36JC (8GB) laptops.

## Hardware Overview

### Dell XPS L412Z
- **CPU:** Intel Core i5-2430M @ 2.40GHz (2nd gen, 4 threads)
- **RAM:** 12GB DDR3 @ 1333MHz
- **Storage:** 500GB Samsung SSD 870 EVO
- **Capability:** 3B-8B models, up to 128K context

### ASUS U36JC
- **CPU:** Intel Core i5-480M @ 2.67GHz (1st gen, 4 threads)
- **RAM:** 8GB DDR3 @ 1067MHz
- **Storage:** 500GB Samsung SSD 850
- **Capability:** 3B-4B models, up to 32K context

## Quick Start

```bash
# Install everything
./scripts/install.sh

# Start a model (from ~/llama/scripts/)
./run-phi3.sh      # Best balance for both laptops
./run-tiny.sh      # Ultra-fast, especially on ASUS
./run-deepseek.sh  # XPS only - coding specialist
```

## Available Models

| Model | Size | Context | XPS | ASUS | Best For |
|-------|------|---------|-----|------|----------|
| Phi-3 Mini | 3.8B | 16K/8K | ✅ Excellent | ✅ Good | Reasoning, tools |
| Llama 3.2 3B | 3B | 32K/16K | ✅ Excellent | ✅ Good | Coding, general |
| TinyLlama 1.1B | 1.1B | 32K | ✅ Excellent | ✅ Excellent | Quick responses |
| Qwen 2.5 3B | 3B | 16K/8K | ✅ Excellent | ✅ Good | Coding, Chinese |
| DeepSeek Coder 6.7B | 6.7B | 8K | ✅ Good | ❌ Not viable | Code generation |

## Directory Structure

```
~/llama/
├── llama.cpp/server          # Compiled llama.cpp server
├── models/                   # Downloaded GGUF models
│   ├── phi-3-mini-4k-instruct-q5_K_M.gguf
│   ├── llama-3.2-3b-instruct-q5_K_M.gguf
│   ├── tinyllama-1.1b-chat-q5_K_M.gguf
│   ├── qwen2.5-3b-instruct-q5_K_M.gguf
│   └── deepseek-coder-6.7b-instruct-q5_K_M.gguf
└── scripts/                  # Launcher scripts
    ├── run-phi3.sh
    ├── run-llama32.sh
    ├── run-tiny.sh
    ├── run-qwen25.sh
    ├── run-deepseek.sh
    ├── kill-server.sh
    ├── status.sh
    └── install.sh
```

## Usage Examples

```bash
# Start Phi-3 Mini
cd ~/llama/scripts
./run-phi3.sh

# Check if running
./status.sh

# Switch to TinyLlama (very fast on ASUS)
./kill-server.sh
./run-tiny.sh

# XPS only: Start coding specialist
./run-deepseek.sh
```

## Performance Tips

- **XPS (12GB):** Can handle 7B models, use 32K context on 3B models
- **ASUS (8GB):** Stick to 3B-4B models, keep context ≤ 16K
- **Monitor RAM:** Use `htop` or `free -h` to avoid swap thrashing
- **Flash Attention:** `-fa` flag speeds up Intel CPUs
- **CPU Only:** `-ngl 0` (no GPU acceleration on these laptops)

## Model Downloads

Download models to `~/llama/models/`:

- [Phi-3 Mini](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf)
- [Llama 3.2 3B](https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct-GGUF)
- [TinyLlama](https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0-GGUF)
- [Qwen 2.5 3B](https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF)
- [DeepSeek Coder](https://huggingface.co/deepseek-ai/deepseek-coder-6.7b-instruct-GGUF)

Choose `Q5_K_M` quantization for best balance of quality and performance.

## Security

This project has been audited for security issues. The hardware analyzer script does not collect serial numbers or system identifiers. See [SECURITY.md](SECURITY.md) for details.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.
