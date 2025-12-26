# Xcode Build Instructions

## Building with Xcode

If you prefer to use Xcode for development, follow these steps:

### Option 1: Generate Xcode Project from CMake

1. Navigate to the MacOSApp directory:
   ```bash
   cd MacOSApp
   mkdir build && cd build
   ```

2. Generate the Xcode project:
   ```bash
   cmake -G Xcode ..
   ```

3. Open the generated project:
   ```bash
   open QuantLibCalculator.xcodeproj
   ```

4. In Xcode:
   - Select the "QuantLibCalculator" scheme
   - Choose your build destination (usually "My Mac")
   - Click the "Build" button (⌘B) or Product > Build
   - Click the "Run" button (⌘R) or Product > Run

### Option 2: Manual Xcode Project Setup

If CMake doesn't work for your setup, you can create an Xcode project manually:

1. Open Xcode
2. Create a new project: File > New > Project
3. Choose "macOS" > "App"
4. Set the following:
   - Product Name: QuantLibCalculator
   - Team: Your development team
   - Organization Identifier: org.quantlib
   - Interface: SwiftUI
   - Language: Swift
   - Storage: None

5. Add source files:
   - Drag and drop all `.swift` files into the project
   - Add all `.cpp`, `.mm`, and `.hpp` files to the project
   - Add the bridging header

6. Configure build settings:
   - Select the project in the navigator
   - Select the "QuantLibCalculator" target
   - Go to "Build Settings"
   - Search for "Header Search Paths" and add QuantLib include path:
     ```
     /usr/local/include
     $(QUANTLIB_INCLUDE_DIR)
     ```
   - Search for "Library Search Paths" and add:
     ```
     /usr/local/lib
     ```
   - Search for "Other Linker Flags" and add:
     ```
     -lQuantLib
     ```

7. Set the bridging header:
   - In "Build Settings", search for "Objective-C Bridging Header"
   - Set to: `QuantLibCalculator-Bridging-Header.h`

8. Configure Info.plist:
   - Replace the default Info.plist with the provided one

9. Build and run!

### Troubleshooting Xcode Build

**Issue: "Cannot find QuantLib headers"**
- Solution: Make sure QuantLib is installed via Homebrew or from source
- Add `/usr/local/include` to Header Search Paths
- Or use `$(shell quantlib-config --cflags)` in build settings

**Issue: "Undefined symbols for architecture x86_64/arm64"**
- Solution: Add `-lQuantLib` to Other Linker Flags
- Add `/usr/local/lib` to Library Search Paths
- Or use `$(shell quantlib-config --libs)` in build settings

**Issue: "Bridging header not found"**
- Solution: Make sure the bridging header path is relative to the project root
- Set it in Build Settings > Swift Compiler - General > Objective-C Bridging Header

**Issue: "Swift version mismatch"**
- Solution: Set Swift Language Version to 5.0 in Build Settings

### Build Settings Reference

For manual setup, here are the key build settings:

**Header Search Paths:**
```
/usr/local/include
```

**Library Search Paths:**
```
/usr/local/lib
```

**Other Linker Flags:**
```
-lQuantLib
```

**Swift Language Version:**
```
5.0
```

**Objective-C Bridging Header:**
```
QuantLibCalculator-Bridging-Header.h
```

**Enable Objective-C Automatic Reference Counting:**
```
Yes
```

### Using quantlib-config

For dynamic configuration based on your QuantLib installation:

**Header Search Paths:**
```bash
$(shell quantlib-config --cflags)
```

**Other Linker Flags:**
```bash
$(shell quantlib-config --libs)
```

This ensures the build uses the correct paths for your QuantLib installation.

## Debugging in Xcode

To debug the application:

1. Set breakpoints in Swift or C++ code
2. Run the app with ⌘R
3. The debugger will stop at breakpoints
4. Use the debug console to inspect variables
5. Step through code with F6 (step over) or F7 (step into)

## Performance Profiling

To profile the application:

1. Product > Profile (⌘I)
2. Choose "Time Profiler" or "Allocations"
3. Record a session while using the app
4. Analyze where time is spent in calculations

This is useful for optimizing complex option pricing calculations.
