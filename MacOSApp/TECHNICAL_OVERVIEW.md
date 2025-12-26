# QuantLib Financial Calculator - Technical Overview

## Project Structure

```
MacOSApp/
├── Info.plist                          # macOS app bundle metadata
├── CMakeLists.txt                      # Build configuration
├── build.sh                            # Automated build script
│
├── Swift UI Layer
│   ├── AppDelegate.swift               # App lifecycle and window management
│   ├── ContentView.swift               # Main UI with tabs and views
│   └── QuantLibWrapper.swift           # Swift interface to C++ code
│
├── Bridge Layer
│   ├── QuantLibCalculator-Bridging-Header.h  # C declarations for Swift
│   └── QuantLibBridge.mm               # Objective-C++ bridge implementation
│
├── C++ Calculation Layer
│   ├── QuantLibCalculator.hpp          # C++ interface definitions
│   └── QuantLibCalculator.cpp          # QuantLib calculation implementations
│
└── Documentation
    ├── README.md                       # Main documentation
    ├── QUICKSTART.md                   # Quick start guide
    ├── XCODE_BUILD.md                  # Xcode-specific instructions
    └── EXAMPLES.md                     # Sample calculations
```

## Architecture

### Layer 1: Swift UI (User Interface)

**AppDelegate.swift**
- Manages application lifecycle
- Creates and configures the main window
- Uses SwiftUI for modern macOS UI

**ContentView.swift**
- Tab-based interface with three tabs:
  1. Options Calculator
  2. Bond Calculator
  3. About
- Input validation and error handling
- Result display with formatted output

**Key Features:**
- Native macOS look and feel
- Responsive layout
- Real-time validation
- Clear error messages

### Layer 2: Swift Wrapper

**QuantLibWrapper.swift**
- Provides Swift-friendly interface to C++ functions
- Converts between Swift and C types
- Error handling and validation
- Type safety

**Functions:**
- `calculateEuropeanOption()` - European option pricing
- `calculateAmericanOption()` - American option pricing
- `calculateBondPrice()` - Bond price from yield
- `calculateBondYield()` - Bond yield from price
- `calculateImpliedVolatility()` - Implied volatility

### Layer 3: Objective-C++ Bridge

**QuantLibCalculator-Bridging-Header.h**
- C-compatible function declarations
- Data structures for passing between Swift and C++
- Enables Swift to call C++ code

**QuantLibBridge.mm**
- Objective-C++ implementation
- Converts between C and C++ types
- Exception handling
- Memory management

### Layer 4: C++ Calculation Engine

**QuantLibCalculator.hpp/cpp**
- Direct interface to QuantLib
- Implements financial calculations:
  - Option pricing (European and American)
  - Bond pricing and yield calculations
  - Greeks calculation
  - Implied volatility

**Uses QuantLib Components:**
- `VanillaOption` - Option instruments
- `AnalyticEuropeanEngine` - Black-Scholes pricing
- `FdBlackScholesVanillaEngine` - Finite difference for American options
- `FixedRateBond` - Bond instruments
- `BlackScholesMertonProcess` - Stochastic process
- Various term structures and day counters

## Data Flow

```
User Input (Swift UI)
    ↓
ContentView validates input
    ↓
QuantLibWrapper.swift (Swift function call)
    ↓
QuantLibBridge.mm (C++ wrapper function)
    ↓
QuantLibCalculator.cpp (QuantLib calculations)
    ↓
Results flow back up the chain
    ↓
Display in Swift UI
```

## Build Process

### CMake Build
1. CMake reads CMakeLists.txt
2. Finds QuantLib installation
3. Configures compiler flags
4. Compiles C++ sources
5. Compiles Swift sources
6. Links against QuantLib
7. Creates macOS app bundle

### Manual Build Steps
```bash
mkdir build && cd build
cmake ..
make
```

### Xcode Build
```bash
cmake -G Xcode ..
open QuantLibCalculator.xcodeproj
```

## Financial Calculations Implemented

### Option Pricing

**European Options (Black-Scholes)**
- Closed-form analytical solution
- Fast and accurate
- Greeks calculated analytically

**American Options (Finite Difference)**
- Numerical solution
- Accounts for early exercise
- More computationally intensive

**Greeks Calculated:**
- Delta: ∂V/∂S (price sensitivity to underlying)
- Gamma: ∂²V/∂S² (delta sensitivity to underlying)
- Vega: ∂V/∂σ (sensitivity to volatility)
- Theta: ∂V/∂t (time decay)
- Rho: ∂V/∂r (sensitivity to interest rate)

### Bond Pricing

**Bond Price Calculation:**
- Present value of future cash flows
- Coupon payments
- Face value at maturity
- Various payment frequencies

**Bond Yield Calculation:**
- Internal rate of return
- Iterative solution
- Yield to maturity

## Dependencies

### Required
- **QuantLib** (>= 1.0): Core financial library
- **Boost** (usually bundled with QuantLib): C++ utilities
- **macOS SDK** (10.15+): macOS frameworks
- **Swift** (5.0+): UI language
- **CMake** (3.15+): Build system

### Optional
- **Xcode**: IDE for development
- **Homebrew**: Package manager for easy installation

## Design Decisions

### Why Swift + C++?
- Swift provides modern, safe UI development
- C++ gives access to QuantLib's powerful calculations
- Best of both worlds

### Why Objective-C++ Bridge?
- Swift cannot directly call C++
- Objective-C++ is the standard bridge
- Proven pattern for macOS apps

### Why CMake?
- Cross-platform build system
- Standard for C++ projects
- Can generate Xcode projects

### Why SwiftUI?
- Modern declarative UI
- Native macOS look and feel
- Less code than AppKit
- Better maintainability

## Performance Considerations

### Option Pricing
- European options: < 1ms (analytical)
- American options: 10-100ms (numerical)

### Bond Calculations
- Price calculation: < 5ms
- Yield calculation: 10-50ms (iterative)

### Optimization Opportunities
- Cache repeated calculations
- Parallel computation for multiple scenarios
- GPU acceleration for Monte Carlo methods

## Error Handling

### Input Validation
- Type checking in Swift
- Range validation
- Null/undefined checks

### Calculation Errors
- C++ exceptions caught in bridge
- Converted to Swift errors
- User-friendly messages

### Common Errors
- Invalid input values
- Numerical instabilities
- Out-of-range parameters

## Testing Strategy

### Unit Testing
- Test each calculation function
- Compare with known values
- Edge case testing

### Integration Testing
- Full workflow testing
- UI interaction testing
- Error handling testing

### Validation
- Compare with standard financial calculators
- Use documented examples
- Verify Greeks relationships

## Future Enhancements

### Potential Features
1. **More Instruments:**
   - Asian options
   - Barrier options
   - Exotic options
   - Interest rate swaps
   - Credit default swaps

2. **Advanced Features:**
   - Volatility surfaces
   - Yield curve construction
   - Risk analysis tools
   - Portfolio optimization

3. **UI Improvements:**
   - Charts and graphs
   - Real-time data feeds
   - Scenario analysis
   - Export to CSV/Excel

4. **Performance:**
   - Monte Carlo simulations
   - Multi-threading
   - Batch calculations

## Maintenance

### Updating QuantLib
When a new QuantLib version is released:
1. Update QuantLib installation
2. Test all calculations
3. Check for deprecated APIs
4. Update documentation

### Code Style
- C++: Follow QuantLib conventions
- Swift: Follow Swift API Design Guidelines
- Comments: Clear and concise

## Resources

### QuantLib Resources
- [QuantLib Website](https://www.quantlib.org)
- [QuantLib Documentation](https://www.quantlib.org/docs.shtml)
- [QuantLib GitHub](https://github.com/lballabio/QuantLib)

### Swift Resources
- [Swift Language Guide](https://docs.swift.org/swift-book/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

### Financial Mathematics
- Hull, J. C. "Options, Futures, and Other Derivatives"
- Wilmott, P. "Paul Wilmott on Quantitative Finance"

## License

This application uses QuantLib, which is licensed under a modified BSD license.
See QuantLib's LICENSE.TXT for details.

## Support

For issues or questions:
- Check documentation files
- Review example calculations
- Visit QuantLib forums
- Check GitHub issues

## Contributors

This application was created to demonstrate QuantLib integration with macOS.
Contributions are welcome!
