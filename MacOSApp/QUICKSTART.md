# Quick Start Guide - QuantLib Financial Calculator macOS App

## Overview

This macOS application provides an intuitive graphical interface for financial calculations using the QuantLib library. It's designed for financial professionals, students, and anyone interested in quantitative finance.

## Prerequisites

Before building or running the app, ensure you have:

1. **macOS 10.15 or later**
2. **Xcode 12.0 or later** (from the Mac App Store)
3. **Homebrew** (optional but recommended)
4. **QuantLib library**

## Quick Installation

### Step 1: Install QuantLib

The easiest way is using Homebrew:

```bash
brew install quantlib
```

### Step 2: Build the App

Navigate to the MacOSApp directory and run the build script:

```bash
cd MacOSApp
./build.sh
```

### Step 3: Run the App

After a successful build:

```bash
cd build
open QuantLibCalculator.app
```

Or install to Applications folder:

```bash
cp -r build/QuantLibCalculator.app /Applications/
```

## Using the Application

### Option Calculator Tab

**Calculate a European Call Option:**

1. Click on the "Options" tab
2. Select "Call" for option type
3. Select "European" for exercise type
4. Enter values:
   - Underlying Price: `100`
   - Strike Price: `100`
   - Risk-Free Rate: `0.05` (5%)
   - Dividend Yield: `0.0` (0%)
   - Volatility: `0.20` (20%)
   - Time to Maturity: `1.0` (1 year)
5. Click "Calculate"

**Result:** You'll see the option price and Greeks (Delta, Gamma, Vega, Theta, Rho)

### Bond Calculator Tab

**Calculate Bond Price:**

1. Click on the "Bonds" tab
2. Select "Price" as calculation type
3. Enter values:
   - Face Value: `1000`
   - Coupon Rate: `0.05` (5%)
   - Yield Rate: `0.06` (6%)
   - Time to Maturity: `5.0` (5 years)
   - Payment Frequency: `Semiannual`
4. Click "Calculate"

**Result:** You'll see the bond price

## Features Summary

✓ **Options:**
  - European and American options
  - Call and Put options
  - Black-Scholes pricing
  - Finite difference pricing for American options
  - Full Greeks calculation

✓ **Bonds:**
  - Price calculation from yield
  - Yield calculation from price
  - Multiple payment frequencies

✓ **User Interface:**
  - Clean, native macOS design
  - Real-time calculation
  - Error handling and validation

## Troubleshooting

**Build fails with "quantlib-config not found":**
- Install QuantLib using `brew install quantlib`
- Or build QuantLib from source

**App won't open:**
- Make sure you're running macOS 10.15 or later
- Check Console.app for error messages

**Calculation errors:**
- Verify all input values are positive
- Ensure time to maturity > 0
- Check that volatility is reasonable (typically 0.1 to 0.5)

## Next Steps

- Explore different option strategies
- Compare European vs American option prices
- Analyze bond price sensitivity to yield changes
- Study how Greeks change with different parameters

## Support

For issues or questions:
- Check the full README.md in this directory
- Visit the QuantLib website: https://www.quantlib.org
- GitHub repository: https://github.com/lballabio/QuantLib

## Example Calculations

### Example 1: At-the-money Call Option
```
Type: Call
Exercise: European
Underlying: 100
Strike: 100
Rate: 0.05
Dividend: 0.0
Volatility: 0.20
Maturity: 1.0
Expected Price: ~10.45
```

### Example 2: In-the-money Put Option
```
Type: Put
Exercise: European
Underlying: 90
Strike: 100
Rate: 0.05
Dividend: 0.0
Volatility: 0.20
Maturity: 1.0
Expected Price: ~11.40
```

### Example 3: Premium Bond
```
Face Value: 1000
Coupon Rate: 0.07 (7%)
Yield Rate: 0.05 (5%)
Maturity: 10.0 years
Frequency: Semiannual
Expected Price: ~1155.41
```

### Example 4: Discount Bond
```
Face Value: 1000
Coupon Rate: 0.04 (4%)
Yield Rate: 0.06 (6%)
Maturity: 10.0 years
Frequency: Semiannual
Expected Price: ~851.23
```

Enjoy exploring quantitative finance with QuantLib!
