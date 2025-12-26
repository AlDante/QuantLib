cmake_minimum_required(VERSION 3.15)

# Set up the project
project(QuantLibCalculator LANGUAGES CXX Swift)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find QuantLib
find_package(QuantLib REQUIRED)

# Set Swift flags for macOS app
if(APPLE)
    enable_language(Swift)
    set(CMAKE_Swift_LANGUAGE_VERSION 5.0)
    
    # Define app bundle name
    set(MACOSX_BUNDLE_BUNDLE_NAME "QuantLib Calculator")
    set(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
    set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
    set(MACOSX_BUNDLE_GUI_IDENTIFIER "org.quantlib.calculator")
    
    # C++ source files
    set(CPP_SOURCES
        QuantLibCalculator.cpp
        QuantLibBridge.mm
    )
    
    # Swift source files
    set(SWIFT_SOURCES
        AppDelegate.swift
        ContentView.swift
        QuantLibWrapper.swift
    )
    
    # Create the macOS app bundle
    add_executable(QuantLibCalculator MACOSX_BUNDLE
        ${CPP_SOURCES}
        ${SWIFT_SOURCES}
    )
    
    # Link QuantLib
    target_link_libraries(QuantLibCalculator PRIVATE ql_library)
    
    # Set bridging header
    set_target_properties(QuantLibCalculator PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist
        XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER ${CMAKE_CURRENT_SOURCE_DIR}/QuantLibCalculator-Bridging-Header.h
        XCODE_ATTRIBUTE_SWIFT_VERSION 5.0
        XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
    )
    
    # Include directories
    target_include_directories(QuantLibCalculator PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${QuantLib_INCLUDE_DIRS}
    )
    
    # Add frameworks
    target_link_libraries(QuantLibCalculator PRIVATE
        "-framework Cocoa"
        "-framework SwiftUI"
    )
    
    # Installation
    install(TARGETS QuantLibCalculator
        BUNDLE DESTINATION .
    )
    
endif()
