//
//  LineChartViewController.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/22/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class LineChartViewController : UIViewController {


    var scrollView : UIScrollView!
    var lineGraph : LineChartView!
    
    var delegate : LineChartViewDelegate!

    init(delegate: LineChartViewDelegate) {
        self.delegate = delegate
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.blueColor()
        
        self.scrollView = UIScrollView()
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.greenColor()
        
        lineGraph = LineChartView(frame: CGRectZero, delegate: delegate)
        
        lineGraph.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        scrollView.addSubview(lineGraph)
        
        //tie the scroll view to the boundaries of the parent view.
        self.view.addVisualConstraint("H:|-0-[scrollView]-0-|", viewsDict: ["scrollView": scrollView])
        self.view.addVisualConstraint("V:|-0-[scrollView]-0-|", viewsDict: ["scrollView": scrollView])
        
        self.view.contentMode = UIViewContentMode.Redraw
    }
    
    override func viewDidLoad() {
        var contentSize : CGSize = CGSizeMake(0, 0)
        
        if let delegate = self.delegate {
            contentSize.width = delegate.getXAxisElementDimensions().width * CGFloat(delegate.getNumColumns())
            contentSize.height = self.view.bounds.height
        }
        
        lineGraph.frame = CGRectMake(0, 0, contentSize.width, contentSize.height)
        lineGraph.setup()
        
    }
}
