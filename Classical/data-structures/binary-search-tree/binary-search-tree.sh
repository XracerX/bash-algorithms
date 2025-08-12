#!/bin/bash

# A simulated Binary Search Tree in Bash
# WARNING: This script is for educational purposes only.
# It is extremely inefficient and not suitable for practical use.

# Initialize the tree array with null values
# This array will be used to simulate the tree structure.
declare -a tree=()

# The maximum size of our simulated tree
MAX_SIZE=100

# Function to insert a value into the BST
insert() {
  local value=$1
  local index=0

  # Find the correct position for the new value
  while [[ ${tree[$index]+_} ]]; do
    if ((value < tree[index])); then
      index=$((2*index + 1))  # Go to the left child
    elif ((value > tree[index])); then
      index=$((2*index + 2))  # Go to the right child
    else
      echo "Value $value already exists in the tree."
      return
    fi
    
    # Check for overflow
    if ((index >= MAX_SIZE)); then
      echo "Tree is full, cannot insert $value."
      return
    fi
  done
  
  # Insert the value
  tree[$index]=$value
  echo "Inserted $value at index $index."
}

# Function to search for a value in the BST
search() {
  local value=$1
  local index=0

  # Traverse the tree to find the value
  while [[ ${tree[$index]+_} ]]; do
    if ((value == tree[index])); then
      echo "Found $value at index $index."
      return
    elif ((value < tree[index])); then
      index=$((2*index + 1))  # Go to the left child
    else
      index=$((2*index + 2))  # Go to the right child
    fi
  done
  
  echo "Value $value not found."
}

# --- Main Program ---

# Insert some values
insert 50
insert 30
insert 70
insert 20
insert 40
insert 60
insert 80

echo "Tree contents (as an array):"
# Print the array to show the structure
for i in "${!tree[@]}"; do
  echo "Index $i: ${tree[$i]}"
done

echo ""

# Search for some values
search 60
search 99
search 20
