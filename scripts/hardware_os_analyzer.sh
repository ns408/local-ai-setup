#!/bin/bash

# Comprehensive Hardware & OS Information Dump Script
# Run this script and provide the output file for AI model compatibility analysis

OUTPUT_FILE="hardware_os_dump_$(hostname)_$(date +%Y%m%d_%H%M%S).txt"

echo "=== Comprehensive Hardware & OS Dump ===" > "$OUTPUT_FILE"
echo "Hostname: $(hostname)" >> "$OUTPUT_FILE"
echo "Date: $(date)" >> "$OUTPUT_FILE"
echo "OS: $(uname -a)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "=== System Information ===" >> "$OUTPUT_FILE"
if command -v lsb_release &> /dev/null; then
    lsb_release -a >> "$OUTPUT_FILE" 2>&1
else
    echo "lsb_release not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Distro Information ===" >> "$OUTPUT_FILE"
if [ -f /etc/os-release ]; then
    cat /etc/os-release >> "$OUTPUT_FILE" 2>&1
elif [ -f /etc/lsb-release ]; then
    cat /etc/lsb-release >> "$OUTPUT_FILE" 2>&1
else
    echo "Distro info not found" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Desktop Environment ===" >> "$OUTPUT_FILE"
echo "DESKTOP_SESSION: ${DESKTOP_SESSION:-'Not set'}" >> "$OUTPUT_FILE"
echo "XDG_CURRENT_DESKTOP: ${XDG_CURRENT_DESKTOP:-'Not set'}" >> "$OUTPUT_FILE"
echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-'Not set'}" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "=== Complete Hardware Overview ===" >> "$OUTPUT_FILE"
if command -v lshw &> /dev/null; then
    sudo lshw -short 2>> "$OUTPUT_FILE" >> "$OUTPUT_FILE"
else
    echo "lshw not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Detailed Motherboard Info ===" >> "$OUTPUT_FILE"
# NOTE: dmidecode output contains sensitive serial numbers and identifiers
# This information should not be shared publicly or in bug reports
echo "⚠️  SECURITY NOTE: dmidecode output contains sensitive hardware identifiers" >> "$OUTPUT_FILE"
echo "This information is for personal diagnostics only - DO NOT share publicly" >> "$OUTPUT_FILE"
if command -v dmidecode &> /dev/null; then
    echo "To view DMI data locally, run: sudo dmidecode" >> "$OUTPUT_FILE"
    echo "But do NOT include this in bug reports or public discussions" >> "$OUTPUT_FILE"
else
    echo "dmidecode not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== All PCI Devices ===" >> "$OUTPUT_FILE"
lspci >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== PCI Graphics Devices ===" >> "$OUTPUT_FILE"
lspci | grep -i -E "(vga|3d|display)" >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Detailed PCI Graphics Info ===" >> "$OUTPUT_FILE"
lspci -v | grep -A 12 -i -E "(vga|3d|display)" >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== USB Devices ===" >> "$OUTPUT_FILE"
lsusb >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== System Hardware Display Info ===" >> "$OUTPUT_FILE"
if command -v lshw &> /dev/null; then
    sudo lshw -C display 2>> "$OUTPUT_FILE" >> "$OUTPUT_FILE"
else
    echo "lshw not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Graphics Drivers/Modules ===" >> "$OUTPUT_FILE"
lsmod | grep -i -E "(nvidia|amdgpu|i915|radeon|nouveau)" >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== OpenGL Information ===" >> "$OUTPUT_FILE"
if command -v glxinfo &> /dev/null; then
    glxinfo | grep -E "(OpenGL renderer|OpenGL version|OpenGL vendor)" >> "$OUTPUT_FILE" 2>&1
else
    echo "glxinfo not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== NVIDIA GPU Info (if applicable) ===" >> "$OUTPUT_FILE"
if command -v nvidia-smi &> /dev/null; then
    nvidia-smi >> "$OUTPUT_FILE" 2>&1
else
    echo "nvidia-smi not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Intel GPU Info (if applicable) ===" >> "$OUTPUT_FILE"
if command -v intel_gpu_top &> /dev/null; then
    timeout 2 intel_gpu_top >> "$OUTPUT_FILE" 2>&1 || echo "intel_gpu_top timed out" >> "$OUTPUT_FILE"
else
    echo "intel_gpu_top not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== X11/Xorg Display Info ===" >> "$OUTPUT_FILE"
if [ -n "${DISPLAY:-}" ]; then
    xdpyinfo >> "$OUTPUT_FILE" 2>&1
    echo "" >> "$OUTPUT_FILE"
    xrandr >> "$OUTPUT_FILE" 2>&1
else
    echo "No DISPLAY variable set" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Wayland Info (if applicable) ===" >> "$OUTPUT_FILE"
if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    loginctl show-session $(loginctl | grep $(whoami) | head -n1 | awk '{print $1}') -p Type >> "$OUTPUT_FILE" 2>&1
else
    echo "Not running Wayland" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Memory Information ===" >> "$OUTPUT_FILE"
free -h >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== CPU Information ===" >> "$OUTPUT_FILE"
lscpu >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Kernel Version ===" >> "$OUTPUT_FILE"
uname -r >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Available Disk Space ===" >> "$OUTPUT_FILE"
df -h >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Disk Information ===" >> "$OUTPUT_FILE"
# NOTE: Removed SERIAL column to avoid exposing disk serial numbers
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,MODEL >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== SMART Disk Health ===" >> "$OUTPUT_FILE"
# NOTE: SMART data contains sensitive disk serial numbers and identifiers
# This information should not be shared publicly or in bug reports
echo "⚠️  SECURITY NOTE: SMART data contains sensitive disk identifiers" >> "$OUTPUT_FILE"
echo "This information is for personal diagnostics only - DO NOT share publicly" >> "$OUTPUT_FILE"
if command -v smartctl &> /dev/null; then
    echo "To view SMART data locally, run: sudo smartctl -i /dev/sdX" >> "$OUTPUT_FILE"
    echo "But do NOT include this in bug reports or public discussions" >> "$OUTPUT_FILE"
else
    echo "smartctl not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Network Interfaces ===" >> "$OUTPUT_FILE"
ip addr show >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Network Hardware ===" >> "$OUTPUT_FILE"
lspci | grep -i -E "(network|ethernet|wifi)" >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Audio Hardware ===" >> "$OUTPUT_FILE"
lspci | grep -i -E "(audio|sound)" >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Installed Packages (Development Tools) ===" >> "$OUTPUT_FILE"
if command -v dpkg &> /dev/null; then
    dpkg -l | grep -i -E "(python|node|java|gcc|g\+\+|git|docker|make|cmake|build-essential|development)" | head -50 >> "$OUTPUT_FILE" 2>&1
elif command -v rpm &> /dev/null; then
    rpm -qa | grep -i -E "(python|node|java|gcc|g\+\+|git|docker|make|cmake|development)" | head -50 >> "$OUTPUT_FILE" 2>&1
else
    echo "Package manager not detected" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Graphics-related Packages ===" >> "$OUTPUT_FILE"
if command -v dpkg &> /dev/null; then
    dpkg -l | grep -i -E "(nvidia|amd|mesa|vulkan|opengl|x11|wayland)" >> "$OUTPUT_FILE" 2>&1
elif command -v rpm &> /dev/null; then
    rpm -qa | grep -i -E "(nvidia|amd|mesa|vulkan|opengl|x11|wayland)" >> "$OUTPUT_FILE" 2>&1
else
    echo "Package manager not detected" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== Vulkan Support ===" >> "$OUTPUT_FILE"
if command -v vulkaninfo &> /dev/null; then
    vulkaninfo --summary >> "$OUTPUT_FILE" 2>&1
else
    echo "vulkaninfo not available" >> "$OUTPUT_FILE"
fi
echo "" >> "$OUTPUT_FILE"

echo "=== DRI/Render Nodes ===" >> "$OUTPUT_FILE"
ls -la /dev/dri/ >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== System Services Status ===" >> "$OUTPUT_FILE"
systemctl list-units --type=service --state=running | head -20 >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Available Shells ===" >> "$OUTPUT_FILE"
cat /etc/shells >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Environment Variables ===" >> "$OUTPUT_FILE"
printenv | head -30 >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

echo "=== Hardware/OS Dump Complete ===" >> "$OUTPUT_FILE"

echo "Hardware/OS dump saved to: $OUTPUT_FILE"
echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"
echo ""
echo "To provide this for analysis:"
echo "1. Copy the file contents"
echo "2. Or upload the file: $OUTPUT_FILE"
