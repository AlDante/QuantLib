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

#include "QuantLibCalculator.hpp"

#include <ql/qldefines.hpp>
#if !defined(BOOST_ALL_NO_LIB) && defined(BOOST_MSVC)
#  include <ql/auto_link.hpp>
#endif
#include <ql/instruments/vanillaoption.hpp>
#include <ql/pricingengines/vanilla/analyticeuropeanengine.hpp>
#include <ql/pricingengines/vanilla/fdblackscholesvanillaengine.hpp>
#include <ql/pricingengines/blackcalculator.hpp>
#include <ql/exercise.hpp>
#include <ql/termstructures/yield/flatforward.hpp>
#include <ql/termstructures/volatility/equityfx/blackconstantvol.hpp>
#include <ql/quotes/simplequote.hpp>
#include <ql/time/calendars/nullcalendar.hpp>
#include <ql/time/daycounters/actual365fixed.hpp>
#include <ql/processes/blackscholesprocess.hpp>
#include <ql/instruments/bonds/fixedratebond.hpp>
#include <ql/cashflows/fixedratecoupon.hpp>
#include <ql/time/schedule.hpp>
#include <ql/time/calendars/target.hpp>
#include <ql/time/daycounters/thirty360.hpp>
#include <ql/pricingengines/bond/discountingbondengine.hpp>
#include <ql/instruments/vanillaoption.hpp>
#include <ql/pricingengines/vanilla/analyticeuropeanengine.hpp>
#include <stdexcept>

using namespace QuantLib;

namespace QuantLibCalculator {

    OptionResult calculateEuropeanOption(
        bool isPut,
        double underlying,
        double strike,
        double riskFreeRate,
        double dividendYield,
        double volatility,
        double timeToMaturity
    ) {
        try {
            // Set up the option parameters
            Option::Type type = isPut ? Option::Put : Option::Call;
            
            // Set up dates
            Calendar calendar = NullCalendar();
            Date today = Date::todaysDate();
            Settings::instance().evaluationDate() = today;
            DayCounter dayCounter = Actual365Fixed();
            
            Date maturityDate = today + static_cast<Integer>(timeToMaturity * 365);
            
            // Create exercise
            auto europeanExercise = ext::make_shared<EuropeanExercise>(maturityDate);
            
            // Create payoff
            auto payoff = ext::make_shared<PlainVanillaPayoff>(type, strike);
            
            // Create option
            VanillaOption option(payoff, europeanExercise);
            
            // Set up market data
            auto underlyingH = makeQuoteHandle(underlying);
            auto flatTermStructure = ext::make_shared<FlatForward>(
                today, riskFreeRate, dayCounter);
            auto flatDividendTS = ext::make_shared<FlatForward>(
                today, dividendYield, dayCounter);
            auto flatVolTS = ext::make_shared<BlackConstantVol>(
                today, calendar, volatility, dayCounter);
            
            Handle<YieldTermStructure> riskFreeRateTS(flatTermStructure);
            Handle<YieldTermStructure> dividendYieldTS(flatDividendTS);
            Handle<BlackVolTermStructure> volatilityTS(flatVolTS);
            
            // Create Black-Scholes process
            auto bsmProcess = ext::make_shared<BlackScholesMertonProcess>(
                underlyingH,
                dividendYieldTS,
                riskFreeRateTS,
                volatilityTS);
            
            // Set pricing engine
            option.setPricingEngine(
                ext::make_shared<AnalyticEuropeanEngine>(bsmProcess));
            
            // Calculate results
            OptionResult result;
            result.price = option.NPV();
            result.delta = option.delta();
            result.gamma = option.gamma();
            result.vega = option.vega();
            result.theta = option.theta();
            result.rho = option.rho();
            result.method = "Black-Scholes Analytic";
            
            return result;
            
        } catch (std::exception& e) {
            throw std::runtime_error(std::string("Error calculating European option: ") + e.what());
        }
    }

    OptionResult calculateAmericanOption(
        bool isPut,
        double underlying,
        double strike,
        double riskFreeRate,
        double dividendYield,
        double volatility,
        double timeToMaturity
    ) {
        try {
            // Set up the option parameters
            Option::Type type = isPut ? Option::Put : Option::Call;
            
            // Set up dates
            Calendar calendar = NullCalendar();
            Date today = Date::todaysDate();
            Settings::instance().evaluationDate() = today;
            DayCounter dayCounter = Actual365Fixed();
            
            Date maturityDate = today + static_cast<Integer>(timeToMaturity * 365);
            
            // Create exercise
            auto americanExercise = ext::make_shared<AmericanExercise>(today, maturityDate);
            
            // Create payoff
            auto payoff = ext::make_shared<PlainVanillaPayoff>(type, strike);
            
            // Create option
            VanillaOption option(payoff, americanExercise);
            
            // Set up market data
            auto underlyingH = makeQuoteHandle(underlying);
            auto flatTermStructure = ext::make_shared<FlatForward>(
                today, riskFreeRate, dayCounter);
            auto flatDividendTS = ext::make_shared<FlatForward>(
                today, dividendYield, dayCounter);
            auto flatVolTS = ext::make_shared<BlackConstantVol>(
                today, calendar, volatility, dayCounter);
            
            Handle<YieldTermStructure> riskFreeRateTS(flatTermStructure);
            Handle<YieldTermStructure> dividendYieldTS(flatDividendTS);
            Handle<BlackVolTermStructure> volatilityTS(flatVolTS);
            
            // Create Black-Scholes process
            auto bsmProcess = ext::make_shared<BlackScholesMertonProcess>(
                underlyingH,
                dividendYieldTS,
                riskFreeRateTS,
                volatilityTS);
            
            // Set pricing engine - using finite difference for American options
            option.setPricingEngine(
                ext::make_shared<FdBlackScholesVanillaEngine>(bsmProcess, 200, 200));
            
            // Calculate results
            OptionResult result;
            result.price = option.NPV();
            result.delta = option.delta();
            result.gamma = option.gamma();
            result.vega = option.vega();
            result.theta = option.theta();
            result.rho = option.rho();
            result.method = "Finite Difference";
            
            return result;
            
        } catch (std::exception& e) {
            throw std::runtime_error(std::string("Error calculating American option: ") + e.what());
        }
    }

    double calculateBondPrice(
        double faceValue,
        double couponRate,
        double yieldRate,
        double timeToMaturity,
        int frequency
    ) {
        try {
            Calendar calendar = TARGET();
            Date today = Date::todaysDate();
            Settings::instance().evaluationDate() = today;
            
            Date maturityDate = today + static_cast<Integer>(timeToMaturity * 365);
            
            // Create schedule
            Frequency freq;
            switch(frequency) {
                case 1: freq = Annual; break;
                case 2: freq = Semiannual; break;
                case 4: freq = Quarterly; break;
                default: freq = Annual;
            }
            
            Schedule schedule(today, maturityDate, Period(freq),
                            calendar, Unadjusted, Unadjusted,
                            DateGeneration::Backward, false);
            
            // Create bond
            DayCounter bondDayCounter = Thirty360(Thirty360::BondBasis);
            std::vector<Rate> coupons(1, couponRate);
            
            FixedRateBond bond(0, faceValue, schedule, coupons, bondDayCounter);
            
            // Set up yield term structure
            auto flatTermStructure = ext::make_shared<FlatForward>(
                today, yieldRate, bondDayCounter);
            Handle<YieldTermStructure> discountCurve(flatTermStructure);
            
            // Set pricing engine
            bond.setPricingEngine(ext::make_shared<DiscountingBondEngine>(discountCurve));
            
            return bond.NPV();
            
        } catch (std::exception& e) {
            throw std::runtime_error(std::string("Error calculating bond price: ") + e.what());
        }
    }

    double calculateBondYield(
        double price,
        double faceValue,
        double couponRate,
        double timeToMaturity,
        int frequency
    ) {
        try {
            Calendar calendar = TARGET();
            Date today = Date::todaysDate();
            Settings::instance().evaluationDate() = today;
            
            Date maturityDate = today + static_cast<Integer>(timeToMaturity * 365);
            
            // Create schedule
            Frequency freq;
            switch(frequency) {
                case 1: freq = Annual; break;
                case 2: freq = Semiannual; break;
                case 4: freq = Quarterly; break;
                default: freq = Annual;
            }
            
            Schedule schedule(today, maturityDate, Period(freq),
                            calendar, Unadjusted, Unadjusted,
                            DateGeneration::Backward, false);
            
            // Create bond
            DayCounter bondDayCounter = Thirty360(Thirty360::BondBasis);
            std::vector<Rate> coupons(1, couponRate);
            
            FixedRateBond bond(0, faceValue, schedule, coupons, bondDayCounter);
            
            // Calculate yield from price
            return bond.yield(price, bondDayCounter, Compounded, freq);
            
        } catch (std::exception& e) {
            throw std::runtime_error(std::string("Error calculating bond yield: ") + e.what());
        }
    }

    double calculateImpliedVolatility(
        bool isPut,
        double optionPrice,
        double underlying,
        double strike,
        double riskFreeRate,
        double dividendYield,
        double timeToMaturity
    ) {
        try {
            // Set up the option parameters
            Option::Type type = isPut ? Option::Put : Option::Call;
            
            // Set up dates
            Calendar calendar = NullCalendar();
            Date today = Date::todaysDate();
            Settings::instance().evaluationDate() = today;
            DayCounter dayCounter = Actual365Fixed();
            
            Date maturityDate = today + static_cast<Integer>(timeToMaturity * 365);
            
            // Create exercise
            auto europeanExercise = ext::make_shared<EuropeanExercise>(maturityDate);
            
            // Create payoff
            auto payoff = ext::make_shared<PlainVanillaPayoff>(type, strike);
            
            // Create option
            VanillaOption option(payoff, europeanExercise);
            
            // Set up market data (with initial volatility guess)
            auto underlyingH = makeQuoteHandle(underlying);
            auto flatTermStructure = ext::make_shared<FlatForward>(
                today, riskFreeRate, dayCounter);
            auto flatDividendTS = ext::make_shared<FlatForward>(
                today, dividendYield, dayCounter);
            auto flatVolTS = ext::make_shared<BlackConstantVol>(
                today, calendar, 0.20, dayCounter); // initial guess
            
            Handle<YieldTermStructure> riskFreeRateTS(flatTermStructure);
            Handle<YieldTermStructure> dividendYieldTS(flatDividendTS);
            Handle<BlackVolTermStructure> volatilityTS(flatVolTS);
            
            // Create Black-Scholes process
            auto bsmProcess = ext::make_shared<BlackScholesMertonProcess>(
                underlyingH,
                dividendYieldTS,
                riskFreeRateTS,
                volatilityTS);
            
            // Set pricing engine
            option.setPricingEngine(
                ext::make_shared<AnalyticEuropeanEngine>(bsmProcess));
            
            // Calculate implied volatility
            return option.impliedVolatility(optionPrice, bsmProcess);
            
        } catch (std::exception& e) {
            throw std::runtime_error(std::string("Error calculating implied volatility: ") + e.what());
        }
    }
}
