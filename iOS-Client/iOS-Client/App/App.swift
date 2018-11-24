//
//  App.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/23/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import Foundation

enum App {
    static let APIBaseURL: String? = {
        guard let baseURL = Bundle.main.infoDictionary?["API_ENDPOINT"] as? String else {
            assertionFailure("API_ENDPOINT is missing from the Info.plist file")
            return nil
        }
        
        return baseURL
    }()
}
