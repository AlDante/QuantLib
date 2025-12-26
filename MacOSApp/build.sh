#!/bin/bash

# Build script for QuantLib Calculator macOS App
# This script builds the macOS application bundle

set -e  # Exit on error

echo "========================================"
echo "QuantLib Calculator macOS App Builder"
echo "========================================"
echo ""

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "Error: This script is for macOS only"
    echo "Current OS: $OSTYPE"
    echo ""
    echo "However, the source files have been created and can be built on macOS."
    exit 1
fi

# Check for required tools
echo "Checking for required tools..."

if ! command -v cmake &> /dev/null; then
    echo "Error: CMake is not installed"
    echo "Install with: brew install cmake"
    exit 1
fi

if ! command -v quantlib-config &> /dev/null; then
    echo "Error: QuantLib is not installed"
    echo "Install with: brew install quantlib"
    echo "Or build from source: https://www.quantlib.org/install.shtml"
    exit 1
fi

echo "✓ CMake found: $(cmake --version | head -n1)"
echo "✓ QuantLib found: version $(quantlib-config --version)"
echo ""

# Clean previous build
if [ -d "build" ]; then
    echo "Cleaning previous build..."
    rm -rf build
fi

# Create build directory
echo "Creating build directory..."
mkdir -p build
cd build

# Configure with CMake
echo "Configuring build with CMake..."
if cmake ..; then
    echo "✓ Configuration successful"
else
    echo "✗ Configuration failed"
    exit 1
fi

# Build the app
echo ""
echo "Building application..."
if make; then
    echo "✓ Build successful"
else
    echo "✗ Build failed"
    exit 1
fi

# Check if app was created
if [ -d "QuantLibCalculator.app" ]; then
    echo ""
    echo "========================================"
    echo "Build completed successfully!"
    echo "========================================"
    echo ""
    echo "The application has been created at:"
    echo "  $(pwd)/QuantLibCalculator.app"
    echo ""
    echo "To run the application:"
    echo "  open QuantLibCalculator.app"
    echo ""
    echo "To install to /Applications:"
    echo "  cp -r QuantLibCalculator.app /Applications/"
    echo ""
else
    echo "Error: Application bundle was not created"
    exit 1
fi
