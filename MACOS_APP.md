# macOS Financial Calculator Application

## Overview

The `MacOSApp/` directory contains a complete native macOS application for financial calculations using QuantLib. This graphical application provides an intuitive interface for pricing options, bonds, and other financial instruments.

## Features

✓ **Option Pricing Calculator**
  - European and American options
  - Call and Put options
  - Black-Scholes and Finite Difference pricing engines
  - Complete Greeks calculation (Delta, Gamma, Vega, Theta, Rho)

✓ **Bond Calculator**
  - Bond price calculation from yield
  - Bond yield calculation from price
  - Multiple payment frequencies (Annual, Semiannual, Quarterly)

✓ **Native macOS Interface**
  - Built with SwiftUI
  - Clean, modern design
  - Real-time validation and error handling

## Quick Start

### Prerequisites

- macOS 10.15 or later
- Xcode 12.0 or later
- QuantLib library (install via Homebrew: `brew install quantlib`)

### Build and Run

```bash
cd MacOSApp
./build.sh
cd build
open QuantLibCalculator.app
```

For detailed instructions, see [MacOSApp/README.md](MacOSApp/README.md) and [MacOSApp/QUICKSTART.md](MacOSApp/QUICKSTART.md).

## Documentation

- **[README.md](MacOSApp/README.md)** - Complete documentation and features
- **[QUICKSTART.md](MacOSApp/QUICKSTART.md)** - Quick start guide with examples
- **[XCODE_BUILD.md](MacOSApp/XCODE_BUILD.md)** - Xcode build instructions
- **[EXAMPLES.md](MacOSApp/EXAMPLES.md)** - Sample calculations and expected results
- **[TECHNICAL_OVERVIEW.md](MacOSApp/TECHNICAL_OVERVIEW.md)** - Technical architecture and design

## Screenshots

The application provides a clean, tab-based interface:

- **Options Tab**: Calculate option prices and Greeks
- **Bonds Tab**: Calculate bond prices and yields
- **About Tab**: Information about the application

## Architecture

The app uses a multi-layer architecture:

1. **Swift UI Layer** - Native macOS interface using SwiftUI
2. **Swift Wrapper** - Type-safe Swift interface to C++ code
3. **Objective-C++ Bridge** - Bridge between Swift and C++
4. **C++ Calculation Engine** - QuantLib integration for financial calculations

## Example Usage

### Option Pricing

Calculate a European Call Option:
- Underlying: $100
- Strike: $100
- Rate: 5%
- Volatility: 20%
- Time: 1 year

Result: ~$10.45

### Bond Pricing

Calculate a bond price:
- Face Value: $1000
- Coupon: 5%
- Yield: 6%
- Maturity: 5 years

Result: ~$957.35

## Building

### Using the Build Script

```bash
cd MacOSApp
./build.sh
```

### Using CMake

```bash
cd MacOSApp
mkdir build && cd build
cmake ..
make
```

### Using Xcode

```bash
cd MacOSApp
mkdir build && cd build
cmake -G Xcode ..
open QuantLibCalculator.xcodeproj
```

## License

This application uses QuantLib, which is licensed under a modified BSD license.
See the main LICENSE.TXT file for details.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

For general QuantLib contributions, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Support

For issues specific to the macOS app:
1. Check the documentation in the MacOSApp/ directory
2. Review the examples in EXAMPLES.md
3. Open an issue on GitHub

For general QuantLib questions:
- Mailing list: https://www.quantlib.org/mailinglists.shtml
- GitHub issues: https://github.com/lballabio/QuantLib/issues
