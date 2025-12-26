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

#ifndef quantlib_calculator_hpp
#define quantlib_calculator_hpp

#include <string>

namespace QuantLibCalculator {

    // Result structure for option pricing
    struct OptionResult {
        double price;
        double delta;
        double gamma;
        double vega;
        double theta;
        double rho;
        std::string method;
    };

    // Calculate European Option using Black-Scholes
    OptionResult calculateEuropeanOption(
        bool isPut,
        double underlying,
        double strike,
        double riskFreeRate,
        double dividendYield,
        double volatility,
        double timeToMaturity
    );

    // Calculate American Option using finite-difference method
    OptionResult calculateAmericanOption(
        bool isPut,
        double underlying,
        double strike,
        double riskFreeRate,
        double dividendYield,
        double volatility,
        double timeToMaturity
    );

    // Calculate bond price
    double calculateBondPrice(
        double faceValue,
        double couponRate,
        double yieldRate,
        double timeToMaturity,
        int frequency
    );

    // Calculate bond yield
    double calculateBondYield(
        double price,
        double faceValue,
        double couponRate,
        double timeToMaturity,
        int frequency
    );

    // Calculate Black-Scholes implied volatility
    double calculateImpliedVolatility(
        bool isPut,
        double optionPrice,
        double underlying,
        double strike,
        double riskFreeRate,
        double dividendYield,
        double timeToMaturity
    );
}

#endif
