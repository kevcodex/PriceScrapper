import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {

    guard let client = try? app.client() else {
        return
    }
    
    let urlStrings =
        ["https://www.amazon.com/Rosewill-Computer-Tempered-Liquid-Cooling-Pre-Installed/dp/B01M6TV6PC",
         "https://www.amazon.com/Samsung-Inch-Internal-MZ-76E1T0B-AM/dp/B078DPCY3T",
         "https://www.amazon.com/GIGABYTE-Z370-AORUS-Gaming-Motherboard/dp/B075KFX627"]
    
    var urls: [URL] = []
    
    for urlString in urlStrings {
        if let url = urlString.convertToURL() {
            urls.append(url)
        }
    }
    
    guard !urls.isEmpty else {
        return
    }
    
//    let test = ScrapperController(client: client, urls: urls)
//    test.start(interval: 10800.0)
}
