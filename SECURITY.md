# Security

## Security Audit Status

This project has been audited for security issues before public release. All sensitive data collection has been removed.

## What We Fixed

The `hardware_os_analyzer.sh` script previously collected system identifiers that could be used to track individual machines:

- ❌ **Removed:** Disk serial numbers via `lsblk -o SERIAL`
- ❌ **Removed:** System identifiers via `dmidecode`
- ❌ **Removed:** SMART data via `smartctl`

The script now only collects non-identifying hardware information (CPU model, RAM size, disk capacity) needed for AI model recommendations.

## What We Collect

The hardware analyzer collects only:
- ✅ CPU model and core count (e.g., "Intel Core i5-2430M")
- ✅ Total RAM size (e.g., "12GB")
- ✅ Disk capacity (e.g., "500GB")
- ✅ Operating system version

**No serial numbers, MAC addresses, or unique identifiers are collected.**

## Security Best Practices

When using this project:

1. **Review scripts before running** - All scripts are in `scripts/` directory
2. **Check .gitignore** - Prevents committing sensitive files
3. **Model files** - Downloaded models stay local, never uploaded
4. **No telemetry** - This project doesn't send data anywhere

## Advanced Security Scanning

For comprehensive security scanning of your projects, see:
[project-security-scanner](https://github.com/[username]/project-security-scanner)

This optional tool can scan any project for:
- Hardware identifiers and serial numbers
- Credentials and API keys
- Dangerous shell commands
- Git history issues

## Reporting Security Issues

If you discover a security issue in this project, please:

1. **Do not** open a public issue
2. Email: [your-email@example.com]
3. Include: Description, steps to reproduce, potential impact

We'll respond within 48 hours and work on a fix.

## Security Checklist

- ✅ No hardware serial numbers collected
- ✅ No credentials in code
- ✅ .gitignore configured properly
- ✅ Safe diagnostic commands only
- ✅ No network telemetry
- ✅ Models stay local
- ✅ Scripts reviewed for safety
