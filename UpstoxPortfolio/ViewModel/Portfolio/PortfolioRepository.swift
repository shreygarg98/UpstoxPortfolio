//
//  PortfolioRepository.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import Foundation


protocol PortfolioRepositoryProtocol {
    func fetchPortfolio(completion: @escaping (Result<Portfolio, Error>) -> Void)
}

class PortfolioRepository: PortfolioRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchPortfolio(completion: @escaping (Result<Portfolio, Error>) -> Void) {
        guard let url = URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        networkManager.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let items = try JSONDecoder().decode(PortfolioResponse.self, from: data)
                    if !items.data.userHolding.isEmpty {
                        completion(.success(items.data))
                    }else{
                        completion(.failure(NetworkError.noData))
                    }
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(_):
                completion(.failure(NetworkError.unKnownError))
            }
        }
    }
}
