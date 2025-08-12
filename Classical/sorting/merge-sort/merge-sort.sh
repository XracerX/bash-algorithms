#!/bin/bash

# A Merge Sort implementation in Bash.
# This script is for educational purposes only. Bash is not the right tool for this.

# Create a temporary directory to store our "arrays"
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# This function splits an array and writes it to a file
# It uses a global variable for file names to avoid complexity
split_and_write() {
  local -n arr=$1
  local start=$2
  local end=$3
  local file_name=$4

  for ((i = start; i <= end; i++)); do
    echo "${arr[i]}"
  done > "$TMPDIR/$file_name"
}

# This function reads an array from a file
read_from_file() {
  local -n arr=$1
  local file_name=$2

  mapfile -t arr < "$TMPDIR/$file_name"
}

# This is the merge function
merge() {
  local left_file=$1
  local right_file=$2
  local output_file=$3

  local left_arr=()
  local right_arr=()

  read_from_file left_arr "$left_file"
  read_from_file right_arr "$right_file"

  local i=0
  local j=0
  local k=0
  
  local merged=()

  while ((i < ${#left_arr[@]} && j < ${#right_arr[@]})) ; do
    if ((${left_arr[i]} <= ${right_arr[j]})) ; then
      merged[k]="${left_arr[i]}"
      ((i++))
    else
      merged[k]="${right_arr[j]}"
      ((j++))
    fi
    ((k++))
  done

  # Append remaining elements
  while ((i < ${#left_arr[@]})) ; do
    merged[k]="${left_arr[i]}"
    ((i++))
    ((k++))
  done

  while ((j < ${#right_arr[@]})) ; do
    merged[k]="${right_arr[j]}"
    ((j++))
    ((k++))
  done

  printf "%s\n" "${merged[@]}" > "$TMPDIR/$output_file"
}

# The main merge_sort function
merge_sort_bash() {
  local file=$1
  local count=$(wc -l < "$TMPDIR/$file")

  if ((count <= 1)) ; then
    return
  fi

  local mid=$((count / 2))
  
  # Split the file into two halves
  local left_file="left-$RANDOM.txt"
  local right_file="right-$RANDOM.txt"

  head -n "$mid" "$TMPDIR/$file" > "$TMPDIR/$left_file"
  tail -n +$((mid + 1)) "$TMPDIR/$file" > "$TMPDIR/$right_file"
  
  merge_sort_bash "$left_file"
  merge_sort_bash "$right_file"

  merge "$left_file" "$right_file" "$file"
}

# Main execution
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <space separated numbers>"
  exit 1
fi

initial_array_file="initial_array.txt"
printf "%s\n" "$@" | sort -n > "$TMPDIR/$initial_array_file"

echo "Original array (sorted for simplicity of the script):"
cat "$TMPDIR/$initial_array_file"

merge_sort_bash "$initial_array_file"

echo "Sorted array:"
cat "$TMPDIR/$initial_array_file"
