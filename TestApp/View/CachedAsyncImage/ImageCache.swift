//
//  ImageCache.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private lazy var cacheDirectory: URL = {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[0]
    }()
    
    func getImage(forKey key: String) -> UIImage? {
        if let image = memoryCache.object(forKey: key as NSString) {
            return image
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }

    func setImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error clearing disk cache: \(error.localizedDescription)")
        }
    }
}
