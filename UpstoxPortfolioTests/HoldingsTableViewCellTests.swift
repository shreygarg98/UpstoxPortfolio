//
//  HoldingsTableViewCellTests.swift
//  UpstoxPortfolioTests
//
//  Created by Shrey Garg on 16/05/24.
//

import XCTest
@testable import UpstoxPortfolio

final class HoldingsTableViewCellTests: XCTestCase {
    var cell: HoldingsTableViewCell!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cell = HoldingsTableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    
    override func tearDownWithError() throws {
        cell = nil
        try super.tearDownWithError()
    }
    
    func testSetupCell() {
        let holding = Holding(symbol: "AAPL", quantity: 100, averagePrice: 150.0, lastTradedPrice: 155.0, closePrice: 160.0)
        cell.setupCell(holding: holding)
        
        XCTAssertEqual(cell.nameLabel.text, "AAPL")
        XCTAssertEqual(cell.ltpLabel.attributedText?.string, "LTP:  ₹ 155.00")
        XCTAssertEqual(cell.qtyLabel.attributedText?.string, "Net QTY: 100")
        XCTAssertEqual(cell.pnlLabel.attributedText?.string, "P/L:  ₹ 500.00")
    }
    
    func testLabelsPosition() {
        let nameLabelFrame = cell.nameLabel.frame
        let ltpLabelFrame = cell.ltpLabel.frame
        let qtyLabelFrame = cell.qtyLabel.frame
        let pnlLabelFrame = cell.pnlLabel.frame
        
        // Assert the positions of labels
        XCTAssert(nameLabelFrame.minX >= cell.contentView.frame.minX - 16)
        XCTAssert(nameLabelFrame.minY >= cell.contentView.frame.minY - 20)
        
        XCTAssert(ltpLabelFrame.maxX <= cell.contentView.frame.maxX - 16)
        XCTAssert(ltpLabelFrame.minY >= cell.contentView.frame.minY - 20)
        
        XCTAssert(qtyLabelFrame.minX >= cell.contentView.frame.minX - 16)
        XCTAssert(qtyLabelFrame.minY >= nameLabelFrame.maxY - 20)
        XCTAssert(qtyLabelFrame.maxY <= cell.contentView.frame.maxY - 20)
        
        XCTAssert(pnlLabelFrame.maxX <= cell.contentView.frame.maxX - 16)
        XCTAssert(pnlLabelFrame.minY >= qtyLabelFrame.minY)
        XCTAssert(pnlLabelFrame.maxY <= qtyLabelFrame.maxY)
    }
}
