//
//  LineChartVizController.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/21/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class LineChartVizViewController : UIViewController {
    
    var rowHeadersController : SimpleBidirectionalTableViewController!
    var columnHeadersController : SimpleBidirectionalTableViewController!
    var lineChartView : LineChartView!
    var portfolio: Portfolio = CustomPortfolios.sharedInstance.portfolios[0]
    var containerView: UIView!
    
    var rowHeaderDimensions : CGSize = CGSizeMake(110, 56)
    
    var columnHeaderDimensions : CGSize = CGSizeMake(80, 40)
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func loadView() {
        super.loadView()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = portfolio.name
        
        self.containerView = self.view
        
        self.rowHeadersController = ScrollableEquitiesRowHeadersViewController(portfolio: self.portfolio, rowHeaderDimensions: rowHeaderDimensions)
        (self.rowHeadersController as ScrollableEquitiesRowHeadersViewController).controller = self
        
        displayRowHeaders(self.rowHeadersController)
        
        self.columnHeadersController = EquityMetricsColumnHeadersViewController(portfolio: self.portfolio, headerDimensions: columnHeaderDimensions)
        (self.columnHeadersController as EquityMetricsColumnHeadersViewController).controller = self
        displayColumnHeaders(self.columnHeadersController)
        
        
    }

    func displayRowHeaders(child: UIViewController) {
        self.addChildViewController(child)
        child.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addSubview(child.view)
        
        child.didMoveToParentViewController(self)
        
        let viewsDict: [String: AnyObject] = ["childView" : child.view, "topGuide" : self.topLayoutGuide, "bottomGuide": self.bottomLayoutGuide]
        
        containerView.addVisualConstraint("H:|-0-[childView(==\(rowHeaderDimensions.width))]", viewsDict: viewsDict)
        containerView.addVisualConstraint("V:[topGuide]-\(columnHeaderDimensions.height)-[childView]-[bottomGuide]", viewsDict: viewsDict)

    }
    
    func displayColumnHeaders(childVC: UIViewController) {
        self.addChildViewController(childVC)
        childVC.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        containerView.addSubview(childVC.view)
        
        childVC.didMoveToParentViewController(self)
        
        let viewsDict: [String: AnyObject] = ["childView" : childVC.view, "topGuide" : self.topLayoutGuide, "bottomGuide": self.bottomLayoutGuide]
        
        containerView.addVisualConstraint("H:|-\(rowHeaderDimensions.width )-[childView]|", viewsDict: viewsDict)
        containerView.addVisualConstraint("V:[topGuide]-0-[childView(==\(columnHeaderDimensions.height))]", viewsDict: viewsDict)

    }
    
    func displayLineChartView() {
        self.lineChartView = LineChartView(frame: CGRectMake(rowHeaderDimensions.width, columnHeaderDimensions.height + self.topLayoutGuide.length, columnHeaderDimensions.width * CGFloat(portfolio.interestedMetrics.count + 1), rowHeadersController.view.bounds.height), delegate: PortfolioLineChartViewDelegate(outer: self))
        
        containerView.addSubview(lineChartView)
    }
    
    override func viewDidLayoutSubviews() {
        //this is done here, as we need the bounds to be set for the chart to be displayed within the bounds.
        if self.lineChartView != nil {
            self.lineChartView!.removeFromSuperview()
        }
        
        displayLineChartView()
        self.lineChartView.setNeedsDisplay()
        self.lineChartView.refreshLayers()
    }
    
    var yOffset: CGFloat = 0.0
    var startIdx: Int = 0
    var endIndx: Int = 0
    
    func didShowCellsInRange(fromStartIdx startIdx: Int, toEndIndex endIdx: Int, withStartOffset startOffset: CGFloat, source: SimpleBidirectionalTableView) {
        self.yOffset = startOffset
        self.startIdx = startIdx
        self.endIndx = endIdx

        if (lineChartView != nil) {
            lineChartView.setup()
        }
    }
    
    var xOffset: CGFloat = 0.0
    var xStartIdx: Int = 0
    var xEndIdx: Int = 0
    
    func didXShowCellsInRange(fromStartIdx startIdx: Int, toEndIndex endIdx: Int, withStartOffset startOffset: CGFloat, source: SimpleBidirectionalTableView) {
        self.xOffset = startOffset
        self.xStartIdx = startIdx
        self.xEndIdx = endIdx

        lineChartView.setup()
        lineChartView.setNeedsDisplay()
    }
    
    class PortfolioLineChartViewDelegate : LineChartViewDelegate {
        
        weak var outer: LineChartVizViewController!
        
        init(outer: LineChartVizViewController) {
            self.outer = outer
        }
        
        func getXAxisElementDimensions() -> CGSize
        {
            return CGSizeMake(outer.columnHeaderDimensions.width, outer.rowHeaderDimensions.height)
            
            //return outer.rowHeaderDimensions
        }
        func getYAxisElementDimensions() -> CGSize
        {
            return getXAxisElementDimensions()
        }
        
        func getNumColumns() -> Int
        {
            //rank column is auto.
            return outer.portfolio.interestedMetrics.count + 1
            
        }
        func getNumRows() -> Int
        {
            return outer.portfolio.equities.count
        }
        
        func getYAxisOffset() -> CGFloat
        {
            return outer.yOffset
        }
        
        func getXAxisOffset() -> CGFloat
        {
            return outer.xOffset
        }
        
        func getYAxisDisplayedElementsRange() -> (Int, Int)
        {
            return (outer.startIdx, outer.portfolio.equities.count - 1)
        }
        func getXAxisDisplayedElementsRange() -> (Int, Int)
        {
            return (outer.xStartIdx, outer.portfolio.interestedMetrics.count)
        }
        // get the score of the element at the specificed indexes.
        // score should be a number between 0 an 1.
        func getScore(forElementAt elemIdx: Int, forMetric metricIdx: Int) -> Float?
        {
            
            if (elemIdx < 0 || metricIdx < 0)  {
                return nil
            }
            
            if (metricIdx == 0) {
                //return score for equity at elemIdx
                return outer.portfolio.rankings[elemIdx].1.totalScore / 100.0
            } else {
                var metric = outer.portfolio.interestedMetrics[metricIdx - 1]
                var equity = outer.portfolio.rankings[elemIdx].1
                if let score = equity.metrics[metric]?.score {
                    return score / 100.0
                }
                return nil
            }

        }
        
        func isHighlighted(forRank rank: Int) -> Bool {
            return false
        }
    }
}