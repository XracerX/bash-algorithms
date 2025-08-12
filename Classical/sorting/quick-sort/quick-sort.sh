#!/bin/bash

# Quick Sort implementation in Bash
# WARNING: This script is for educational purposes only.
# It is extremely inefficient and not suitable for practical use.

# The array to be sorted, passed in from command line arguments
declare -a data=("$@")

# Swaps two elements in the array
swap() {
  local temp=${data[$1]}
  data[$1]=${data[$2]}
  data[$2]=$temp
}

# The partition function
partition() {
  local low=$1
  local high=$2
  local pivot_val=${data[$high]}
  local i=$((low - 1))
  local j
  
  for ((j=low; j<high; j++)); do
    if ((data[j] <= pivot_val)); then
      ((i++))
      swap i j
    fi
  done
  
  swap $((i + 1)) high
  echo $((i + 1))
}

# The main Quick Sort function
quicksort() {
  local low=$1
  local high=$2

  if ((low < high)); then
    local pivot_index=$(partition $low $high)
    quicksort $low $((pivot_index - 1))
    quicksort $((pivot_index + 1)) $high
  fi
}

# Check for input
if [[ ${#data[@]} -eq 0 ]]; then
  echo "Usage: $0 <space separated numbers>"
  exit 1
fi

echo "Original array: ${data[@]}"

# Start the sorting process
quicksort 0 $(( ${#data[@]} - 1 ))

echo "Sorted array:   ${data[@]}"
