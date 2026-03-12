## Hardware Analysis Results

### Dell XPS L412Z
- **CPU:** Intel Core i5-2430M @ 2.40GHz (2nd gen, 4 threads, 3.0GHz turbo)
- **RAM:** 12GB DDR3 (4GB+8GB @ 1333MHz)
- **Graphics:** Intel HD 2000 + NVIDIA GT 520M (nouveau driver)
- **Storage:** 500GB Samsung SSD 870 EVO + 3x external My Passport drives
- **Chipset:** Intel HM67 Express
- **Network:** Intel Centrino Advanced-N 6230 + Atheros AR8151 Ethernet

### ASUS U36JC
- **CPU:** Intel Core i5-480M @ 2.67GHz (1st gen, 4 threads)
- **RAM:** 8GB DDR3 (2x4GB @ 1067MHz)
- **Graphics:** Intel HD Graphics + GeForce 310M (nouveau driver)
- **Storage:** 500GB Samsung SSD 850
- **Chipset:** Intel HM55 Express
- **Network:** Atheros AR9285 WiFi + Realtek RTL8111 Ethernet

## AI Model Recommendations

### XPS (12GB RAM) - Recommended Setup
- **Primary:** Phi-3 Mini (3.8B) - 16K context
- **Secondary:** Llama 3.2 3B - 32K context
- **Tertiary:** DeepSeek Coder 6.7B - 8K context

### ASUS (8GB RAM) - Optimized Setup
- **Primary:** Phi-3 Mini (3.8B) - 8K context
- **Secondary:** TinyLlama 1.1B - 32K context
- **Fallback:** Llama 3.2 3B - 16K context

## Performance Expectations

| Model | XPS Tokens/sec | ASUS Tokens/sec | Context |
|-------|----------------|-----------------|---------|
| Phi-3 Mini | 18-25 t/s | 12-18 t/s | 16K/8K |
| Llama 3.2 3B | 15-22 t/s | 10-15 t/s | 32K/16K |
| TinyLlama 1.1B | 25-30 t/s | 20-25 t/s | 32K |
| DeepSeek Coder 6.7B | 12-18 t/s | Not viable | 8K |
