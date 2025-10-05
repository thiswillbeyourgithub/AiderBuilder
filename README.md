# AiderBuilder

A shell script wrapper for running [aider.chat](https://github.com/Aider-AI/aider) in iterative "builder mode" to coordinate multi-step development tasks.

This project was developed with assistance from [aider.chat](https://github.com/Aider-AI/aider/).

## Overview

AiderBuilder automates the process of running aider in a loop with special builder rules that enable coordinated, multi-step development work. The builder mode uses a `ROADMAP.md` file to track progress across iterations, allowing complex projects to be built incrementally with clear coordination between iterations.

## Features

- **Iterative Building**: Run aider multiple times in batches with automatic coordination
- **Progress Tracking**: Uses `ROADMAP.md` to maintain state and coordinate across iterations
- **Completion Detection**: Automatically stops when `FINISHED.md` is created
- **Interactive Batching**: Prompts user to continue after each batch of iterations
- **Safety Checks**: Validates inputs and prevents conflicts with existing builds

## Requirements

- `zsh` shell
- [aider](https://github.com/Aider-AI/aider) installed and accessible in PATH

## Installation

1. Clone or download this repository
2. Make the script executable:
   ```bash
   chmod +x aider_builder.sh
   ```

## Usage

### Basic Command Structure

```bash
./aider_builder.sh -n_iter N --rules RULES_FILE [AIDER_ARGS...]
```

### Required Arguments

- `-n_iter N`: Number of iterations to run per batch (must be > 1)
- `--rules RULES_FILE`: Path to the builder rules file (typically `BUILDER_RULES.md`)

### Optional Arguments

- `-h, --help`: Show help message and exit
- `-v, --version`: Show version and exit
- `AIDER_ARGS...`: Any additional arguments to pass through to aider

### Example Usage

```bash
# Run 5 iterations per batch with the builder rules
./aider_builder.sh -n_iter 5 --rules BUILDER_RULES.md

# Run with specific aider model and additional files
./aider_builder.sh -n_iter 3 --rules BUILDER_RULES.md --model gpt-4 --read docs/

# Run with architect mode enabled
./aider_builder.sh -n_iter 10 --rules BUILDER_RULES.md --architect
```

## How Builder Mode Works

1. **Initialization**: The script checks that no `FINISHED.md` exists from a previous build
2. **Rule Loading**: Builder rules from `BUILDER_RULES.md` are loaded into aider via `--read`
3. **Iteration Loop**: Aider runs `n_iter` times, with each iteration:
   - Reading and updating `ROADMAP.md` to coordinate work
   - Performing one step of the development task
   - Recording progress, decisions, and issues in `ROADMAP.md`
4. **Batch Completion**: After each batch, the user is prompted to continue or stop
5. **Completion**: When aider creates `FINISHED.md`, the script automatically exits

## Builder Rules

The `BUILDER_RULES.md` file instructs aider to:
- Create and maintain a `ROADMAP.md` file for coordination
- Work incrementally, one step at a time
- Record design decisions and errors for future iterations
- Check progress at each iteration
- Create `FINISHED.md` when the project is complete

This approach enables complex, multi-step development tasks to be handled systematically.

## Files

- `aider_builder.sh`: Main shell script (version 2.0.0)
- `BUILDER_RULES.md`: Rules that define builder mode behavior for aider
- `ROADMAP.md`: Created and maintained by aider during builds (tracks progress)
- `FINISHED.md`: Created by aider when the build is complete (signals completion)

## Error Handling

The script validates:
- Required arguments are provided
- `n_iter` is greater than 1
- Rules file exists and is not empty
- No `FINISHED.md` exists before starting (prevents conflicts with previous builds)

## Version

Current version: 2.0.0

## License

[Add your license here]
