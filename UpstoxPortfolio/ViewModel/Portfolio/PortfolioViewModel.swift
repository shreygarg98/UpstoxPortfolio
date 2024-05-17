//
//  PortfolioViewModel.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//


import Foundation

protocol PortfolioViewModelProtocol {
    var startOrStopLoader: ((Bool) -> Void)? { get set }
    var onDataUpdate: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func getCalculatedTotalInvestmentDetails() -> CalculatedTotalInvestmentDetails
    func getPortfolio() -> Portfolio?
    func getHoldingsCount() -> Int
    func getHolding(forIndexpath index: Int) -> Holding
    func fetchPortfolio()
}

class PortfolioViewModel: PortfolioViewModelProtocol {
    
    private let portfolioRepository: PortfolioRepositoryProtocol
    private var portfolio: Portfolio?
    var startOrStopLoader: ((Bool) -> Void)?
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(portfolioRepository: PortfolioRepositoryProtocol) {
        self.portfolioRepository = portfolioRepository
    }
    
    private func calculateCurrentValue() -> Double {
        return portfolio?.userHolding.reduce(0) { $0 + ($1.lastTradedPrice * Double($1.quantity)) } ?? 0
    }
    
    private func calculateTotalInvestment() -> Double {
        return portfolio?.userHolding.reduce(0) { $0 + ($1.averagePrice * Double($1.quantity)) } ?? 0
    }
    
    private func calculateTotalPNL() -> Double {
        return calculateCurrentValue() - calculateTotalInvestment()
    }
    
    private func calculateTodayPNL() -> Double {
        return portfolio?.userHolding.reduce(0) { $0 + (($1.closePrice - $1.lastTradedPrice) * Double($1.quantity)) } ?? 0
    }
    
    func getCalculatedTotalInvestmentDetails()->CalculatedTotalInvestmentDetails{
        return CalculatedTotalInvestmentDetails(totalCurrentValue: calculateCurrentValue(),
                                                                                totalInvestment: calculateTotalInvestment(),
                                                                                totalProfitAndLoss: calculateTotalPNL(),
                                                                                todaysTotalProfitAndLoss: calculateTodayPNL())
    }
    
    func getPortfolio() -> Portfolio? {
        return portfolio
    }
    func getHoldingsCount() -> Int{
        return portfolio?.userHolding.count ?? 0
    }
    
    func getHolding(forIndexpath index: Int) -> Holding{
        return portfolio?.userHolding[index] ?? Holding(symbol: "", quantity: 0, averagePrice: 0, lastTradedPrice: 0, closePrice: 0)
    }
    
    func fetchPortfolio() {
        startOrStopLoader?(true)
        portfolioRepository.fetchPortfolio { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let portfolio):
                self.portfolio = portfolio
                self.onDataUpdate?()
            case .failure(let error):
                self.onError?(error)
            }
            startOrStopLoader?(false)
        }
    }
    
}
