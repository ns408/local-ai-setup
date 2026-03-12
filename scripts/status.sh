#!/usr/bin/env bash
pgrep -f "server" && echo "llama.cpp server running on http://localhost:8080" || echo "Server not running"
