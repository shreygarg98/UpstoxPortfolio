//
//  PortfolioViewModelTests.swift
//  UpstoxPortfolioTests
//
//  Created by Shrey Garg on 16/05/24.
//

import XCTest
@testable import UpstoxPortfolio

final class PortfolioViewModelTests: XCTestCase {
    var viewModel: PortfolioViewModel!
    var mockRepository: MockPortfolioRepository!
    
    override func setUpWithError() throws {
        mockRepository = MockPortfolioRepository()
        viewModel = PortfolioViewModel(portfolioRepository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockRepository = nil
    }
    
    func testFetchPorfolioSuccess() throws {
        // Given
        let expectation = self.expectation(description: "Portfolio data is fetched successfully")
        let mockPortfolio = Portfolio(userHolding: [Holding(symbol: "", quantity: 0, averagePrice: 0, lastTradedPrice: 0, closePrice: 0)])
        mockRepository.portfolioToReturn = .success(mockPortfolio)
        
        // When
        viewModel.fetchPortfolio()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.viewModel.getPortfolio())
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchPorfolioFailure() throws {
        // Given
        let expectation = self.expectation(description: "Portfolio data fetch failed")
        let mockError = NetworkError.noData
        mockRepository.portfolioToReturn = .failure(mockError)
        
        // When
        viewModel.fetchPortfolio()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(self.viewModel.getPortfolio())
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
