//
//  CustomTimer.swift
//  AmazonPriceScraper
//
//  Created by Kevin Chen on 11/17/18.
//

import Dispatch

public final class CustomTimer {
    public static let shared = CustomTimer()
    
    private var timer: DispatchSourceTimer?
    
    public func startTimer(interval: Double, initialFireDelay: Double, repeats: Bool = true, action: @escaping () -> Void) {
        let queue = DispatchQueue(label: "com.domain.app.timer")
        
        stopTimer()
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() + initialFireDelay, repeating: interval, leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            action()
            if !repeats {
                self?.stopTimer()
            }
        }
        timer?.resume()
    }
    
    public func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}
