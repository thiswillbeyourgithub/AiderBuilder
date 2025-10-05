#!/usr/bin/zsh

VERSION="3.0.0"

# Built-in builder rules
BUILDER_RULES='If you see this text, you are expected to work in builder mode. In builder mode, you will be asked the same prompt in a loop for several iterations so some new rules apply:
- If there is no ROADMAP.md file at the root of the repo, you must create it.
- ROADMAP.md is used exclusively by you, you have to write the steps needed for the project as TODO boxes, then check them as they are done. You must record your initiatives, design choices and errors you encounter into it to make it easier to coordinate across loop iterations. Military style communication is effective for this.
- ROADMAP.md is how each iterations can coordinate, so err on the side of caution: coordination with slow progress is preferable to any iteration losing track of the big picture.
- Do not start the actual building until you are certain ROADMAP.md is ready.
- Don'\''t lose track of the user'\''s request.
- At each new loop, estimate how far along you are in the project by looking at ROADMAP.md
- When building, never do more than one step at a time. Instead, either do one step while carefully editing ROADMAP.md, or split the next ROADMAP.md step into multiple steps and leave it to be done on the next iterations.
- If the project and ROADMAP.md are finished, create a file "FINISHED.md" then ask the user what to do.'

# Function to show usage
show_help() {
    cat << EOF
Usage: aider_builder.sh -n_iter N [--extra_rules RULES_STRING] [AIDER_ARGS...]

Run aider in a loop with builder rules.

Required arguments:
  -n_iter N                Number of iterations per batch (must be > 1)

Optional arguments:
  --extra_rules RULES      Additional rules to append to built-in builder rules
  -h, --help              Show this help message and exit
  -v, --version           Show version and exit
  
  AIDER_ARGS...           Additional arguments to pass to aider

EOF
    exit 0
}

# Parse arguments
n_iter=""
extra_rules=""
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
        --extra_rules)
            if [[ -z "$2" ]]; then
                echo "Error: --extra_rules requires a string as argument"
                exit 1
            fi
            extra_rules=$2
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

# Combine builder rules with extra rules if provided
combined_rules="$BUILDER_RULES"
if [[ -n "$extra_rules" ]]; then
    combined_rules="$combined_rules

$extra_rules"
fi

# Create temporary file for rules
rules_tmp_file=$(mktemp)
trap "rm -f $rules_tmp_file" EXIT
echo "$combined_rules" > "$rules_tmp_file"

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

        aider --read "$rules_tmp_file" "${aider_args[@]}"
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

