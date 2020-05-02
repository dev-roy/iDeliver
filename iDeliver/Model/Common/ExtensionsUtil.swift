//
//  ExtensionsUtil.swift
//  iDeliver
//
//  Created by Field Employee on 4/7/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

extension UIColor {
    static func randomGreen() -> UIColor {
        return UIColor(red:   .random(in: 0...0.48),
                       green: .random(in: 0.5...0.7),
                       blue:  .random(in: 0.25...0.48),
                       alpha: 1.0)
    }
}

extension Date {
    static func randomDateRange() -> (start: Date, end: Date) {
        let startDays = Int(arc4random_uniform(60)) + 1 + Calendar.current.ordinality(of: .day, in: .year, for: Date())!
        let endDays = Int(arc4random_uniform(60)) + 1 + startDays
        var dc = DateComponents()
        dc.day = Int(startDays)
        let start = Calendar.current.date(from: dc)
        dc.day = Int(endDays)
        let end = Calendar.current.date(from: dc)
        return (start: start!, end: end!)
    }
    
    static func generateRandomDateRange(format: String, withFormat dateFormatter: DateFormatter) -> String {
        let range = Self.randomDateRange()
        let startDate = dateFormatter.string(from: range.start)
        let endDate = dateFormatter.string(from: range.end)
        return String(format: format, startDate, endDate)
    }
}
