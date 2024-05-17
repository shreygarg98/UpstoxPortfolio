//
//  MockPortfolioRepository.swift
//  UpstoxPortfolioTests
//
//  Created by Shrey Garg on 16/05/24.
//

import XCTest
@testable import UpstoxPortfolio

class MockPortfolioRepository: PortfolioRepositoryProtocol {
    var portfolioToReturn: Result<Portfolio, Error>?
    
    func fetchPortfolio(completion: @escaping (Result<Portfolio, Error>) -> Void) {
        if let result = portfolioToReturn {
            completion(result)
        }
    }
}

class PortfolioRepositoryTests: XCTestCase {

    class MockNetworkManager: NetworkManagerProtocol {
        var fetchDataCompletion: ((Result<Data, Error>) -> Void)?
        
        func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            fetchDataCompletion = completion
        }
    }

    var sut: PortfolioRepository!
    var mockNetworkManager: MockNetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockNetworkManager = MockNetworkManager()
        sut = PortfolioRepository(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockNetworkManager = nil
        try super.tearDownWithError()
    }

    func testFetchPortfolioSuccess() throws {
        
        let expectation = self.expectation(description: "Fetch portfolio completion")

        sut.fetchPortfolio { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        let dummyData = """
            {
                "data": {
                    "userHolding": [
                        {
                            "symbol": "AAPL",
                            "quantity": 100,
                            "avgPrice": 150.0,
                            "ltp": 155.0,
                            "close": 160.0
                        }
                    ]
                }
            }
            """.data(using: .utf8)!

        mockNetworkManager.fetchDataCompletion?(.success(dummyData))

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchPortfolioFailure() throws {
        let expectation = self.expectation(description: "Fetch portfolio completion")

        sut.fetchPortfolio { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.unKnownError)
            }

            expectation.fulfill()
        }

        mockNetworkManager.fetchDataCompletion?(.failure(NetworkError.unKnownError))

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
