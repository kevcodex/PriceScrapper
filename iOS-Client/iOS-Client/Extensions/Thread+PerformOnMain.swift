//
//  Thread+PerformOnMain.swift
//  iOS-Client
//
//  Created by Kirby on 11/29/18.
//  Copyright © 2018 Kevin Chen. All rights reserved.
//

import Foundation

extension Thread {
    static func performOnMain(block: () -> Void) {
        if isMainThread {
            block()
        } else {
            DispatchQueue.main.sync {
                block()
            }
        }
    }
}
