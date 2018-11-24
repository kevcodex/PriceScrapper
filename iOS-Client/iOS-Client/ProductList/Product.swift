//
//  Product.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/21/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import Foundation

struct Product: Codable {
    let asin: String
    let id: Int
    let url: String
    let title: String
}
