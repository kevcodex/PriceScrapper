import Vapor
import Dispatch
import Kanna
import Fluent

/// Called after your application has initialized.
public func boot(_ app: Application) throws {

    CustomTimer.shared.startTimer(interval: 10.0) {
        
        guard let client = try? app.client() else {
            return
        }
        
        let urlString = "https://www.amazon.com/Intel-i7-8700K-Processor-Unlocked-BX80684i78700K/dp/B07598VZR8?th=1"
        
        let url = urlString.convertToURL()
        
        let futureResponse = client.get(urlString)
        
        futureResponse.do { (response) in
            
            switch response.http.status.code {
            case 400...499:
                return
            default:
                break
            }
            let string = response.http.body.description
            
            let html = try! HTML(html: string, encoding: .utf8)
            
            
            if let amazonPrice = getFirstText(from: html, with: "//*[@id = 'priceblock_ourprice']") {
                
                let asin = url?.pathComponents.safe(index: 3) ?? ""
                let title = getFirstText(from: html, with: "//*[@id='productTitle']")?.replacingOccurrences(of: "\n", with: "") ?? ""
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
                }).catch({ (error) in
                    print(error)
                })
            }
        }.catch({ (error) in
            print(error)
        })
    }
}


func getFirstText(from html: HTMLDocument, with path: String) -> String? {
    
    var text: String?
    for node in html.xpath(path) {
        text = node.text
        break
    }
    
    return text
}

final class CustomTimer {
    static let shared = CustomTimer()
    
    private var timer: DispatchSourceTimer?
    
    func startTimer(interval: Double, repeats: Bool = true, action: @escaping () -> Void) {
        let queue = DispatchQueue(label: "com.domain.app.timer")
        
        stopTimer()
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() + interval, repeating: interval, leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            action()
            if !repeats {
                self?.stopTimer()
            }
        }
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}


// MARK: - Support collection index boundary check.
extension Collection {
    private subscript(safe index: Index) -> Iterator.Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            assertionFailure("Index \(index) out of boundary")
            return nil
        }
    }
    
    /// A safe function to get element of Collection at index path.
    ///
    /// - Parameter index: Index of element in a collection.
    /// - Returns: Element at a given index. If an index is out of boundary of a collection it will return nil and an assertionFailure.
    func safe(index: Index) -> Iterator.Element? {
        return self[safe: index]
    }
}
