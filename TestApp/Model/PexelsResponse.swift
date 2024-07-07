//
//  PexelsResponse.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

struct PexelsResponse: Codable {
    let photos: [Photo]
    let page: Int
    let perPage: Int
    let totalResults: Int
    let nextPage: String?
    let prevPage: String?
    
    enum CodingKeys: String, CodingKey {
        case photos, page, perPage = "per_page", totalResults = "total_results", nextPage = "next_page", prevPage = "prev_page"
    }
}
