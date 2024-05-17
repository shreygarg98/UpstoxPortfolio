//
//  NetworkManager.swift
//  UpstoxPortfolio
//
//  Created by Shrey Garg on 16/05/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case unKnownError
}
