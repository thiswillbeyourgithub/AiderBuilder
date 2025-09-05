#!/usr/bin/zsh

# Configuration
#n=${1:-5}  # Default to 5 iterations if no argument provided
n=5

counter=0
total_iterations=0

while true; do
    # Run loop n times
    for ((i=1; i<=n; i++)); do
        counter=$((counter + 1))
        total_iterations=$((total_iterations + 1))

        echo "\n###################"
        echo "# AiderBuilder iteration #$total_iterations ($(date))"
        echo "###################"

        aider --read "$GIT_REPOSITORIES/AiderBuilder/BUILDER.md" $@
    done

    # Ask user to continue
    echo "\nCompleted $n iterations (total: $total_iterations)"
    read "response?Continue for another $n iterations? (y/N): "

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

