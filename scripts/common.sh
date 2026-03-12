#!/usr/bin/env bash
# Common functions for llama.cpp launcher scripts

# Find and return the path to the llama server binary
find_llama_server() {
    if [ -f ~/llama/llama.cpp/llama-server ]; then
        echo ~/llama/llama.cpp/llama-server
    elif [ -f ~/llama/llama.cpp/build/bin/llama-server ]; then
        echo ~/llama/llama.cpp/build/bin/llama-server
    elif [ -f ~/llama/llama.cpp/server ]; then
        echo ~/llama/llama.cpp/server
    elif [ -f ~/llama/llama.cpp/build/bin/server ]; then
        echo ~/llama/llama.cpp/build/bin/server
    else
        return 1
    fi
}

# Kill any running llama servers
kill_llama_servers() {
    killall -q llama-server 2>/dev/null || true
    killall -q server 2>/dev/null || true
}

# Get context size based on available RAM
get_context_size() {
    if free -m | grep -q "Mem:.*12000"; then
        echo 16384   # XPS (12GB)
    else
        echo 8192    # ASUS (8GB) - safer
    fi
}
