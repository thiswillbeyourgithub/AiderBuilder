# AiderBuilder

A simple, self-contained, zsh script implementing a generalist, recursive, LLM agent using [aider.chat](https://github.com/Aider-AI/aider/).

It was created for situations where I have written extensive specifications for a project and don't want to spend my attention to split the specs into a plan for an LLM.

Examples of successful usage include:
- turning a survey into a full fledged gradio app with specific requirements.
- recording audio for a while then using that transcript as specification to create a PDF using *LaTeX*.

AiderBuilder itself was built with the help of [aider.chat](https://github.com/Aider-AI/aider/).

## What It Does

Runs aider in a loop with builder rules that maintain a `ROADMAP.md` file to coordinate incremental development across iterations. Aider creates `FINISHED.md` when complete.

## Requirements

- `zsh` shell
- [aider](https://github.com/Aider-AI/aider) in PATH

## Installation

```bash
chmod +x aider_builder
```

## Usage

```bash
./aider_builder -n_iter N -s "what to build" [AIDER_ARGS...]
```

### Required Arguments

- `-n_iter N`: Iterations per batch (must be > 1)
- `-s, --specifications SPEC`: What to build (passed as prompt to aider). Can be a direct string or a path to a file containing the specifications.

### Optional Arguments

- `-h, --help`: Show help
- `-v, --version`: Show version
- `AIDER_ARGS...`: Additional aider arguments (don't use `--message`, use `-s` instead)

### Examples

```bash
# Build a CLI tool with inline specification
./aider_builder -n_iter 5 -s "Create a Python CLI calculator using click"

# Build from a specification file
./aider_builder -n_iter 10 -s specs.txt

# With architect mode
./aider_builder -n_iter 10 -s "Build a REST API with FastAPI" --architect
```

## How It Works

1. Checks no `FINISHED.md` exists from previous builds
2. Loads builder rules into aider
3. Runs `n_iter` iterations where aider:
   - Creates/updates `ROADMAP.md` to track progress
   - Performs one development step at a time
   - Records decisions and issues in `ROADMAP.md`
4. Prompts to continue after each batch
5. Stops when aider creates `FINISHED.md`

## Builder Rules

Aider is instructed to:
- Use `ROADMAP.md` for coordination with TODO checkboxes
- Work incrementally, one step at a time
- Record design decisions and errors
- Estimate progress at each iteration
- Create `FINISHED.md` when done
