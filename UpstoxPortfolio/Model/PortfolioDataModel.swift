//
//  PortfolioDataModel.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import Foundation

struct Holding: Codable {
    let symbol: String
    let quantity: Int
    let averagePrice: Double
    let lastTradedPrice: Double
    let closePrice: Double
    
    enum CodingKeys : String, CodingKey {
        case symbol = "symbol"
        case quantity = "quantity"
        case averagePrice = "avgPrice"
        case lastTradedPrice = "ltp"
        case closePrice = "close"
    }
    
    init(symbol: String, quantity: Int, averagePrice: Double, lastTradedPrice: Double, closePrice: Double) {
        self.symbol = symbol
        self.quantity = quantity
        self.averagePrice = averagePrice
        self.lastTradedPrice = lastTradedPrice
        self.closePrice = closePrice
    }
    
    var currentValue: Double {
        return lastTradedPrice * Double(quantity)
    }
    var investmentValue: Double {
        return averagePrice * Double(quantity)
    }
    var profitAndLoss: Double {
        return currentValue - investmentValue
    }
}

struct Portfolio: Codable {
    let userHolding: [Holding]
}

struct PortfolioResponse: Codable {
    let data: Portfolio
}

struct CalculatedTotalInvestmentDetails{
    let totalCurrentValue: Double
    let totalInvestment: Double
    let totalProfitAndLoss: Double
    let todaysTotalProfitAndLoss: Double
    
    init(totalCurrentValue: Double, totalInvestment: Double, totalProfitAndLoss: Double, todaysTotalProfitAndLoss: Double) {
        self.totalCurrentValue = totalCurrentValue
        self.totalInvestment = totalInvestment
        self.totalProfitAndLoss = totalProfitAndLoss
        self.todaysTotalProfitAndLoss = todaysTotalProfitAndLoss
    }
}
