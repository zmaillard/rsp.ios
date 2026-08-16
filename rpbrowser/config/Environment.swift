//
//  Environment.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/16/26.
//
import Foundation

public enum Environment {
    enum Keys {
        static let searchApiKey = "SEARCH_API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        return dict
    }()
    
    static let searchApiKey: String = {
        guard let searchApiKeyString = Environment.infoDictionary[Keys.searchApiKey] as? String else {
            fatalError("SEARCH_API_KEY not found in Info.plist")
        }
        return searchApiKeyString
    }()
}

