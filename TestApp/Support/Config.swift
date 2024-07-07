//
//  Config.swift
//  TestApp
//
//  Created by Sergey Gusev on 07.07.2024.
//

import Foundation

struct Config {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plistFile = FileManager.default.contents(atPath: path),
              let plist = try? PropertyListSerialization.propertyList(from: plistFile, format: nil) as? [String: Any],
              let apiKey = plist["PexelsAPIKey"] as? String,
              apiKey != "your_api_key" else {
            fatalError("Missing PexelsAPIKey in Config.plist")
        }
        return apiKey
    }
}
