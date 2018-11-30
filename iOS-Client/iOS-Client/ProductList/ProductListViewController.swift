//
//  ProductListViewController.swift
//  iOS-Client
//
//  Created by Kevin Chen on 11/21/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import UIKit
import MiniNe

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let client = MiniNeClient()
        let request = ProductRequest()
        
        client.send(request: request) { (result) in
            switch result {
            case .success(let response):
                
                do {
                    let productsResponse = try JSONDecoder().decode([Product].self, from: response.data)
                    
                    self.products = productsResponse
                    
                    Thread.performOnMain {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Table View DataSource
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath) as? ProductListViewCell else {
            
            return UITableViewCell()
        }
        
        cell.title.text = products[indexPath.row].title
        
        return cell
    }
}

// MARK: - Table View Delegate
extension ProductListViewController: UITableViewDelegate {
    
}

extension ProductListViewController: StoryboardInitializable {
    static var storyboardName: String {
        return "Main"
    }
}
