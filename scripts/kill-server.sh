#!/usr/bin/env bash
killall -q server 2>/dev/null && echo "Server stopped" || echo "No server running"
