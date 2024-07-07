//
//  PexelsService.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import Foundation
import Combine

protocol PexelsServiceProtocol {
    func fetchCuratedPhotos(page: Int, perPage: Int) -> AnyPublisher<PexelsResponse, Error>
}

class PexelsService: PexelsServiceProtocol {
    private let baseURL = "https://api.pexels.com/v1/curated"
    
    func fetchCuratedPhotos(page: Int, perPage: Int) -> AnyPublisher<PexelsResponse, Error> {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue(Config.apiKey, forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: PexelsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
