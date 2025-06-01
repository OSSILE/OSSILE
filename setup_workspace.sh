#!/bin/bash

# Set up VsCode config directory
VSCODE_DIR="./.vscode"

# Projects build list
BUILD_LIST_FILE="./main/buildlist.txt"

# Capture the current working directory
CURRENT_DIR=$(pwd)

# Print current working directory for confirmation
echo "Current directory: $CURRENT_DIR"

# Check if buildlist.txt exists
if [ ! -f "$BUILD_LIST_FILE" ]; then
    echo "Error: $BUILD_LIST_FILE not found in the current directory."
    exit 1
fi

# Create the VSCODE_DIR directory if it doesn't exist
mkdir -p "$VSCODE_DIR"

# Start creating the OSSILE.code-workspace file
cat << EOF > "$VSCODE_DIR/OSSILE.code-workspace"
{
    "folders": [
EOF

# Read each line from buildlist.txt and append to the folders array
first_entry=true
while IFS= read -r dirname; do
    # Skip empty lines
    [ -z "$dirname" ] && continue
    # Add comma before subsequent entries
    if [ "$first_entry" = false ]; then
        echo "," >> "$VSCODE_DIR/OSSILE.code-workspace"
    fi
    # Add folder entry
    cat << EOF >> "$VSCODE_DIR/OSSILE.code-workspace"
        {
            "name": "$dirname",
            "path": "$CURRENT_DIR/main/$dirname"
        }
EOF
    first_entry=false
done < "$BUILD_LIST_FILE"

# Add sql_example and code_example entries
if [ "$first_entry" = false ]; then
    echo "," >> "$VSCODE_DIR/OSSILE.code-workspace"
fi
cat << EOF >> "$VSCODE_DIR/OSSILE.code-workspace"
        {
            "name": "sql_examples",
            "path": "$CURRENT_DIR/sql_examples"
        },
        {
            "name": "code_examples",
            "path": "$CURRENT_DIR/code_examples"
        }
EOF

# Close the folders array and add settings
cat << EOF >> "$VSCODE_DIR/OSSILE.code-workspace"
    ],
    "settings": {
        "IBM i Project Explorer.projectScanDepth": 2
    }
}
EOF

echo "OSSILE.code-workspace file has been generated in $VSCODE_DIR directory with paths from $BUILD_LIST_FILE"