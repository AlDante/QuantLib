/* -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */

/*!
 Copyright (C) 2025 QuantLib Project

 This file is part of QuantLib, a free-software/open-source library
 for financial quantitative analysts and developers - http://quantlib.org/

 QuantLib is free software: you can redistribute it and/or modify it
 under the terms of the QuantLib license.  You should have received a
 copy of the license along with this program; if not, please email
 <quantlib-dev@lists.sf.net>. The license is also available online at
 <https://www.quantlib.org/license.shtml>.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
*/

#include "QuantLibCalculator-Bridging-Header.h"
#include "QuantLibCalculator.hpp"
#include <cstring>

extern "C" {

OptionResultC calculateEuropeanOptionCpp(
    bool isPut,
    double underlying,
    double strike,
    double riskFreeRate,
    double dividendYield,
    double volatility,
    double timeToMaturity
) {
    try {
        auto result = QuantLibCalculator::calculateEuropeanOption(
            isPut, underlying, strike, riskFreeRate,
            dividendYield, volatility, timeToMaturity
        );
        
        OptionResultC cResult;
        cResult.price = result.price;
        cResult.delta = result.delta;
        cResult.gamma = result.gamma;
        cResult.vega = result.vega;
        cResult.theta = result.theta;
        cResult.rho = result.rho;
        
        // Allocate static storage for method string
        static char methodBuffer[256];
        strncpy(methodBuffer, result.method.c_str(), 255);
        methodBuffer[255] = '\0';
        cResult.method = methodBuffer;
        
        return cResult;
    } catch (...) {
        OptionResultC errorResult = {0, 0, 0, 0, 0, 0, "Error"};
        return errorResult;
    }
}

OptionResultC calculateAmericanOptionCpp(
    bool isPut,
    double underlying,
    double strike,
    double riskFreeRate,
    double dividendYield,
    double volatility,
    double timeToMaturity
) {
    try {
        auto result = QuantLibCalculator::calculateAmericanOption(
            isPut, underlying, strike, riskFreeRate,
            dividendYield, volatility, timeToMaturity
        );
        
        OptionResultC cResult;
        cResult.price = result.price;
        cResult.delta = result.delta;
        cResult.gamma = result.gamma;
        cResult.vega = result.vega;
        cResult.theta = result.theta;
        cResult.rho = result.rho;
        
        // Allocate static storage for method string
        static char methodBuffer[256];
        strncpy(methodBuffer, result.method.c_str(), 255);
        methodBuffer[255] = '\0';
        cResult.method = methodBuffer;
        
        return cResult;
    } catch (...) {
        OptionResultC errorResult = {0, 0, 0, 0, 0, 0, "Error"};
        return errorResult;
    }
}

double calculateBondPriceCpp(
    double faceValue,
    double couponRate,
    double yieldRate,
    double timeToMaturity,
    int frequency
) {
    try {
        return QuantLibCalculator::calculateBondPrice(
            faceValue, couponRate, yieldRate, timeToMaturity, frequency
        );
    } catch (...) {
        return 0.0;
    }
}

double calculateBondYieldCpp(
    double price,
    double faceValue,
    double couponRate,
    double timeToMaturity,
    int frequency
) {
    try {
        return QuantLibCalculator::calculateBondYield(
            price, faceValue, couponRate, timeToMaturity, frequency
        );
    } catch (...) {
        return 0.0;
    }
}

double calculateImpliedVolatilityCpp(
    bool isPut,
    double optionPrice,
    double underlying,
    double strike,
    double riskFreeRate,
    double dividendYield,
    double timeToMaturity
) {
    try {
        return QuantLibCalculator::calculateImpliedVolatility(
            isPut, optionPrice, underlying, strike,
            riskFreeRate, dividendYield, timeToMaturity
        );
    } catch (...) {
        return 0.0;
    }
}

} // extern "C"
