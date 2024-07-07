//
//  Photo.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

struct Photo: Codable, Identifiable, Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let width: Int
    let height: Int
    let url: String
    let photographer: String
    let src: PhotoSource
    
    struct PhotoSource: Codable {
        let original: String
        let medium: String
    }
}
