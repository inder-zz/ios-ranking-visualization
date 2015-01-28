//
//  SimpleTableViewCell.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/21/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit


class SimpleTableViewCell: UIView {
    
    var highlightWidth: CGFloat = 10.0 {
        didSet {
            if (highlightBorders) {
                self.setNeedsDisplay()
            }
        }
    }
    
    var highlightColor : UIColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1.0) {
        didSet {
            if (highlightBorders) {
                self.setNeedsDisplay()
            }
        }
    }
    
    var highlightBorders : Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var index: Int = 0
    
    func toggleHighlight() {
        highlightBorders = !highlightBorders
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if (highlightBorders) {
            var path = UIBezierPath(rect: self.bounds)
            highlightColor.setStroke()
            path.lineWidth = highlightWidth
            UIColor.clearColor().setFill()
            path.stroke()
        }
    }
}