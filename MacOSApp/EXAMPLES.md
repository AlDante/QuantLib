# Sample Calculations and Expected Results

This document provides sample calculations you can use to verify the QuantLib Calculator app is working correctly.

## Option Pricing Examples

### Example 1: At-the-Money European Call

**Input Parameters:**
- Option Type: Call
- Exercise Type: European
- Underlying Price: 100.00
- Strike Price: 100.00
- Risk-Free Rate: 0.05 (5%)
- Dividend Yield: 0.00 (0%)
- Volatility: 0.20 (20%)
- Time to Maturity: 1.00 years

**Expected Output:**
- Method: Black-Scholes Analytic
- Option Price: ~10.4506
- Delta: ~0.6368
- Gamma: ~0.0188
- Vega: ~0.3752
- Theta: ~-6.4140
- Rho: ~0.5320

**Interpretation:**
- The option is worth approximately $10.45
- Delta of 0.64 means a $1 increase in stock price increases option value by $0.64
- Gamma shows how Delta changes with stock price
- Vega shows sensitivity to volatility changes
- Theta is negative (options lose value over time)
- Rho shows sensitivity to interest rate changes

### Example 2: In-the-Money European Put

**Input Parameters:**
- Option Type: Put
- Exercise Type: European
- Underlying Price: 90.00
- Strike Price: 100.00
- Risk-Free Rate: 0.05 (5%)
- Dividend Yield: 0.00 (0%)
- Volatility: 0.20 (20%)
- Time to Maturity: 1.00 years

**Expected Output:**
- Method: Black-Scholes Analytic
- Option Price: ~11.4037
- Delta: ~-0.4112
- Gamma: ~0.0189
- Vega: ~0.3405
- Theta: ~-4.2258
- Rho: ~-0.3965

**Interpretation:**
- Put option is in-the-money (stock < strike)
- Negative Delta means put increases in value when stock decreases
- Still has time value in addition to intrinsic value of $10

### Example 3: Out-of-the-Money European Call

**Input Parameters:**
- Option Type: Call
- Exercise Type: European
- Underlying Price: 95.00
- Strike Price: 100.00
- Risk-Free Rate: 0.05 (5%)
- Dividend Yield: 0.00 (0%)
- Volatility: 0.25 (25%)
- Time to Maturity: 0.50 years

**Expected Output:**
- Method: Black-Scholes Analytic
- Option Price: ~6.3957
- Delta: ~0.4514
- Gamma: ~0.0348
- Vega: ~0.1651
- Theta: ~-12.9638
- Rho: ~0.2098

### Example 4: American Put Option

**Input Parameters:**
- Option Type: Put
- Exercise Type: American
- Underlying Price: 90.00
- Strike Price: 100.00
- Risk-Free Rate: 0.05 (5%)
- Dividend Yield: 0.00 (0%)
- Volatility: 0.20 (20%)
- Time to Maturity: 1.00 years

**Expected Output:**
- Method: Finite Difference
- Option Price: ~11.7454 (slightly higher than European)
- Delta: ~-0.4250
- Gamma: ~0.0180
- Vega: ~0.3300
- Theta: ~-3.9500
- Rho: ~-0.3850

**Interpretation:**
- American put is worth more than European put (early exercise value)
- The premium for American-style exercise is about $0.34

### Example 5: High Volatility Scenario

**Input Parameters:**
- Option Type: Call
- Exercise Type: European
- Underlying Price: 100.00
- Strike Price: 100.00
- Risk-Free Rate: 0.05 (5%)
- Dividend Yield: 0.00 (0%)
- Volatility: 0.40 (40%)
- Time to Maturity: 1.00 years

**Expected Output:**
- Method: Black-Scholes Analytic
- Option Price: ~17.0425
- Delta: ~0.6073
- Vega: ~0.3846

**Interpretation:**
- Higher volatility increases option value
- Compare to Example 1 with same parameters but 20% volatility

## Bond Pricing Examples

### Example 6: Par Bond

**Input Parameters:**
- Calculation Type: Price
- Face Value: 1000.00
- Coupon Rate: 0.05 (5%)
- Yield Rate: 0.05 (5%)
- Time to Maturity: 10.00 years
- Payment Frequency: Semiannual

**Expected Output:**
- Bond Price: ~1000.00

**Interpretation:**
- When coupon rate equals yield, bond trades at par

### Example 7: Premium Bond

**Input Parameters:**
- Calculation Type: Price
- Face Value: 1000.00
- Coupon Rate: 0.07 (7%)
- Yield Rate: 0.05 (5%)
- Time to Maturity: 10.00 years
- Payment Frequency: Semiannual

**Expected Output:**
- Bond Price: ~1157.79

**Interpretation:**
- Higher coupon than yield means bond trades at premium
- Investor pays more than face value for higher coupons

### Example 8: Discount Bond

**Input Parameters:**
- Calculation Type: Price
- Face Value: 1000.00
- Coupon Rate: 0.04 (4%)
- Yield Rate: 0.06 (6%)
- Time to Maturity: 10.00 years
- Payment Frequency: Semiannual

**Expected Output:**
- Bond Price: ~852.48

**Interpretation:**
- Lower coupon than yield means bond trades at discount
- Bond price is below face value

### Example 9: Zero Coupon Bond

**Input Parameters:**
- Calculation Type: Price
- Face Value: 1000.00
- Coupon Rate: 0.00 (0%)
- Yield Rate: 0.05 (5%)
- Time to Maturity: 5.00 years
- Payment Frequency: Annual

**Expected Output:**
- Bond Price: ~783.53

**Interpretation:**
- Zero coupon bond value is purely present value of face amount
- Deep discount from face value

### Example 10: Bond Yield Calculation

**Input Parameters:**
- Calculation Type: Yield
- Face Value: 1000.00
- Coupon Rate: 0.06 (6%)
- Bond Price: 950.00
- Time to Maturity: 5.00 years
- Payment Frequency: Semiannual

**Expected Output:**
- Bond Yield: ~0.0703 (7.03%)

**Interpretation:**
- When bond price is below par, yield is higher than coupon
- The $50 discount plus coupons give 7.03% return

### Example 11: Short-Term Bond

**Input Parameters:**
- Calculation Type: Price
- Face Value: 1000.00
- Coupon Rate: 0.03 (3%)
- Yield Rate: 0.04 (4%)
- Time to Maturity: 1.00 years
- Payment Frequency: Semiannual

**Expected Output:**
- Bond Price: ~990.10

**Interpretation:**
- Short maturity means less impact from yield difference
- Price closer to par despite yield > coupon

### Example 12: Long-Term Bond

**Input Parameters:**
- Calculation Type: Price
- Face Value: 1000.00
- Coupon Rate: 0.05 (5%)
- Yield Rate: 0.06 (6%)
- Time to Maturity: 30.00 years
- Payment Frequency: Semiannual

**Expected Output:**
- Bond Price: ~862.35

**Interpretation:**
- Long maturity amplifies the discount from higher yield
- Duration risk is significant for long-term bonds

## Testing Checklist

Use these examples to verify the app:

- [ ] Example 1: At-the-money European call
- [ ] Example 2: In-the-money European put
- [ ] Example 3: Out-of-the-money call
- [ ] Example 4: American put premium
- [ ] Example 5: High volatility scenario
- [ ] Example 6: Par bond
- [ ] Example 7: Premium bond
- [ ] Example 8: Discount bond
- [ ] Example 9: Zero coupon bond
- [ ] Example 10: Yield calculation
- [ ] Example 11: Short-term bond
- [ ] Example 12: Long-term bond

## Notes on Precision

- Results may vary slightly due to:
  - Numerical precision in calculations
  - Calendar conventions
  - Day count methods
  - Different pricing engines
- Differences of 0.01 or less are typically acceptable
- American option prices should always be ≥ European option prices

## Error Cases to Test

Try these to ensure error handling works:

1. **Negative values:** Try negative stock price, volatility, or time
2. **Zero time to maturity:** Set time to 0
3. **Invalid text:** Enter "abc" in a numeric field
4. **Extreme volatility:** Try volatility > 2.0 (200%)
5. **Zero strike:** Set strike price to 0

The app should display appropriate error messages for these cases.
