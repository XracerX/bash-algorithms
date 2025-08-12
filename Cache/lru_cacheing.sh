#!/bin/bash

# This script simulates a simple LRU (Least Recently Used) cache.
# It demonstrates cache hits and misses based on a predefined cache size.

# --- Configuration ---
CACHE_SIZE=3 # Define the maximum number of items the cache can hold
declare -A CACHE_DATA # Associative array to store key-value pairs (data in cache)
declare -a CACHE_ORDER # Indexed array to maintain the order of items (for LRU)

HITS=0   # Counter for cache hits
MISSES=0 # Counter for cache misses

# --- Functions ---

# Function to display the current state of the cache
display_cache() {
    echo "--- Cache State (Size: ${#CACHE_ORDER[@]}/$CACHE_SIZE) ---"
    if [ ${#CACHE_ORDER[@]} -eq 0 ]; then
        echo "Cache is empty."
    else
        echo "Order (MRU to LRU): ${CACHE_ORDER[@]}"
        echo "Contents:"
        for key in "${CACHE_ORDER[@]}"; do
            echo "  $key: ${CACHE_DATA[$key]}"
        done
    fi
    echo "Hits: $HITS, Misses: $MISSES"
    echo "-----------------------------------"
}

# Function to simulate a memory access
# Arguments: $1 = key (data item being requested)
access_memory() {
    local key=$1
    echo "Accessing: '$key'"

    # Check if the item is in the cache (Cache Hit)
    if [[ -n "${CACHE_DATA[$key]}" ]]; then
        HITS=$((HITS + 1))
        echo "  --> Cache Hit!"

        # Update order: move accessed item to the front (Most Recently Used)
        local new_order=()
        new_order+=("$key") # Add the accessed key first
        for item in "${CACHE_ORDER[@]}"; do
            if [[ "$item" != "$key" ]]; then
                new_order+=("$item") # Add other items
            fi
        done
        CACHE_ORDER=("${new_order[@]}")

    # Item not in cache (Cache Miss)
    else
        MISSES=$((MISSES + 1))
        echo "  --> Cache Miss!"

        # Add the new item to the cache
        CACHE_DATA[$key]="data_for_$key" # Simulate fetching data

        # Check if cache is full (Eviction needed)
        if [ ${#CACHE_ORDER[@]} -ge $CACHE_SIZE ]; then
            local lru_item="${CACHE_ORDER[-1]}" # Get the Least Recently Used item (last in array)
            echo "  --> Cache full! Evicting LRU item: '$lru_item'"
            unset CACHE_DATA[$lru_item] # Remove from data storage
            CACHE_ORDER=("${CACHE_ORDER[@]:0:${#CACHE_ORDER[@]}-1}") # Remove from order array
        fi

        # Add new item to the front of the order (Most Recently Used)
        CACHE_ORDER=("$key" "${CACHE_ORDER[@]}")
    fi

    display_cache
    echo "" # Newline for readability
}

# --- Simulation Execution ---

echo "Starting LRU Cache Simulation with size: $CACHE_SIZE"
echo ""

# Simulate a sequence of memory accesses
access_memory "A"
access_memory "B"
access_memory "C"
access_memory "D" # A should be evicted (LRU)
access_memory "B" # Hit
access_memory "E" # C should be evicted (LRU)
access_memory "A" # Miss, D should be evicted (LRU)
access_memory "F"
access_memory "C" # Miss, B should be evicted (LRU)

echo "--- Simulation Complete ---"
echo "Final Cache State:"
display_cache

