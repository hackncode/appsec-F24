#!/bin/bash

# Run tests on valid gift cards (expected return value: 0)
echo "Running tests on valid gift cards (expected return value: 0)..."
for f in testcases/valid/*.gft; do
    ./giftcardreader.original 1 "$f"
    if [ $? -ne 0 ]; then
        echo "Test failed on valid gift card: $f"
        exit 1
    else
        echo "Test passed on valid gift card: $f"
    fi
done

# Run tests on invalid gift cards (expected return value: nonzero)
echo "Running tests on invalid gift cards (expected return value: nonzero)..."
for f in testcases/invalid/*.gft; do
    ./giftcardreader.original 1 "$f"
    if [ $? -eq 0 ]; then
        echo "Test failed on invalid gift card: $f"
        exit 1
    else
        echo "Test passed on invalid gift card: $f"
    fi
done

# Run crash test cases
echo "Running crash test cases..."
for f in testcases/invalid/crash*.gft; do
    ./giftcardreader.asan "$f"
    if [ $? -eq 0 ]; then
        echo "Crash test failed to crash as expected: $f"
        exit 1
    else
        echo "Crash test passed: $f"
    fi
done

# Run hang test case with timeout
echo "Running hang test case..."
timeout 10 ./giftcardreader.original testcases/invalid/hang.gft
if [ $? -eq 124 ]; then
    echo "Hang test detected and terminated successfully"
else
    echo "Hang test failed: hang.gft"
    exit 1
fi

# Summary
echo "All tests passed."