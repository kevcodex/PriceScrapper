//
//  StoryboardInitializable.swift
//  FOXNOW
//
//  Created by Alejandro Cárdenas on 9/8/17.
//
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle? { get }
    static var storyboardIdentifier: String { get }
    static func makeFromStoryboard() -> Self
}

extension StoryboardInitializable {
    
    static var storyboardBundle: Bundle? {
        return nil
    }
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func makeFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("No view controller with identifier \(storyboardIdentifier) in storyboard")
        }

        return viewController
    }
}
