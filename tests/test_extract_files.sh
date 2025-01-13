#!/bin/bash

# Setup test environment
setup() {
    TEST_DIR=$(mktemp -d)
    mkdir -p "$TEST_DIR/src"
    echo "print('hello world')" > "$TEST_DIR/src/test.py"
    echo "public class Test {}" > "$TEST_DIR/src/test.java"
    echo "key: value" > "$TEST_DIR/src/config.yaml"
}

# Clean up test environment
cleanup() {
    rm -rf "$TEST_DIR"
}

# Test extension extraction
test_extension_extraction() {
    ../bin/extract-files "$TEST_DIR/src" -e py -o "$TEST_DIR/out"
    [ -f "$TEST_DIR/out/test.py" ] || exit 1
    [ ! -f "$TEST_DIR/out/test.java" ] || exit 1
}

# Run tests
setup
test_extension_extraction
cleanup
echo "All tests passed!"