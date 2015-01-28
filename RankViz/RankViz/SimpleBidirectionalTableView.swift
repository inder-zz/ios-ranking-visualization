//
//  SimpleBidirectionalTableView.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/21/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

// A bi-directional table view which uses fixed heights(vertical) or widths(horizontal)


class SimpleBidirectionalTableView : UIScrollView, UIScrollViewDelegate {

    enum Direction {
        case Horizontal
        case Vertical
    }
    
    var direction: Direction = .Vertical
    
    var contentView: UIView!
    
    private var _layoutdone = false
    
    // MARK: - delegates
    weak var tableViewDelegate: SimpleBidirectionalTableViewDelegate!
    
    
    // MARK: - initialization and setup
    override convenience init() {
        self.init(frame: CGRectZero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(forDirection direction: Direction) {
        self.init(frame: CGRectZero)
        self.direction = direction
        setup()
    }
    
    init(forDirection direction: Direction, tableViewDelegate: SimpleBidirectionalTableViewDelegate) {
        self.direction = direction
        self.tableViewDelegate = tableViewDelegate
        super.init()
        setup()
    }
    
    init(forDirection direction: Direction, frame: CGRect, tableViewDelegate: SimpleBidirectionalTableViewDelegate) {
        self.direction = direction
        super.init(frame: frame)
        self.tableViewDelegate = tableViewDelegate
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        var contentView = UIView()
        self.addSubview(contentView)
        self.contentView = contentView
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
    
    //MARK: - subviews and layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (_layoutdone) {
            return
        }
        
        if let contentView = self.contentView {
            var viewsDict = [String: UIView]()
            
            var big_constraint : String = (direction == .Vertical) ? "V:|" :  "H:|"
            
            
            for i in 0 ... tableViewDelegate.numberOfCells(self) - 1 {
                var subview = SimpleTableViewCell(frame: CGRectZero)
                subview.index = i
                
                subview.backgroundColor = UIColor.clearColor()
                var containedView = self.tableViewDelegate.viewForCell(atIndex: i, source: self)
                if let containedView = containedView {
                    switch direction {
                    case .Vertical:
                        containedView.frame = CGRectMake(0, 0, self.bounds.width, tableViewDelegate.heightOfCells(self))
                    case .Horizontal:
                        containedView.frame = CGRectMake(0, 0, tableViewDelegate.widthOfCells(self), self.bounds.height)
                    }
                    
                    subview.addSubview(containedView)
                    subview.sizeToFit()
                    subview.setTranslatesAutoresizingMaskIntoConstraints(false)
                    
                    viewsDict["subview_\(i)"] = subview
                    contentView.addSubview(subview)
                    
                    //println("adding small constraint")
                    switch direction {
                    case .Vertical:
                        big_constraint += "[subview_\(i)(==\(tableViewDelegate.heightOfCells(self)))]"
                        //println("adding small constraint: H:|[subview_\(i)]|")
                        contentView.addVisualConstraint("H:|[subview_\(i)]|", viewsDict: viewsDict)
                    case .Horizontal:
                        //println("adding small constraint: V:|[subview_\(i)]|")
                        big_constraint += "[subview_\(i)(==\(tableViewDelegate.widthOfCells(self)))]"
                        contentView.addVisualConstraint("V:|[subview_\(i)]|", viewsDict: viewsDict)
                    }
                }
            }
            
            big_constraint += "|"
            
            println("About to set big constraint: \(big_constraint)")
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(big_constraint, options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict))
            
            var singleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            contentView.addGestureRecognizer(singleTapRecognizer)
            _layoutdone = true
            
            // layout self so that it will layout contentView and resize itself.
            self.layoutIfNeeded()
            
            println("contentView bounds= \(contentView.bounds.size)")
        }
        
        println("ScrollableRowHeadersView - layoutSubviews - exit")
    }
    
    
    // MARK: - scrolling and touch handling.
    
    func handleTap(sender: UITapGestureRecognizer) {
        
        var vue = sender.view
        var subview : UIView? = vue?.hitTest(sender.locationInView(vue), withEvent: nil)
        
        while (subview != nil) {
            if let sv: UIView = subview {
                if (sv is SimpleTableViewCell) {
                    (sv as SimpleTableViewCell).toggleHighlight()
                    if (sv.subviews.count > 0) {
                        var idx = (sv as SimpleTableViewCell).index
                        tableViewDelegate.userSelectedCell?(atIndex: idx, cell: sv.subviews[0] as UIView, source: self)
                    }
                    break
                }
                else {
                    subview = sv.superview
                }
            }
        }
        
        //println("location: \(sender.locationInView(vue))")
    }
    
    var currentOffset: CGPoint?
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        currentOffset = self.contentOffset
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentOffset = nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        switch direction {
        case .Vertical:
            var height = self.tableViewDelegate.heightOfCells(self)
            var startCellIndex: Int = Int(scrollView.contentOffset.y / height)
            var statCellOffset: CGFloat = scrollView.contentOffset.y - (CGFloat(startCellIndex) * height)
            var numDisplayedCells = Int(self.contentView.bounds.height/height)
            
            //invoking an optional method - so notice two '?'s at the right places.
            self.tableViewDelegate?.didShowCellsInRange?(fromStartIdx: startCellIndex, toEndIndex: (startCellIndex + numDisplayedCells), withStartOffset: statCellOffset, source: self)

        case .Horizontal:
            var width = self.tableViewDelegate.widthOfCells(self)
            var startCellIndex: Int = Int(scrollView.contentOffset.x / width)
            var statCellOffset: CGFloat = scrollView.contentOffset.x - (CGFloat(startCellIndex) * width)
            var numDisplayedCells = Int(self.contentView.bounds.width/width)
            
            //invoking an optional method - so notice two '?'s at the right places.
            self.tableViewDelegate?.didShowCellsInRange?(fromStartIdx: startCellIndex, toEndIndex: (startCellIndex + numDisplayedCells), withStartOffset: statCellOffset, source: self)
        }
    }
    
}

