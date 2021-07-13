//
//  ChartFormatter.swift
//  Weather
//
//  Created by Mihail on 13.07.2021.
//

import Foundation
import Charts

public class ChartFormatter: NSObject, IAxisValueFormatter {
    
    var mValues = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return mValues[Int(value)]
    }
    
    public func setValues(entries: [CLong]) {
        let dateFormatter = DateFormatter()
        if Settings.time == 2 {
            dateFormatter.dateFormat = "hh:mm"
        } else {
            dateFormatter.dateFormat = "HH:mm"
        }
        
        var strings = [String]()
        entries.forEach { item in
            strings.append(dateFormatter.string(from: Date(timeIntervalSince1970: Double(item))))
        }
        self.mValues = strings
    }
}
