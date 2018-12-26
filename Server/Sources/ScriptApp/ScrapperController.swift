//
//  ScrapperController.swift
//  App
//
//  Created by Kevin Chen on 11/17/18.
//

import Kanna
import Fluent
import Common
import MiniNe

enum ScrapperError: Error {
    case invalidURL
    case networkError(message: String)
}

final class ScrapperController {
    
    let requests: [AmazonRequest]

    let operationQueue = OperationQueue()
    
    init(requests: [AmazonRequest]) {
        self.requests = requests
        
        operationQueue.maxConcurrentOperationCount = 5
    }
    
    func retrieveProductsInfo() -> [Product] {
        
        var products: [Product] = []
        
        for request in self.requests {
            let fetchAmazonProductOperation = FetchAmazonProductOperation.init(request: request)
            
            let completionBlock = BlockOperation { [weak fetchAmazonProductOperation] in
                guard let result = fetchAmazonProductOperation?.result else {
                    return
                }
                
                switch result {
                case .success(let product):
                    products.append(product)
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            completionBlock.addDependency(fetchAmazonProductOperation)
            
            operationQueue.addOperations([fetchAmazonProductOperation,
                                        completionBlock],
                                        waitUntilFinished: false)
            
        }
        
        operationQueue.waitUntilAllOperationsAreFinished()
        
        return products
    }
    
    
    
    //    func start(interval: Double) {
    //        CustomTimer.shared.startTimer(interval: interval, initialFireDelay: 20.0) {
    //
    //            for url in self.urls {
    //
    //                let urlString = url.absoluteString
    //                let futureResponse = self.client.get(urlString)
    //
    //                futureResponse.do { (response) in
    //
    //                    switch response.http.status.code {
    //                    case 400...:
    //                        return
    //                    default:
    //                        break
    //                    }
    //                    let string = response.http.body.description
    //
    //                    guard let html = try? HTML(html: string, encoding: .utf8) else {
    //                        return
    //                    }
    //
    //                    let asin = url.pathComponents.safe(index: 3) ?? ""
    //                    let title = self.getFirstText(from: html, with: "//*[@id='productTitle']")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    //
    //                    let strikeThroughPrice = self.getFirstText(from: html, with: "//span[@class = 'a-text-strike']") ?? ""
    //                    let amazonPrice = self.getFirstText(from: html, with: "//*[@id = 'priceblock_ourprice']") ?? ""
    //                    let dealPrice = self.getFirstText(from: html, with: "//span[@id = 'priceblock_dealprice']") ?? ""
    //
    //                    let lowestPrice = self.lowestPrice(from: [strikeThroughPrice, amazonPrice, dealPrice])
    //
    //                    let event = Event(price: lowestPrice, date: Int(Date().timeIntervalSince1970))
    //                    let product = Product(asin: asin, title: title, url: urlString, priceHistory: [event])
    //
    //                    let request = response.makeRequest()
    //
    //                    let futureFoundProduct = Product.query(on: request).filter(\.asin == asin).first()
    //                    futureFoundProduct.do({ (foundProduct) in
    //                        if let foundProduct = foundProduct {
    //                            foundProduct.priceHistory.append(contentsOf: product.priceHistory)
    //
    //                            foundProduct.create(orUpdate: true, on: request).always {
    //                                // Do nothing for now
    //                            }
    //                        } else {
    //                            product.create(orUpdate: true, on: request).always {
    //                                // Do nothing for now
    //                            }
    //                        }
    //                    }).catch { (error) in
    //                        print(error)
    //                    }
    //
    //                    }.catch { (error) in
    //                        print(error)
    //                }
    //            }
    //        }
    //    }
}

