#!/bin/bash

# Guard against recursive execution
if [ "${RUNNING_TESTS:-}" = "1" ]; then
    exit 0
fi
export RUNNING_TESTS=1

# Global variables
TEST_DIR=""
SCRIPT_PATH="./bin/extract-files"

# Error handling
set -e

# Setup test environment
setup() {
    TEST_DIR=$(mktemp -d)
    mkdir -p "$TEST_DIR/src/subdir"
    
    # Create test files
    echo "print('hello world')" > "$TEST_DIR/src/test.py"
    echo "public class Test {}" > "$TEST_DIR/src/test.java"
    echo "key: value" > "$TEST_DIR/src/config.yaml"
    echo "print('another')" > "$TEST_DIR/src/another.py"
    echo "test" > "$TEST_DIR/src/skip.txt"
    echo "nested" > "$TEST_DIR/src/subdir/nested.py"
}

# Clean up test environment
cleanup() {
    if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
        rm -rf "$TEST_DIR"
    fi
}

# Helper function to clean output directory
clean_output() {
    if [ -d "$TEST_DIR/out" ]; then
        rm -rf "$TEST_DIR/out"
    fi
}

# Test runner function
run_test() {
    local test_name="$1"
    local test_func="$2"
    
    echo "Running test: $test_name..."
    if $test_func; then
        echo "✓ $test_name passed"
        clean_output
        return 0
    else
        echo "✗ $test_name failed"
        clean_output
        return 1
    fi
}

# Test single extension extraction
test_single_extension_extraction() {
    local temp_output
    temp_output=$($SCRIPT_PATH "$TEST_DIR/src" -e py -o "$TEST_DIR/out")
    [ -f "$TEST_DIR/out/test.py" ] && \
    [ -f "$TEST_DIR/out/another.py" ] && \
    [ ! -f "$TEST_DIR/out/test.java" ]
}

# Test multiple extension extraction
test_multiple_extension_extraction() {
    local temp_output
    temp_output=$($SCRIPT_PATH "$TEST_DIR/src" -e py java -o "$TEST_DIR/out")
    [ -f "$TEST_DIR/out/test.py" ] && \
    [ -f "$TEST_DIR/out/test.java" ] && \
    [ ! -f "$TEST_DIR/out/config.yaml" ]
}

# Test file exclusion
test_file_exclusion() {
    local temp_output
    temp_output=$($SCRIPT_PATH "$TEST_DIR/src" -e py -x "another.py" -o "$TEST_DIR/out")
    [ -f "$TEST_DIR/out/test.py" ] && \
    [ ! -f "$TEST_DIR/out/another.py" ]
}

# Test directory exclusion
test_directory_exclusion() {
    local temp_output
    temp_output=$($SCRIPT_PATH "$TEST_DIR/src" -e py -X "subdir" -o "$TEST_DIR/out")
    [ -f "$TEST_DIR/out/test.py" ] && \
    [ ! -f "$TEST_DIR/out/subdir/nested.py" ]
}

# Test specific filename extraction
test_specific_filename() {
    local temp_output
    temp_output=$($SCRIPT_PATH "$TEST_DIR/src" -f "test.py" -o "$TEST_DIR/out")
    [ -f "$TEST_DIR/out/test.py" ] && \
    [ ! -f "$TEST_DIR/out/another.py" ]
}

# Test help flag
test_help_flag() {
    local temp_output
    temp_output=$($SCRIPT_PATH --help)
    echo "$temp_output" | grep -q "Usage:"
}

# Test invalid option
test_invalid_option() {
    ! $SCRIPT_PATH "$TEST_DIR/src" -z 2>/dev/null
}

# Test no conditions error
test_no_conditions() {
    ! $SCRIPT_PATH "$TEST_DIR/src" -o "$TEST_DIR/out" 2>/dev/null
}

# Test debug output
test_debug_output() {
    local temp_output
    temp_output=$($SCRIPT_PATH "$TEST_DIR/src" -e py -o "$TEST_DIR/out")
    echo "$temp_output" | grep -q "Files extracted to:" && \
    echo "$temp_output" | grep -q " -> "
}

# Set up trap for cleanup after everything is defined
trap cleanup EXIT

# Main test execution
echo "Starting tests..."
setup

failed=0
tests=(
    "single_extension_extraction"
    "multiple_extension_extraction"
    "file_exclusion"
    "directory_exclusion"
    "specific_filename"
    "help_flag"
    "invalid_option"
    "no_conditions"
    "debug_output"
)

for test in "${tests[@]}"; do
    if ! run_test "$test" "test_$test"; then
        ((failed++))
    fi
done

echo "Test summary: $((${#tests[@]} - failed))/${#tests[@]} tests passed"
exit $failed