#ifndef QuantLibCalculator_Bridging_Header_h
#define QuantLibCalculator_Bridging_Header_h

#ifdef __cplusplus
extern "C" {
#endif

// Result structure for option pricing (C-compatible)
typedef struct {
    double price;
    double delta;
    double gamma;
    double vega;
    double theta;
    double rho;
    const char* method;
} OptionResultC;

// C wrapper functions to call from Swift
OptionResultC calculateEuropeanOptionCpp(
    bool isPut,
    double underlying,
    double strike,
    double riskFreeRate,
    double dividendYield,
    double volatility,
    double timeToMaturity
);

OptionResultC calculateAmericanOptionCpp(
    bool isPut,
    double underlying,
    double strike,
    double riskFreeRate,
    double dividendYield,
    double volatility,
    double timeToMaturity
);

double calculateBondPriceCpp(
    double faceValue,
    double couponRate,
    double yieldRate,
    double timeToMaturity,
    int frequency
);

double calculateBondYieldCpp(
    double price,
    double faceValue,
    double couponRate,
    double timeToMaturity,
    int frequency
);

double calculateImpliedVolatilityCpp(
    bool isPut,
    double optionPrice,
    double underlying,
    double strike,
    double riskFreeRate,
    double dividendYield,
    double timeToMaturity
);

#ifdef __cplusplus
}
#endif

#endif /* QuantLibCalculator_Bridging_Header_h */
