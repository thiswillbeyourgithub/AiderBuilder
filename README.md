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
   chmod +x aider_builder
   ```

## Usage

### Basic Command Structure

```bash
./aider_builder -n_iter N [--extra_rules RULES_STRING] [AIDER_ARGS...]
```

### Required Arguments

- `-n_iter N`: Number of iterations to run per batch (must be > 1)

### Optional Arguments

- `--extra_rules RULES`: Additional rules to append to the built-in builder rules
- `-h, --help`: Show help message and exit
- `-v, --version`: Show version and exit
- `AIDER_ARGS...`: Any additional arguments to pass through to aider

### Example Usage

```bash
# Run 5 iterations per batch with default builder rules
./aider_builder -n_iter 5

# Run with specific aider model and additional files
./aider_builder -n_iter 3 --model gpt-4 --read docs/

# Run with architect mode enabled
./aider_builder -n_iter 10 --architect

# Run with additional custom rules
./aider_builder -n_iter 5 --extra_rules "Focus on performance optimization in each step."
```

## How Builder Mode Works

1. **Initialization**: The script checks that no `FINISHED.md` exists from a previous build
2. **Rule Loading**: Built-in builder rules are automatically loaded into aider (with optional `--extra_rules` if provided)
3. **Iteration Loop**: Aider runs `n_iter` times, with each iteration:
   - Creating `ROADMAP.md` if it doesn't exist
   - Reading and updating `ROADMAP.md` to coordinate work
   - Performing one step of the development task
   - Recording progress, decisions, and issues in `ROADMAP.md`
4. **Batch Completion**: After each batch, the user is prompted to continue or stop
5. **Completion**: When aider creates `FINISHED.md`, the script automatically exits

## Builder Rules

The built-in builder rules (embedded in the script) instruct aider to:
- Create and maintain a `ROADMAP.md` file for coordination between iterations
- Work incrementally, one step at a time to avoid losing track of the big picture
- Record design decisions, initiatives, and errors encountered in `ROADMAP.md`
- Estimate progress at each iteration by reviewing `ROADMAP.md`
- Use military-style communication for effective coordination
- Split large steps into smaller substeps when needed
- Create `FINISHED.md` when the project is complete

You can optionally add custom rules using the `--extra_rules` argument to supplement the built-in rules.

This approach enables complex, multi-step development tasks to be handled systematically.

## Files

- `aider_builder`: Main shell script (version 3.0.0)
- `ROADMAP.md`: Created and maintained by aider during builds (tracks progress and coordination)
- `FINISHED.md`: Created by aider when the build is complete (signals completion)

## Error Handling

The script validates:
- Required `-n_iter` argument is provided
- `n_iter` is greater than 1
- No `FINISHED.md` exists before starting (prevents conflicts with previous builds)

## Version

Current version: 3.0.0
