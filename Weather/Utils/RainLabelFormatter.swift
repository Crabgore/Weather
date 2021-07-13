//
//  RainLabelFormatter.swift
//  Weather
//
//  Created by Mihail on 13.07.2021.
//

import Foundation
import Charts

public class RainLabelFormatter: NSObject, IValueFormatter {
    
    var mValues = [String]()
    
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.0f", value) + "%"
    }
}
