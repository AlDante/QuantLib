import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OptionCalculatorView()
                .tabItem {
                    Label("Options", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(0)
            
            BondCalculatorView()
                .tabItem {
                    Label("Bonds", systemImage: "dollarsign.circle")
                }
                .tag(1)
            
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(2)
        }
        .frame(minWidth: 700, minHeight: 500)
    }
}

struct OptionCalculatorView: View {
    @State private var optionType = 0 // 0 = Call, 1 = Put
    @State private var exerciseType = 0 // 0 = European, 1 = American
    @State private var underlying = "100.0"
    @State private var strike = "100.0"
    @State private var riskFreeRate = "0.05"
    @State private var dividendYield = "0.0"
    @State private var volatility = "0.20"
    @State private var timeToMaturity = "1.0"
    
    @State private var result: OptionCalculationResult?
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Option Pricing Calculator")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                
                GroupBox(label: Text("Option Parameters").font(.headline)) {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Option Type:")
                                .frame(width: 150, alignment: .leading)
                            Picker("", selection: $optionType) {
                                Text("Call").tag(0)
                                Text("Put").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                        }
                        
                        HStack {
                            Text("Exercise Type:")
                                .frame(width: 150, alignment: .leading)
                            Picker("", selection: $exerciseType) {
                                Text("European").tag(0)
                                Text("American").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                        }
                        
                        InputField(label: "Underlying Price:", value: $underlying)
                        InputField(label: "Strike Price:", value: $strike)
                        InputField(label: "Risk-Free Rate:", value: $riskFreeRate)
                        InputField(label: "Dividend Yield:", value: $dividendYield)
                        InputField(label: "Volatility:", value: $volatility)
                        InputField(label: "Time to Maturity:", value: $timeToMaturity)
                    }
                    .padding()
                }
                
                Button(action: calculateOption) {
                    Text("Calculate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                if let result = result {
                    GroupBox(label: Text("Results").font(.headline)) {
                        VStack(alignment: .leading, spacing: 10) {
                            ResultRow(label: "Method:", value: result.method)
                            ResultRow(label: "Option Price:", value: String(format: "%.4f", result.price))
                            ResultRow(label: "Delta:", value: String(format: "%.4f", result.delta))
                            ResultRow(label: "Gamma:", value: String(format: "%.4f", result.gamma))
                            ResultRow(label: "Vega:", value: String(format: "%.4f", result.vega))
                            ResultRow(label: "Theta:", value: String(format: "%.4f", result.theta))
                            ResultRow(label: "Rho:", value: String(format: "%.4f", result.rho))
                        }
                        .padding()
                    }
                }
            }
            .padding()
        }
    }
    
    func calculateOption() {
        errorMessage = nil
        result = nil
        
        guard let underlyingValue = Double(underlying),
              let strikeValue = Double(strike),
              let rateValue = Double(riskFreeRate),
              let divYieldValue = Double(dividendYield),
              let volValue = Double(volatility),
              let timeValue = Double(timeToMaturity) else {
            errorMessage = "Please enter valid numeric values"
            return
        }
        
        // Call the QuantLib C++ wrapper
        let isPut = optionType == 1
        
        do {
            if exerciseType == 0 {
                result = try QuantLibWrapper.calculateEuropeanOption(
                    isPut: isPut,
                    underlying: underlyingValue,
                    strike: strikeValue,
                    riskFreeRate: rateValue,
                    dividendYield: divYieldValue,
                    volatility: volValue,
                    timeToMaturity: timeValue
                )
            } else {
                result = try QuantLibWrapper.calculateAmericanOption(
                    isPut: isPut,
                    underlying: underlyingValue,
                    strike: strikeValue,
                    riskFreeRate: rateValue,
                    dividendYield: divYieldValue,
                    volatility: volValue,
                    timeToMaturity: timeValue
                )
            }
        } catch {
            errorMessage = "Calculation error: \(error.localizedDescription)"
        }
    }
}

struct BondCalculatorView: View {
    @State private var calculationType = 0 // 0 = Price, 1 = Yield
    @State private var faceValue = "1000.0"
    @State private var couponRate = "0.05"
    @State private var yieldRate = "0.06"
    @State private var timeToMaturity = "5.0"
    @State private var frequency = 2 // Semiannual
    @State private var bondPrice = "1000.0"
    
    @State private var result: String?
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Bond Calculator")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                
                GroupBox(label: Text("Bond Parameters").font(.headline)) {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Calculate:")
                                .frame(width: 150, alignment: .leading)
                            Picker("", selection: $calculationType) {
                                Text("Price").tag(0)
                                Text("Yield").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                        }
                        
                        InputField(label: "Face Value:", value: $faceValue)
                        InputField(label: "Coupon Rate:", value: $couponRate)
                        
                        if calculationType == 0 {
                            InputField(label: "Yield Rate:", value: $yieldRate)
                        } else {
                            InputField(label: "Bond Price:", value: $bondPrice)
                        }
                        
                        InputField(label: "Time to Maturity:", value: $timeToMaturity)
                        
                        HStack {
                            Text("Payment Frequency:")
                                .frame(width: 150, alignment: .leading)
                            Picker("", selection: $frequency) {
                                Text("Annual").tag(1)
                                Text("Semiannual").tag(2)
                                Text("Quarterly").tag(4)
                            }
                            .frame(width: 200)
                        }
                    }
                    .padding()
                }
                
                Button(action: calculateBond) {
                    Text("Calculate")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
                
                if let result = result {
                    GroupBox(label: Text("Result").font(.headline)) {
                        Text(result)
                            .font(.title2)
                            .padding()
                    }
                }
            }
            .padding()
        }
    }
    
    func calculateBond() {
        errorMessage = nil
        result = nil
        
        guard let faceVal = Double(faceValue),
              let couponRateVal = Double(couponRate),
              let timeVal = Double(timeToMaturity) else {
            errorMessage = "Please enter valid numeric values"
            return
        }
        
        do {
            if calculationType == 0 {
                guard let yieldRateVal = Double(yieldRate) else {
                    errorMessage = "Please enter valid yield rate"
                    return
                }
                let price = try QuantLibWrapper.calculateBondPrice(
                    faceValue: faceVal,
                    couponRate: couponRateVal,
                    yieldRate: yieldRateVal,
                    timeToMaturity: timeVal,
                    frequency: frequency
                )
                result = String(format: "Bond Price: %.2f", price)
            } else {
                guard let priceVal = Double(bondPrice) else {
                    errorMessage = "Please enter valid bond price"
                    return
                }
                let yield = try QuantLibWrapper.calculateBondYield(
                    price: priceVal,
                    faceValue: faceVal,
                    couponRate: couponRateVal,
                    timeToMaturity: timeVal,
                    frequency: frequency
                )
                result = String(format: "Bond Yield: %.4f (%.2f%%)", yield, yield * 100)
            }
        } catch {
            errorMessage = "Calculation error: \(error.localizedDescription)"
        }
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding()
            
            Text("QuantLib Financial Calculator")
                .font(.largeTitle)
                .bold()
            
            Text("Version 1.0")
                .font(.title3)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("This application uses the QuantLib library to calculate:")
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 5) {
                    BulletPoint(text: "European and American option prices")
                    BulletPoint(text: "Option Greeks (Delta, Gamma, Vega, Theta, Rho)")
                    BulletPoint(text: "Bond prices and yields")
                    BulletPoint(text: "Implied volatility")
                }
                .padding(.leading)
            }
            .padding()
            
            Text("QuantLib is a free/open-source library for quantitative finance")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Link("Visit QuantLib.org", destination: URL(string: "https://www.quantlib.org")!)
                .padding()
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Helper Views
struct InputField: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 150, alignment: .leading)
            TextField("", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
        }
    }
}

struct ResultRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 150, alignment: .leading)
                .bold()
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
            Text(text)
        }
    }
}

// Data structures
struct OptionCalculationResult {
    let price: Double
    let delta: Double
    let gamma: Double
    let vega: Double
    let theta: Double
    let rho: Double
    let method: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
