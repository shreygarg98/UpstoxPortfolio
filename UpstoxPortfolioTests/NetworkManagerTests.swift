//
//  NetworkManagerTests.swift
//  UpstoxPortfolioTests
//
//  Created by Shrey Garg on 16/05/24.
//

import XCTest
@testable import UpstoxPortfolio

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManagerProtocol!

    override func setUpWithError() throws {
        networkManager = NetworkManager()
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }

    func testFetchDataSuccess() throws {
        // Given
        let expectation = self.expectation(description: "Data is fetched successfully")
        let url = URL(string: "https://example.com")!
        
        // When
        networkManager.fetchData(from: url) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetching data failed with error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchDataFailure() throws {
        // Given
        let expectation = self.expectation(description: "Data fetch failed")
        let invalidURL = URL(string: "invalid-url")! // An invalid URL
        
        // When
        networkManager.fetchData(from: invalidURL) { result in
            // Then
            switch result {
            case .success(_):
                XCTFail("Fetching data succeeded when it was supposed to fail")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
