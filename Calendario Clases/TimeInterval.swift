//
//  TimeInterval.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 23/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//

import Foundation

struct Time {
    
    let start: NSTimeInterval
    let end: NSTimeInterval
    let interval: NSTimeInterval
    
    init(start: NSTimeInterval, interval: NSTimeInterval, end: NSTimeInterval) {
        self.start = start
        self.interval = interval
        self.end = end
    }
    
    init(startHour: NSTimeInterval, intervalMinutes: NSTimeInterval, endHour: NSTimeInterval) {
        self.start = startHour * 60 * 60
        self.end = endHour * 60 * 60
        self.interval = intervalMinutes * 60
    }
    
    var timeRepresentations: [String] {
        let dateComponentFormatter = NSDateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .Positional
        dateComponentFormatter.allowedUnits = [.Minute, .Hour]
        
        let dateComponent = NSDateComponents()
        return timeIntervals.map { timeInterval in
            dateComponent.second = Int(timeInterval)
            return dateComponentFormatter.stringFromDateComponents(dateComponent)!
        }
    }
    
    var timeIntervals: [NSTimeInterval]{
        return Array(start.stride(through: end, by: interval))
    }
}

