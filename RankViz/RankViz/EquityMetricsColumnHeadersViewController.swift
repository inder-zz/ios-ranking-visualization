//
//  EquityMetricsColumnHeadersViewController.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/22/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class EquityMetricsColumnHeadersViewController : SimpleBidirectionalTableViewController, SimpleBidirectionalTableViewDelegate {
    
    var portfolio: Portfolio = CustomPortfolios.sharedInstance.portfolios[0]
    var columnHeaderDimensions: CGSize!
    weak var controller: LineChartVizViewController?
    
    init(portfolio: Portfolio, headerDimensions: CGSize) {
        self.portfolio = portfolio
        self.columnHeaderDimensions = headerDimensions
        super.init(direction: .Horizontal)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        self.view.clipsToBounds = true
        self.tableView.tableViewDelegate = self
    }
    
    func numberOfCells(source: SimpleBidirectionalTableView) -> Int {
        return self.portfolio.interestedMetrics.count + 1
    }
    
    func heightOfCells(source: SimpleBidirectionalTableView) -> CGFloat {
        return self.columnHeaderDimensions.height
    }
    
    func widthOfCells(source: SimpleBidirectionalTableView) -> CGFloat {
        return self.columnHeaderDimensions.width
    }
    
    func viewForCell(atIndex idx: Int, source: SimpleBidirectionalTableView) -> UIView? {
        if (idx > portfolio.interestedMetrics.count) {
            return nil
        }
        
        var view = MetricCellView(frame: CGRectMake(0, 0, columnHeaderDimensions.width, columnHeaderDimensions.height))
        
        if (idx == 0) {
            var rankMeta = MetricMetaInformation(name: "Rank", importance: 0, isHigherBetter: nil)
            view.metric = rankMeta
        }
        else {
            var metric = portfolio.interestedMetricTypes[idx - 1]
            view.metric = metric
        }
        return view
    }
    
    func didShowCellsInRange(fromStartIdx startIdx: Int, toEndIndex endIdx: Int, withStartOffset startOffset: CGFloat, source: SimpleBidirectionalTableView)
    {
        controller?.didXShowCellsInRange(fromStartIdx: startIdx, toEndIndex: endIdx, withStartOffset: startOffset, source: source)
    }
    
    
}

class MetricCellView : UIView {
    
    //the std height and width based on which scaling factors are calculated.
    let StdHeight: CGFloat = 120
    let StdWidth = CGFloat(40)
    
    let bandColor = UIColor(red: 43.0/255, green: 63.0/255, blue: 86.0/255, alpha: 1.0)
    let smallBandColor = UIColor(red: 102.0/255, green: 204.0/244, blue: 255.0/255, alpha: 1.0)
    
    // MARK: - scaled offsets and sizes
    var xOffset : CGFloat {
        return (6 * self.bounds.width)/StdHeight
    }
    
    var yOffset : CGFloat {
        return (4 * self.bounds.height)/StdWidth
    }
    
    var tickerFontSize : CGFloat {
        return (14 * self.bounds.height)/StdWidth
    }
    
    var nameFontSize : CGFloat {
        return (8 * self.bounds.height)/StdWidth
    }
    
    var priceFontSize : CGFloat {
        return (12 * self.bounds.height)/StdWidth
    }
    
    override var backgroundColor : UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var metric: MetricMetaInformation? {
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
        if let metric = self.metric {
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.Center
            
            var tickerFont = UIFont(name: "HelveticaNeue-CondensedBold", size: tickerFontSize)
            var attributes : [NSString: AnyObject] = [NSFontAttributeName : tickerFont!, NSParagraphStyleAttributeName : paragraphStyle]
            
            var tickerString = NSMutableAttributedString(string: metric.name.uppercaseString, attributes: attributes)
            var textBounds : CGRect = CGRect()
            textBounds.origin = CGPointMake(self.xOffset, 2*self.yOffset)
            textBounds.size = CGSizeMake(self.bounds.width - 2*self.xOffset, self.bounds.height - 3*self.yOffset)
            tickerString.drawInRect(textBounds)
        }
        
        let bigBandOffset : CGFloat = 2.0
        //draw the separator line
        path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bigBandOffset, y: self.bounds.height - 3))
        path.addLineToPoint(CGPoint(x: self.bounds.width - bigBandOffset, y: self.bounds.height - 3))
        path.lineWidth = 6
        bandColor.setStroke()
        path.stroke()
        
        
        path = UIBezierPath()
        
        if let metric = self.metric {
            let smallBandWidth = self.bounds.width/2 * CGFloat(metric.translatedWeight)
            path = UIBezierPath()
            path.moveToPoint(CGPoint(x: (self.bounds.width - smallBandWidth)/2, y: self.bounds.height - 3))
            path.addLineToPoint(CGPoint(x: (self.bounds.width + smallBandWidth)/2, y: self.bounds.height - 3))
            path.lineWidth = 6
            smallBandColor.setStroke()
            path.stroke()
            
        }
        
    }
    
}