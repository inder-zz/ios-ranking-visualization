//
//  EquityRowHeaderView.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/21/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

// A row header view for displaying equity information.
class EquityRowHeaderView : UIView {
    
    let StdHeight: CGFloat = 110.0
    let StdWidth: CGFloat = 56.0
    
    let tickerFontColor = UIColor(red: 51.0/255, green: 51.0/255, blue: 51.0/255, alpha: 1.0)
    let priceFontColor = UIColor(red: 0, green: 128.0/255, blue: 0, alpha: 1.0)
    let bandColor = UIColor(red: 43.0/255, green: 63.0/255, blue: 86.0/255, alpha: 1.0)
    
    // MARK: - scaled offsets and sizes
    var xOffset : CGFloat {
        return (6 * self.bounds.width)/StdHeight
    }
    
    var yOffset : CGFloat {
        return (4 * self.bounds.height)/StdWidth
    }
    
    var tickerFontSize : CGFloat {
        return (15 * self.bounds.height)/StdWidth
    }
    
    var nameFontSize : CGFloat {
        return (8 * self.bounds.height)/StdWidth
    }
    
    var priceFontSize : CGFloat {
        return (13 * self.bounds.height)/StdWidth
    }
    
    var companyNameFontSize : CGFloat {
        return (10 * self.bounds.height)/StdWidth
    }
    
    override var backgroundColor : UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var equity: Equity? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    

    
    // MARK: - setup and init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK : - drawing.
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        var path = UIBezierPath(rect: self.bounds)
        UIColor.whiteColor().setFill()
        path.addClip()
        path.fill()
    
        var tickerName: NSMutableAttributedString
        var price: NSAttributedString
        var longName: NSAttributedString
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Left
        
        
        let tickerFont = UIFont(name: "AvenirNext-Bold", size: self.tickerFontSize)
        let priceFont = UIFont(name: "AvenirNext-Medium", size: priceFontSize)
        let companyNameFont = UIFont(name: "AvenirNextCondensed-Medium", size: companyNameFontSize)
        
        if let equity = self.equity {
            var attributes : [NSString: AnyObject] = [NSFontAttributeName : tickerFont!, NSParagraphStyleAttributeName : paragraphStyle]

            var tickerString = NSMutableAttributedString(string: equity.symbol, attributes: attributes)
            var textBounds : CGRect = CGRect()
            textBounds.origin = CGPointMake(self.xOffset, self.yOffset)
            textBounds.size = tickerString.size()
            tickerString.addAttribute(NSForegroundColorAttributeName, value: tickerFontColor, range: NSMakeRange(0, countElements(equity.symbol)))
            tickerString.drawAtPoint(textBounds.origin)
            
            if let price = equity.price {
                paragraphStyle.alignment = NSTextAlignment.Right
                var attributes2: [NSString: AnyObject] = [NSFontAttributeName : priceFont!, NSParagraphStyleAttributeName : paragraphStyle]
                var priceAsString = "\(price)"
                var priceString = NSMutableAttributedString(string: priceAsString, attributes: attributes2)
                textBounds  = CGRect()
                textBounds.origin = CGPointMake(self.bounds.width - priceString.size().width - 2*self.xOffset, self.yOffset)
                textBounds.size = priceString.size()
                priceString.addAttribute(NSForegroundColorAttributeName, value: priceFontColor, range: NSMakeRange(0, countElements(priceAsString)))
                priceString.drawAtPoint(textBounds.origin)
            }

            paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            paragraphStyle.alignment = NSTextAlignment.Left
            attributes = [NSFontAttributeName : companyNameFont!, NSParagraphStyleAttributeName : paragraphStyle]
            var companyNameString = NSMutableAttributedString(string: equity.companyName, attributes: attributes)
            textBounds  = CGRect()
            textBounds.origin = CGPointMake(self.xOffset, self.yOffset + tickerString.size().height)
            textBounds.size = CGSizeMake(self.bounds.width*0.5, self.bounds.height - tickerString.size().height - self.yOffset)
            companyNameString.addAttribute(NSForegroundColorAttributeName, value: tickerFontColor, range: NSMakeRange(0, countElements(equity.companyName)))
            companyNameString.drawInRect(textBounds)
        
        }

        //draw the band on the side
        path = UIBezierPath()
        bandColor.setStroke()
        path.moveToPoint(CGPoint(x: self.bounds.width - 2, y: 0))
        path.addLineToPoint(CGPoint(x: self.bounds.width - 2, y: self.bounds.height))
        path.lineWidth = 4
        path.stroke()

        //draw the separator line
        path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: self.bounds.height - 1))
        path.addLineToPoint(CGPoint(x: self.bounds.width, y: self.bounds.height - 1))
        path.lineWidth = 0.5
        UIColor.grayColor().setStroke()
        path.stroke()
    }
    
}