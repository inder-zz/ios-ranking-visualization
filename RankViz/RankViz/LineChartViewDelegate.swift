//
//  LineChartViewDelegate.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/22/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit


//conflated delegate + datsource methods.
protocol LineChartViewDelegate: class {
    
    func getXAxisElementDimensions() -> CGSize
    
    func getYAxisElementDimensions() -> CGSize
    
    func getNumColumns() -> Int
    
    func getNumRows() -> Int
    
    func getYAxisOffset() -> CGFloat
    
    func getXAxisOffset() -> CGFloat
    
    func getYAxisDisplayedElementsRange() -> (Int, Int)
    
    func getXAxisDisplayedElementsRange() -> (Int, Int)
    
    // get the score of the element at the specificed indexes.
    // score should be a number between 0 an 1.
    func getScore(forElementAt elemIdx: Int, forMetric metricIdx: Int) -> Float?
    
    // is the line for the specified rank highlighted?
    func isHighlighted(forRank rank: Int) -> Bool
    
}