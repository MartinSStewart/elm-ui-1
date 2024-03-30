
#!/bin/bash

cd tests-rendering

# elm make visual/Text.elm --output=public/text.html


# Define the root directory for searching .elm files
root_dir="visual"

# Loop through all .elm files found in the directory and its subdirectories
find "$root_dir" -type f -name "*.elm" | while read file; do
    # Extract the file name, convert it to lowercase
    filename=$(basename "$file" .elm)
    lowercase_filename=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    # Construct the output file path
    output_file="public/${lowercase_filename}.html"

    # Ensure the output directory exists
    mkdir -p $(dirname "$output_file")

    # Run the elm make command
    elm make "$file" --output="$output_file"

    echo "Processed $file -> $output_file"
done