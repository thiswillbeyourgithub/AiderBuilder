#!/usr/bin/zsh

VERSION="2.0.0"

# Function to show usage
show_help() {
    cat << EOF
Usage: aider_builder.sh -n_iter N [--rules RULES_FILE] [AIDER_ARGS...]

Run aider in a loop with builder rules.

Required arguments:
  -n_iter N              Number of iterations per batch (must be > 1)
  --rules RULES_FILE     Path to builder rules file
  -h, --help            Show this help message and exit
  -v, --version         Show version and exit
  
  AIDER_ARGS...         Additional arguments to pass to aider

EOF
    exit 0
}

# Parse arguments
n_iter=""
rules_file=""
aider_args=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        -v|--version)
            echo "aider_builder.sh version $VERSION"
            exit 0
            ;;
        -n_iter)
            if [[ -z "$2" ]] || [[ ! "$2" =~ ^[0-9]+$ ]]; then
                echo "Error: -n_iter requires a number as argument"
                exit 1
            fi
            n_iter=$2
            shift 2
            ;;
        --rules)
            if [[ -z "$2" ]]; then
                echo "Error: --rules requires a file path as argument"
                exit 1
            fi
            rules_file=$2
            shift 2
            ;;
        *)
            aider_args+=("$1")
            shift
            ;;
    esac
done

# Show help if no arguments provided
if [[ -z "$n_iter" ]] && [[ ${#aider_args[@]} -eq 0 ]]; then
    show_help
fi

# Validate n_iter is provided and > 1
if [[ -z "$n_iter" ]]; then
    echo "Error: -n_iter argument is required"
    echo "Use -h or --help for usage information"
    exit 1
fi

if [[ $n_iter -le 1 ]]; then
    echo "Error: -n_iter must be greater than 1"
    exit 1
fi

# Validate rules_file is provided
if [[ -z "$rules_file" ]]; then
    echo "Error: --rules argument is required"
    echo "Use -h or --help for usage information"
    exit 1
fi

# Validate rules_file exists and is a regular file
if [[ ! -f "$rules_file" ]]; then
    if [[ -e "$rules_file" ]]; then
        echo "Error: '$rules_file' exists but is not a regular file"
    else
        echo "Error: Rules file '$rules_file' does not exist"
    fi
    exit 1
fi

# Validate rules_file is not empty
if [[ ! -s "$rules_file" ]]; then
    echo "Error: Rules file '$rules_file' is empty"
    exit 1
fi

# Check if FINISHED.md already exists before starting
if [[ -f "FINISHED.md" ]]; then
    echo "Error: FINISHED.md already exists in the current directory"
    echo "This file indicates a previous build has finished."
    echo "Please remove or rename FINISHED.md before starting a new build session."
    exit 1
fi

counter=0
total_iterations=0

while true; do
    # Run loop n_iter times
    for ((i=1; i<=n_iter; i++)); do
        # Check if build is finished
        if [[ -f "FINISHED.md" ]]; then
            echo "\n###################"
            echo "# Build finished! FINISHED.md detected."
            echo "###################"
            echo "Completed $total_iterations total iterations."
            exit 0
        fi

        counter=$((counter + 1))
        total_iterations=$((total_iterations + 1))

        echo "\n###################"
        echo "# AiderBuilder iteration #$total_iterations ($(date))"
        echo "###################"

        aider --read "$rules_file" "${aider_args[@]}"
    done

    # Ask user to continue
    echo "\nCompleted $n_iter iterations (total: $total_iterations)"
    read "response?Continue for another $n_iter iterations? (y/N): "

    case $response in
        [Yy]* ) 
            echo "Continuing..."
            counter=0
            ;;
        * ) 
            echo "Stopping."
            exit 0
            ;;
    esac
done

