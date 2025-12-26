import Foundation

class QuantLibWrapper {
    enum QuantLibError: Error {
        case calculationFailed(String)
    }
    
    static func calculateEuropeanOption(
        isPut: Bool,
        underlying: Double,
        strike: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double,
        timeToMaturity: Double
    ) throws -> OptionCalculationResult {
        // This will call the C++ wrapper through an Objective-C bridge
        let result = calculateEuropeanOptionCpp(
            isPut,
            underlying,
            strike,
            riskFreeRate,
            dividendYield,
            volatility,
            timeToMaturity
        )
        
        if result.price.isNaN || result.price.isInfinite {
            throw QuantLibError.calculationFailed("Invalid calculation result")
        }
        
        return OptionCalculationResult(
            price: result.price,
            delta: result.delta,
            gamma: result.gamma,
            vega: result.vega,
            theta: result.theta,
            rho: result.rho,
            method: String(cString: result.method)
        )
    }
    
    static func calculateAmericanOption(
        isPut: Bool,
        underlying: Double,
        strike: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        volatility: Double,
        timeToMaturity: Double
    ) throws -> OptionCalculationResult {
        let result = calculateAmericanOptionCpp(
            isPut,
            underlying,
            strike,
            riskFreeRate,
            dividendYield,
            volatility,
            timeToMaturity
        )
        
        if result.price.isNaN || result.price.isInfinite {
            throw QuantLibError.calculationFailed("Invalid calculation result")
        }
        
        return OptionCalculationResult(
            price: result.price,
            delta: result.delta,
            gamma: result.gamma,
            vega: result.vega,
            theta: result.theta,
            rho: result.rho,
            method: String(cString: result.method)
        )
    }
    
    static func calculateBondPrice(
        faceValue: Double,
        couponRate: Double,
        yieldRate: Double,
        timeToMaturity: Double,
        frequency: Int
    ) throws -> Double {
        let price = calculateBondPriceCpp(
            faceValue,
            couponRate,
            yieldRate,
            timeToMaturity,
            Int32(frequency)
        )
        
        if price.isNaN || price.isInfinite || price < 0 {
            throw QuantLibError.calculationFailed("Invalid bond price result")
        }
        
        return price
    }
    
    static func calculateBondYield(
        price: Double,
        faceValue: Double,
        couponRate: Double,
        timeToMaturity: Double,
        frequency: Int
    ) throws -> Double {
        let yieldRate = calculateBondYieldCpp(
            price,
            faceValue,
            couponRate,
            timeToMaturity,
            Int32(frequency)
        )
        
        if yieldRate.isNaN || yieldRate.isInfinite {
            throw QuantLibError.calculationFailed("Invalid bond yield result")
        }
        
        return yieldRate
    }
    
    static func calculateImpliedVolatility(
        isPut: Bool,
        optionPrice: Double,
        underlying: Double,
        strike: Double,
        riskFreeRate: Double,
        dividendYield: Double,
        timeToMaturity: Double
    ) throws -> Double {
        let vol = calculateImpliedVolatilityCpp(
            isPut,
            optionPrice,
            underlying,
            strike,
            riskFreeRate,
            dividendYield,
            timeToMaturity
        )
        
        if vol.isNaN || vol.isInfinite || vol < 0 {
            throw QuantLibError.calculationFailed("Invalid implied volatility result")
        }
        
        return vol
    }
}
