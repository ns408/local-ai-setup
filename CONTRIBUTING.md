# Contributing to Local AI Setup

Thanks for your interest in improving local AI deployment for older hardware!

## How to Contribute

### Reporting Issues

Found a bug or have a suggestion? Open an issue with:

- **Hardware specs** - CPU, RAM, OS version
- **Model being used** - Which model and quantization
- **Expected behavior** - What should happen
- **Actual behavior** - What actually happens
- **Error messages** - Full error output if applicable

### Adding New Models

To add support for a new model:

1. Test on both target laptops (or similar hardware)
2. Create a launcher script in `scripts/run-[model].sh`
3. Update the model table in `README.md`
4. Document performance characteristics
5. Submit a pull request

### Improving Scripts

When modifying scripts:

- **Test on both XPS and ASUS** - Or document which hardware you tested
- **Keep it simple** - These are meant for older hardware
- **Add comments** - Explain non-obvious choices
- **Follow existing style** - Match the current script format

### Documentation

Documentation improvements are always welcome:

- Fix typos or unclear instructions
- Add troubleshooting tips
- Improve hardware compatibility notes
- Add performance optimization tips

## Development Setup

```bash
# Clone the repo
git clone https://github.com/[username]/local-ai-setup.git
cd local-ai-setup

# Test the install script
./scripts/install.sh

# Test model launchers
cd ~/llama/scripts
./run-phi3.sh
```

## Code Style

- **Shell scripts:** Use bash, follow existing style
- **Comments:** Explain why, not what
- **Error handling:** Check for common failure cases
- **Portability:** Test on different systems when possible

## Testing

Before submitting:

1. **Test installation** - Run `install.sh` on clean system
2. **Test model launch** - Verify models start correctly
3. **Test benchmarks** - Run `benchmark.sh` if applicable
4. **Check documentation** - Ensure README is accurate

## Pull Request Process

1. **Fork the repository**
2. **Create a feature branch** - `git checkout -b feature/your-feature`
3. **Make your changes** - Follow the guidelines above
4. **Test thoroughly** - On target hardware if possible
5. **Update documentation** - README, comments, etc.
6. **Submit PR** - With clear description of changes

## Hardware Testing

Target hardware for testing:

- **Dell XPS L412Z** - Intel i5-2430M, 12GB RAM
- **ASUS U36JC** - Intel i5-480M, 8GB RAM
- **Similar hardware** - 2nd gen Intel, 8-12GB RAM

If you don't have access to these exact models, test on similar hardware and document your specs.

## Questions?

Open an issue with the "question" label, or reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
