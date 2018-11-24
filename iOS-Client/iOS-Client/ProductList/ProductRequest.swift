//
//  ProductRequest.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/21/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import Foundation
import MiniNe

struct ProductRequest: NetworkRequest {
    var baseURL: URL? {
        
        guard let baseURLString = App.APIBaseURL else {
            return nil
        }
        
        return URL(string: baseURLString)
    }
    
    var path: String {
        return "/products"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: [String : Any]? {
        return nil
    }
}
