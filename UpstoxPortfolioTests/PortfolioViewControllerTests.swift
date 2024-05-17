//
//  PortfolioViewControllerTests.swift
//  UpstoxPortfolioTests
//
//  Created by Shrey Garg on 16/05/24.
//

import XCTest
@testable import UpstoxPortfolio

class PortfolioViewControllerTests: XCTestCase {
    
    var sut: PortfolioViewController!
    var mockViewModel: MockPortfolioViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PortfolioViewController()
        mockViewModel = MockPortfolioViewModel()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
        try super.tearDownWithError()
    }
    
    func testSetupNavBar() {
        // Test navigation bar setup
        sut.setupNavBar()
        XCTAssertNotNil(sut.navigationItem.leftBarButtonItems)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
    }
    
    func testSetupLoaderView() {
        // Test loader view setup
        sut.setupLoaderView()
        XCTAssertTrue(sut.loaderView.isDescendant(of: sut.view))
    }
    
    func testStartOrStopAnimating() {
        // Test start and stop animating
        sut.startOrStopAnimating(true)
        XCTAssertTrue(sut.loaderView.isAnimating)
        sut.startOrStopAnimating(false)
        XCTAssertFalse(sut.loaderView.isAnimating)
    }
    
    func testSetupTotalInvestmentDetails() {
        // Test total investment details setup
        sut.setupTotalInvestmentDetails()
        XCTAssertTrue(sut.expandableFooterView.isDescendant(of: sut.view))
    }
    
    func testSetupViewModel() {
        // Test view model setup
        sut.setupViewModel()
        XCTAssertNotNil(sut.viewModel)
    }
    
    func testBackButton() {
        // Test back button action
        let mockNavController = MockNavigationController(rootViewController: sut)
        sut.backButton()
        XCTAssertTrue(mockNavController.popViewControllerCalled)
    }
    
    func testTableViewDataSource() {
        // Test table view data source methods
        let tableView = UITableView()
        tableView.dataSource = sut
        XCTAssertEqual(sut.tableView(tableView, numberOfRowsInSection: 0), sut.viewModel.getHoldingsCount())
    }
    
    func testTableViewCellForRowAt() {
        // Test table view cell creation
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as! HoldingsTableViewCell
        XCTAssertNotNil(cell)
    }
}
class MockNavigationController: UINavigationController {
    var popViewControllerCalled = false
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return super.popViewController(animated: animated)
    }
}

class MockPortfolioViewModel: PortfolioViewModelProtocol {
    
    var startOrStopLoader: ((Bool) -> Void)?
    var onDataUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    var fetchPortfolioCalled = false
    
    func fetchPortfolio() {
        fetchPortfolioCalled = true
    }
    
    func getHoldingsCount() -> Int {
        // Implement this method as required
        return 1
    }
    
    func getHolding(forIndexpath index: Int) -> Holding {
        // Implement this method as required
        return Holding(symbol: "AAPL", quantity: 100, averagePrice: 150.0, lastTradedPrice: 160.0, closePrice: 155.0)
    }
    
    func getCalculatedTotalInvestmentDetails() -> CalculatedTotalInvestmentDetails {
        let currentValue = calculateCurrentValue()
        let totalInvestment = calculateTotalInvestment()
        let totalPNL = calculateTotalPNL()
        let todayPNL = calculateTodayPNL()
        
        return CalculatedTotalInvestmentDetails(totalCurrentValue: currentValue,
                                                totalInvestment: totalInvestment,
                                                totalProfitAndLoss: totalPNL,
                                                todaysTotalProfitAndLoss: todayPNL)
    }
    
    private func calculateCurrentValue() -> Double {
        // Simulate fetching data from holdings
        let holding = getHolding(forIndexpath: 0)
        return holding.lastTradedPrice * Double(holding.quantity)
    }
    
    private func calculateTotalInvestment() -> Double {
        // Simulate fetching data from holdings
        let holding = getHolding(forIndexpath: 0)
        return holding.averagePrice * Double(holding.quantity)
    }
    
    private func calculateTotalPNL() -> Double {
        // Simulate fetching data from holdings
        let currentValue = calculateCurrentValue()
        let totalInvestment = calculateTotalInvestment()
        return currentValue - totalInvestment
    }
    
    private func calculateTodayPNL() -> Double {
        // Simulate fetching data from holdings
        let holding = getHolding(forIndexpath: 0)
        return (holding.closePrice - holding.lastTradedPrice) * Double(holding.quantity)
    }
    
    func getPortfolio() -> Portfolio? {
        // Implement this method as required
        return nil
    }
}

class MockPortfolioViewModelTests: XCTestCase {
    var sut: MockPortfolioViewModel!

    override func setUp() {
        super.setUp()
        sut = MockPortfolioViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetCalculatedTotalInvestmentDetails() {
        let details = sut.getCalculatedTotalInvestmentDetails()
        XCTAssertEqual(details.totalCurrentValue, 16000)
        XCTAssertEqual(details.totalInvestment, 15000)
        XCTAssertEqual(details.totalProfitAndLoss, 1000)
        XCTAssertEqual(details.todaysTotalProfitAndLoss, -500)
    }
}
