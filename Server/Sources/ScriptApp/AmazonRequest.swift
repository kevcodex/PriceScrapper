//
//  AmazonRequest.swift
//  ScriptApp
//
//  Created by Kevin Chen on 12/23/18.
//

import MiniNe
import Foundation

struct AmazonRequest: NetworkRequest {
    var baseURL: URL?
    
    var path: String
    
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

extension AmazonRequest {
    var fullURL: URL? {
        return baseURL?.appendingPathComponent(path)
    }
}
