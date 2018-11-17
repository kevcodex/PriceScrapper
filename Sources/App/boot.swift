import Vapor
import Dispatch
import Kanna

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    
    CustomTimer.shared.startTimer(interval: 10000.0) {
        let client = try! app.client()
        
        let futureResponse = client.get("https://www.amazon.com/Rosewill-Computer-Tempered-Liquid-Cooling-Pre-Installed/dp/B01M6TV6PC/ref=sr_1_3?s=electronics&ie=UTF8&qid=1542257898&sr=1-3&keywords=gaming+case")
        
        futureResponse.do { (response) in
            let string = response.description
            
            let html = try! HTML(html: string, encoding: .utf8)
            if let amazonPrice = getText(from: html, with: "//span[@id = 'priceblock_ourprice']") {
                
                let id = 10000
                let event = Event(price: amazonPrice, date: Int(Date().timeIntervalSince1970))
                let product = Product(id: id, title: "tester", priceHistory: [event])
                
                let request = response.makeRequest()
                
                let test = Product.find(id, on: request)
                test.do({ (foundProduct) in
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

func getText(from html: HTMLDocument, with path: String) -> String? {
    
    var text: String?
    for node in html.xpath(path) {
        text = node.text
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
