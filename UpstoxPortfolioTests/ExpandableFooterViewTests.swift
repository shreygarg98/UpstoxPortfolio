//
//  ExpandableFooterViewTests.swift
//  UpstoxPortfolioTests
//
//  Created by Shrey Garg on 16/05/24.
//

import XCTest
@testable import UpstoxPortfolio

final class ExpandableFooterViewTests: XCTestCase {
        var sut: ExpandableFooterView!
        
        override func setUpWithError() throws {
            try super.setUpWithError()
            sut = ExpandableFooterView()
        }

        override func tearDownWithError() throws {
            sut = nil
            try super.tearDownWithError()
        }
        
        func testStackViewElementsAdded() throws {
        
            sut.setStackViewElements(data: CalculatedTotalInvestmentDetails(totalCurrentValue: 1000, totalInvestment: 800, totalProfitAndLoss: 200, todaysTotalProfitAndLoss: 50))
            
            XCTAssertEqual(sut.stackView.arrangedSubviews.count, 4)
        }
        
        func testExpandCollapseAction() throws {
            // Test the expand/collapse action
            sut.setStackViewElements(data: CalculatedTotalInvestmentDetails(totalCurrentValue: 1000, totalInvestment: 800, totalProfitAndLoss: 200, todaysTotalProfitAndLoss: 50))
            
            // Initial state
            XCTAssertFalse(sut.isExpanded)
            XCTAssertEqual(sut.views.filter { !$0.isHidden }.count, 1) // Only the last detail view is visible
            
            // Expand
            sut.expandCollapseButtonTapped(UIButton())
            XCTAssertTrue(sut.isExpanded)
            XCTAssertEqual(sut.views.filter { !$0.isHidden }.count, sut.views.count) // All detail views are visible
            
            // Collapse
            sut.expandCollapseButtonTapped(UIButton())
            XCTAssertFalse(sut.isExpanded)
            XCTAssertEqual(sut.views.filter { !$0.isHidden }.count, 1) // Only the last detail view is visible again
        }
    }
