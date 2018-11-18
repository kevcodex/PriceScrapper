//
//  CustomTimer.swift
//  AmazonPriceScraper
//
//  Created by Kevin Chen on 11/17/18.
//

import Dispatch

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
