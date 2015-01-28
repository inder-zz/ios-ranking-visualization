//
//  ScrollableEquitiesRowHeadersViewController.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/21/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class ScrollableEquitiesRowHeadersViewController : SimpleBidirectionalTableViewController, SimpleBidirectionalTableViewDelegate {

    var portfolio: Portfolio!
    var rowHeaderDimensions: CGSize!
    weak var controller: LineChartVizViewController?
    
    init(portfolio: Portfolio, rowHeaderDimensions: CGSize) {
        self.portfolio = portfolio
        self.rowHeaderDimensions = rowHeaderDimensions
        super.init(direction: .Vertical)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        self.tableView.tableViewDelegate = self
    }
    
    func numberOfCells(source: SimpleBidirectionalTableView) -> Int {
        return portfolio.equities.count
    }

    func heightOfCells(source: SimpleBidirectionalTableView) -> CGFloat {
        return rowHeaderDimensions.height
    }
    
    func widthOfCells(source: SimpleBidirectionalTableView) -> CGFloat {
        return rowHeaderDimensions.width
    }
    
    var equities = [Equity]()
    
    func viewForCell(atIndex idx: Int, source: SimpleBidirectionalTableView) -> UIView? {
        if (idx >= portfolio.equities.count) {
            return nil
        }
        var view = EquityRowHeaderView(frame: CGRectMake(0, 0, rowHeaderDimensions.width, rowHeaderDimensions.height))
        view.equity = portfolio.rankings[idx].1
        equities.append(portfolio.rankings[idx].1)
        return view
    }
    
    var startIndex: Int = 0
    func didShowCellsInRange(fromStartIdx startIdx: Int, toEndIndex endIdx: Int, withStartOffset startOffset: CGFloat, source: SimpleBidirectionalTableView) {
        startIndex = startIdx
        controller?.didShowCellsInRange(fromStartIdx: startIdx, toEndIndex: endIdx, withStartOffset: startOffset, source: source)
    }
    
    //take some action, if you want to.
    func userSelectedCell(atIndex row: Int, cell: UIView, source: SimpleBidirectionalTableView) {
        //for now rank calculation is a hack. I do not like it, it has to be more than a fixed offset.
        //maybe it is okay for now since this is a rank based visualization??!!
        controller?.lineChartView.highlightLinesForElement(atRank: row + 1) //rank is 1 indexed.
    }
}