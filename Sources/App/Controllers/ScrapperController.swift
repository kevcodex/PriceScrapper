//
//  ScrapperController.swift
//  App
//
//  Created by Kevin Chen on 11/17/18.
//

import Vapor
import Kanna
import Fluent

final class ScrapperController {
    
    let client: Client
    let urls: [URL]
    
    init(client: Client, urls: [URL]) {
        self.client = client
        self.urls = urls
    }
    
    func start(interval: Double) {
        CustomTimer.shared.startTimer(interval: interval) {
            
            for url in self.urls {
                
                let urlString = url.absoluteString
                let futureResponse = self.client.get(urlString)
                
                futureResponse.do { (response) in
                    
                    switch response.http.status.code {
                    case 400...499:
                        return
                    default:
                        break
                    }
                    let string = response.http.body.description
                    
                    let html = try! HTML(html: string, encoding: .utf8)
                    
                    let asin = url.pathComponents.safe(index: 3) ?? ""
                    let title = self.getFirstText(from: html, with: "//*[@id='productTitle']")?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    let amazonPrice = self.getFirstText(from: html, with: "//*[@id = 'priceblock_ourprice']") ?? ""
                    
                    let event = Event(price: amazonPrice, date: Int(Date().timeIntervalSince1970))
                    let product = Product(asin: asin, title: title, url: urlString, priceHistory: [event])
                    
                    let request = response.makeRequest()
                    
                    
                    let futureFoundProduct = Product.query(on: request).filter(\.asin == asin).first()
                    futureFoundProduct.do({ (foundProduct) in
                        if let foundProduct = foundProduct {
                            foundProduct.priceHistory.append(contentsOf: product.priceHistory)
                            
                            foundProduct.create(orUpdate: true, on: request).always {
                                // Do nothing for now
                            }
                        } else {
                            product.create(orUpdate: true, on: request).always {
                                // Do nothing for now
                            }
                        }
                    }).catch { (error) in
                        print(error)
                    }
                    
                    }.catch { (error) in
                        print(error)
                }
            }
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
