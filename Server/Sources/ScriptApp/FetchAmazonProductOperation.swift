//
//  FetchAmazonProductOperation.swift
//  ScriptApp
//
//  Created by Kevin Chen on 12/25/18.
//

import Foundation
import MiniNe
import ScriptHelpers
import Kanna
import Common

class FetchAmazonProductOperation: AsyncOperation {
    
    private let request: AmazonRequest
    
    private let client = MiniNeClient()
    
    
    init(request: AmazonRequest) {
        self.request = request
        super.init()
    }
    
    convenience init(baseURLString: String, pathString: String) {
        let request = AmazonRequest(baseURL: URL(string: baseURLString), path: pathString)
        self.init(request: request)
    }
    
    // Outputs
    var result: Result<Product, ScrapperError>? {
        didSet {
            self.finish()
        }
    }
    
    override func execute() {
        
        guard let fullURL = request.fullURL else {
            result = Result(error: .invalidURL)
            return
        }
        
        client.send(request: request) { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                
            case .success(let response):
                
                guard let html = try? HTML(html: response.data, encoding: .utf8) else {
                    return
                }
                
                let asin = fullURL.pathComponents.safe(index: 3) ?? ""
                let title = strongSelf.getFirstText(from: html, with: "//*[@id='productTitle']")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                
                let strikeThroughPrice = strongSelf.getFirstText(from: html, with: "//span[@class = 'a-text-strike']") ?? ""
                let amazonPrice = strongSelf.getFirstText(from: html, with: "//*[@id = 'priceblock_ourprice']") ?? ""
                let dealPrice = strongSelf.getFirstText(from: html, with: "//span[@id = 'priceblock_dealprice']") ?? ""
                
                let lowestPrice = strongSelf.lowestPrice(from: [strikeThroughPrice, amazonPrice, dealPrice])
                
                let event = Event(price: lowestPrice, date: Int(Date().timeIntervalSince1970))
                let product = Product(asin: asin, title: title, url: fullURL.absoluteString, priceHistory: [event])
            
                strongSelf.result = Result(value: product)
                
            case .failure(let error):
                let message = error.localizedDescription
                print(message)
                strongSelf.result = Result(error: .networkError(message: message))
            }
        }
    }
    
    /// Get the lowest price from a list of string array with format $4.99
    private func lowestPrice(from stringArray: [String]) -> String {
        
        let nonEmptyArray = stringArray.filter { !$0.isEmpty }
        
        let arrayAsDouble = nonEmptyArray.compactMap { Double($0.replacingOccurrences(of: "$", with: "")) }
        
        if let minValue = arrayAsDouble.min() {
            return String(minValue)
        } else {
            return ""
        }
    }
    
    private func getFirstText(from html: HTMLDocument, with path: String) -> String? {
        
        var text: String?
        for node in html.xpath(path) {
            text = node.text
            break
        }
        
        return text
    }
}
