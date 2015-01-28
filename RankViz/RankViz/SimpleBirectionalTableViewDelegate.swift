//
//  SimpleBirectionalTableViewDelegate.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/21/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SimpleBidirectionalTableViewDelegate: class {
    func numberOfCells(source: SimpleBidirectionalTableView) -> Int
    
    func heightOfCells(source: SimpleBidirectionalTableView) -> CGFloat
    
    func widthOfCells(source: SimpleBidirectionalTableView) -> CGFloat
    
    func viewForCell(atIndex idx: Int, source: SimpleBidirectionalTableView) -> UIView?
    
    //take some action, if you want to.
    optional func userSelectedCell(atIndex row: Int, cell: UIView, source: SimpleBidirectionalTableView)
    
    //by default highlight the row at given index.
    optional func shouldHighlightCell(atIndex index: Int, source: SimpleBidirectionalTableView) -> Bool
    
    //what should be the color that is used to highlight the header at index.
    optional func highlightColor(atIndex index: Int, source: SimpleBidirectionalTableView) -> UIColor
    
    // color swatch to be used for highlighting
    optional func colorSwatch(source: SimpleBidirectionalTableView) -> [UIColor]
    
    optional func didShowCellsInRange(fromStartIdx startIdx: Int, toEndIndex endIdx: Int, withStartOffset startOffset: CGFloat, source: SimpleBidirectionalTableView)
}