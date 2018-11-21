//
//  ViewController.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/21/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import UIKit
import MiniNe

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = MiniNeClient()
        let request = ProductRequest()
        
        client.send(request: request) { (result) in
            switch result {
            case .success(let response):
                
                do {
                    let productsResponse = try JSONDecoder().decode([Product].self, from: response.data)
                    
                    print(productsResponse)
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
