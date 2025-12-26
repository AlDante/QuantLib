# QuantLib Financial Calculator - macOS App

A native macOS application for calculating financial instruments using the QuantLib library.

## Features

- **Option Pricing Calculator**
  - European and American options
  - Call and Put options
  - Calculate option prices using Black-Scholes (European) and Finite Difference (American) methods
  - Compute option Greeks: Delta, Gamma, Vega, Theta, Rho
  
- **Bond Calculator**
  - Calculate bond prices from yield
  - Calculate bond yields from price
  - Support for Annual, Semiannual, and Quarterly payment frequencies
  
- **Implied Volatility Calculator**
  - Calculate implied volatility from option prices

## Requirements

- macOS 10.15 or later
- QuantLib library installed (via Homebrew or built from source)
- Xcode 12.0 or later (for building)
- CMake 3.15 or later (for building)

## Installation

### Installing QuantLib

If you don't have QuantLib installed, you can install it using Homebrew:

```bash
brew install quantlib
```

Or build from source:

```bash
git clone https://github.com/lballabio/QuantLib.git
cd QuantLib
mkdir build && cd build
cmake ..
make
sudo make install
```

### Building the macOS App

1. Navigate to the MacOSApp directory:
   ```bash
   cd MacOSApp
   ```

2. Create a build directory:
   ```bash
   mkdir build && cd build
   ```

3. Configure the build with CMake:
   ```bash
   cmake ..
   ```

4. Build the app:
   ```bash
   make
   ```

5. The app will be created in the build directory as `QuantLibCalculator.app`

### Alternative: Build with Xcode

You can also generate an Xcode project:

```bash
cd MacOSApp
mkdir build && cd build
cmake -G Xcode ..
open QuantLibCalculator.xcodeproj
```

Then build and run from Xcode.

## Usage

### Option Pricing

1. Select the "Options" tab
2. Choose the option type (Call or Put)
3. Choose the exercise type (European or American)
4. Enter the parameters:
   - Underlying Price: Current price of the underlying asset
   - Strike Price: Exercise price of the option
   - Risk-Free Rate: Annual risk-free interest rate (e.g., 0.05 for 5%)
   - Dividend Yield: Annual dividend yield (e.g., 0.02 for 2%)
   - Volatility: Annual volatility (e.g., 0.20 for 20%)
   - Time to Maturity: Time in years (e.g., 1.0 for one year)
5. Click "Calculate" to see the option price and Greeks

### Bond Pricing

1. Select the "Bonds" tab
2. Choose whether to calculate Price or Yield
3. Enter the parameters:
   - Face Value: Par value of the bond (e.g., 1000)
   - Coupon Rate: Annual coupon rate (e.g., 0.05 for 5%)
   - Yield Rate (for price calculation): Market yield (e.g., 0.06 for 6%)
   - Bond Price (for yield calculation): Current market price
   - Time to Maturity: Time in years
   - Payment Frequency: Annual, Semiannual, or Quarterly
4. Click "Calculate" to see the result

## Architecture

The app uses a multi-layer architecture:

1. **Swift UI Layer** (`ContentView.swift`, `AppDelegate.swift`)
   - Native macOS user interface using SwiftUI
   - Handles user input and displays results

2. **Swift Wrapper Layer** (`QuantLibWrapper.swift`)
   - Swift interface to the C++ calculations
   - Error handling and type conversion

3. **C Bridge Layer** (`QuantLibBridge.mm`)
   - Objective-C++ bridge between Swift and C++
   - Converts between Swift/C and C++ types

4. **C++ Calculation Layer** (`QuantLibCalculator.cpp/hpp`)
   - Implements financial calculations using QuantLib
   - Provides clean C++ interface to QuantLib functionality

## Examples

### Example 1: European Call Option
- Option Type: Call
- Exercise Type: European
- Underlying: 100
- Strike: 100
- Risk-Free Rate: 0.05
- Dividend Yield: 0.0
- Volatility: 0.20
- Time to Maturity: 1.0

Expected Price: ~10.45

### Example 2: Bond Valuation
- Face Value: 1000
- Coupon Rate: 0.05
- Yield Rate: 0.06
- Time to Maturity: 5
- Frequency: Semiannual

Expected Price: ~957.35

## Troubleshooting

### Build Issues

If you encounter build errors:

1. Make sure QuantLib is properly installed:
   ```bash
   quantlib-config --version
   ```

2. If using Homebrew installation, you may need to specify the path:
   ```bash
   cmake -DQuantLib_DIR=/usr/local/lib/cmake/QuantLib ..
   ```

3. Make sure you have the latest Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

### Runtime Issues

If the app crashes or produces incorrect results:

1. Check that all input values are positive and reasonable
2. Ensure time to maturity is greater than 0
3. For implied volatility, ensure the option price is within valid bounds

## License

This software uses the QuantLib library, which is licensed under a modified BSD license.
See the QuantLib LICENSE.TXT file for details.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

## Resources

- [QuantLib Website](https://www.quantlib.org)
- [QuantLib Documentation](https://www.quantlib.org/docs.shtml)
- [QuantLib GitHub](https://github.com/lballabio/QuantLib)
