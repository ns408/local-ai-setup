# AI Model Requirements & Performance Expectations

## Current AI Model Context Windows (2025-2026)

### Ultra-Long Context Champions (1M+ Tokens)
- **Gemini 3 Pro:** 10 Million Tokens
- **Llama 4 Scout:** 10 Million Tokens  
- **OpenAI GPT-4.1:** 1 Million Tokens
- **Gemini 2.5 Pro:** 1 Million Tokens

### High-Performance Mid-Range (200K-1M Tokens)
- **GPT-5 Series:** 400,000 Tokens
- **Claude 4 Sonnet:** 200,000 Tokens

### Standard Context Models (128K-200K Tokens)
- **DeepSeek V3:** 128,000 Tokens
- **Llama 3.1 Series:** 128,000 Tokens
- **Cohere Command-R+:** 128,000 Tokens

### Local Model Context Windows
- **Phi-3 Mini:** 128K Tokens
- **Llama 3.2 3B:** 131K Tokens  
- **Qwen 2.5 3B:** 32K Tokens
- **Mistral 7B:** 8K Tokens
- **CodeLlama 7B:** 16K Tokens

## Hardware Summary

### XPS Laptop (Dell L412Z)
- **CPU:** Intel Core i5-2430M @ 2.40GHz (2nd gen, 4 threads, 3.0GHz turbo)
- **RAM:** 12GB DDR3 (4GB+8GB @ 1333MHz)
- **Graphics:** Intel HD 2000 + NVIDIA GT 520M (nouveau driver)
- **Storage:** 500GB Samsung SSD 870 EVO + 3x external My Passport drives (1TB, 1TB, 2TB)
- **Chipset:** Intel HM67 Express
- **Network:** Intel Centrino Advanced-N 6230 + Atheros AR8151 Ethernet

### ASUS U36JC Laptop  
- **CPU:** Intel Core i5-480M @ 2.67GHz (1st gen, 4 threads, 2.67GHz)
- **RAM:** 8GB DDR3 (2x4GB @ 1067MHz)
- **Graphics:** Intel HD Graphics + GeForce 310M (nouveau driver)
- **Storage:** 500GB Samsung SSD 850
- **Chipset:** Intel HM55 Express
- **Network:** Atheros AR9285 WiFi + Realtek RTL8111 Ethernet

## AI Model Requirements Table

| Model | Parameters | RAM Required | Context Size | XPS Performance | ASUS Performance | Use Case |
|-------|------------|--------------|--------------|-----------------|------------------|----------|
| **Lightweight Models (3B-4B)** |
| Phi-3 Mini | 3.8B | ~4GB | 128K | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐ Good | Reasoning, system tools |
| Llama 3.2 3B | 3B | ~3GB | 131K | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐ Good | Coding, general |
| Qwen 2.5 3B | 3B | ~3GB | 32K | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐ Good | Coding, Chinese |
| TinyLlama 1.1B | 1.1B | ~1.5GB | 2K | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐⭐ Excellent | Quick tasks |
| **Medium Models (7B-8B)** |
| Llama 3.2 8B | 8B | ~6GB | 131K | ⭐⭐⭐⭐ Good | ⭐⭐ Fair | Complex coding |
| Qwen 2.5 7B | 7B | ~5GB | 32K | ⭐⭐⭐⭐ Good | ⭐⭐ Fair | Advanced coding |
| Mistral 7B | 7B | ~5GB | 8K | ⭐⭐⭐⭐ Good | ⭐⭐ Poor | General purpose |
| CodeLlama 7B | 7B | ~5GB | 16K | ⭐⭐⭐⭐ Good | ⭐⭐ Poor | Code specialized |
| **Heavy Models (13B+)** |
| Llama 3.1 8B | 8B | ~6GB | 128K | ⭐⭐⭐ Fair | ⭐ Poor | Advanced tasks |
| DeepSeek Coder 6.7B | 6.7B | ~5GB | 16K | ⭐⭐⭐⭐ Good | ⭐⭐ Fair | Code generation |
| DeepSeek V3 | - | ~8GB | 128K | ⭐⭐ Fair | ❌ Not viable | Advanced reasoning |

## Token Processing Expectations

### Input/Output Tokens per Second

| Model | XPS (CPU) | ASUS (CPU) | Typical Input | Typical Output |
|-------|-----------|------------|---------------|----------------|
| Phi-3 Mini | 18-25 t/s | 12-18 t/s | 2K tokens | 800 tokens |
| Llama 3.2 3B | 15-22 t/s | 10-15 t/s | 4K tokens | 1K tokens |
| Qwen 2.5 3B | 15-22 t/s | 10-15 t/s | 2K tokens | 800 tokens |
| Mistral 7B | 10-15 t/s | 6-10 t/s | 4K tokens | 1.5K tokens |
| CodeLlama 7B | 8-12 t/s | 5-8 t/s | 2K tokens | 1K tokens |
| DeepSeek Coder 6.7B | 12-18 t/s | 8-12 t/s | 3K tokens | 1.2K tokens |

### Context Window Performance

| Context Size | XPS Impact | ASUS Impact | Recommendation |
|--------------|------------|-------------|----------------|
| 4K tokens | Minimal | Minor | Safe for both |
| 8K tokens | Minor | Moderate | Both viable |
| 16K tokens | Moderate | Significant | XPS preferred |
| 32K tokens | Moderate | Severe | XPS only |
| 64K+ tokens | Significant | Severe | Not recommended |
| 128K tokens | Significant | Severe | XPS only with swap |

## Recommended Model Configurations

### XPS Laptop - Primary Setup
```
Main Model: Phi-3 Mini (3.8B)
- Context: 8K-16K tokens
- Expected: 18-25 t/s
- Use: 60% coding, 40% reasoning

Secondary: Llama 3.2 3B
- Context: 32K tokens  
- Expected: 15-22 t/s
- Use: Large context tasks

Tertiary: DeepSeek Coder 6.7B
- Context: 8K-16K tokens
- Expected: 12-18 t/s
- Use: Code generation
```

### ASUS Laptop - Optimized Setup
```
Main Model: Phi-3 Mini (3.8B)
- Context: 4K-8K tokens
- Expected: 12-18 t/s
- Use: 50% coding, 50% reasoning

Secondary: Llama 3.2 3B
- Context: 8K tokens
- Expected: 10-15 t/s
- Use: Moderate context tasks

Tertiary: TinyLlama 1.1B
- Context: 2K tokens
- Expected: 25-30 t/s
- Use: Quick responses
```

## System Tool & Binary Understanding Models

### Best for System Administration
1. **Phi-3 Mini** - Strong reasoning, tool usage
2. **Llama 3.2 3B** - Good command-line understanding  
3. **Qwen 2.5 3B** - Excellent binary knowledge

### Coding-Specific Recommendations
1. **CodeLlama 7B** (XPS only) - Code specialized
2. **DeepSeek Coder 6.7B** (XPS only) - Modern code patterns
3. **Llama 3.2 3B** - Balanced coding/reasoning

## Deployment Recommendations

### Interface Choice
- **CLI (Ollama):** Recommended for both laptops
- **GUI (LM Studio):** Viable on XPS, challenging on ASUS
- **Web Interface:** Good for both, resource-efficient

### Memory Management
- **XPS:** Can run 7B models comfortably, 8B models with swap
- **ASUS:** Best with 3B-4B models, 7B possible with careful management
- **Swap:** Configure 8GB swap on XPS for 8B models, 4GB on ASUS

### Performance Optimizations
- **CPU Governor:** Performance mode on both
- **Background Services:** Disable unnecessary services
- **Model Quantization:** Use Q4/Q5 quantized models
- **Batch Processing:** Smaller batches for better responsiveness

## Expected Use Case Performance

### Development Tasks
| Task | XPS Model | ASUS Model | Expected Time |
|------|-----------|------------|----------------|
| Code generation (100 lines) | Phi-3 Mini | Phi-3 Mini | 15-25s / 20-30s |
| Debug assistance | Llama 3.2 3B | Phi-3 Mini | 10-20s / 15-25s |
| System troubleshooting | Phi-3 Mini | Phi-3 Mini | 20-30s / 25-35s |
| File analysis | Qwen 2.5 3B | Llama 3.2 3B | 15-25s / 20-30s |

### Reasoning Tasks
| Task | XPS Model | ASUS Model | Expected Time |
|------|-----------|------------|----------------|
| Logic problems | Phi-3 Mini | Phi-3 Mini | 10-20s / 15-25s |
| System architecture | Llama 3.2 3B | Phi-3 Mini | 20-30s / 25-35s |
| Documentation | Qwen 2.5 3B | Llama 3.2 3B | 15-25s / 20-30s |

## Long-term Viability

### XPS Laptop (Dell L412Z)
- **Current:** Excellent for medium workloads, good for 7B models
- **Future:** Well-positioned for newer 3B-8B models, 12GB RAM is sufficient
- **Upgrade Path:** RAM max 16GB (already has 12GB), SSD 870 EVO is current

### ASUS Laptop (U36JC)  
- **Current:** Limited to lightweight models, 8GB RAM is constraint
- **Future:** May struggle with newer models, RAM upgrade recommended
- **Upgrade Path:** RAM max 16GB (upgrade recommended), SSD 850 is adequate

## Summary Recommendations

**For Coding Focus:**
- XPS: Phi-3 Mini + Llama 3.2 3B + DeepSeek Coder 6.7B
- ASUS: Phi-3 Mini + Llama 3.2 3B

**For System Administration:**
- Both: Phi-3 Mini (best tool understanding)
- XPS: Add Qwen 2.5 3B for complex tasks

**For Balanced Use:**
- XPS: Phi-3 Mini + Llama 3.2 3B + DeepSeek Coder 6.7B
- ASUS: Phi-3 Mini + Llama 3.2 3B + TinyLlama 1.1B

**For Maximum Performance:**
- XPS: Can handle 7B models comfortably, use 128K context windows
- ASUS: Stick to 3B-4B models, use 32K context windows max

**Key Advantage:** XPS's 12GB RAM and Samsung 870 EVO SSD provide significantly better performance for local AI workloads compared to ASUS's 8GB RAM and older 850 SSD.
