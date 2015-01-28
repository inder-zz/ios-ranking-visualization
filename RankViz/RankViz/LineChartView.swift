//
//  SuperimposedLineGraph.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/15/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class LineChartView: UIView {

    override var frame: CGRect {
        didSet {
            self.setNeedsDisplay()
        }
    }

    var highlightedRanks : [Int] = []
    
    var showLineGraphsForHiddenYElements = true
    
    init(frame: CGRect, delegate: LineChartViewDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var delegate: LineChartViewDelegate?

    var gridLinesColor: UIColor = UIColor.blueColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    func didShowCellsInRange(fromStartIdx startIdx: Int, toEndIndex endIdx: Int, withStartOffset startOffset: CGFloat, source: SimpleBidirectionalTableView) {

    }

    func setup() {
        if (delegate == nil) {
            return
        }
        var highlightedRanks = [Int]()
        if (self.layer.sublayers != nil) {
            for sublayer in self.layer.sublayers {
                sublayer.removeFromSuperlayer()
//                var lineSegment: LineSegmentLayer = sublayer as LineSegmentLayer
//                if lineSegment.highlighted == true {
//                    if let r = lineSegment.rank {
//                        highlightedRanks.append(r)
//                    }
//                }
            }
        }
        
        self.backgroundColor = UIColor.whiteColor()
        let ds = delegate!
        var yElemSize = ds.getYAxisElementDimensions()
        var xElemSize = ds.getXAxisElementDimensions()

        var (yStart, yEnd) = ds.getYAxisDisplayedElementsRange()
        var (xStart, xEnd) = ds.getXAxisDisplayedElementsRange()

        var yOffset = ds.getYAxisOffset()
        var heightBoundsForLineChart = self.bounds.height - yElemSize.height

        //we start from idx = 0 to make sure we cover all the line graphs.
        //TODO: a much better way of remembering which lines we need to draw without going thru all of them.
        var startY = self.showLineGraphsForHiddenYElements == true ? 0 : yStart
        
        for y in startY ... yEnd {

            var dimX = ds.getXAxisElementDimensions()

            var yPt: CGFloat = yElemSize.height * CGFloat(y - yStart) + yOffset
            //place us in the middle of the Y element.
            var startSegment = CGPoint(x: 0.0, y: yElemSize.height * CGFloat(y - yStart) - yOffset + yElemSize.height / 2)

            var xOffset = ds.getXAxisOffset()

            var lineSegments = LineSegmentLayer()
            lineSegments.frame = self.bounds
            lineSegments.addLine(toPoint: startSegment)
            self.layer.addSublayer(lineSegments)

            lineSegments.rank = y + 1

            for x in xStart ... xEnd {
                var score: Float? = ds.getScore(forElementAt: y, forMetric: x)
                if let s = score {
                    // place us in the middle of the x element.
                    // on the y axis, 0% starts in the middle of the first y element and 100% is in the middle of the last y element.
                    // 100% is shown at the top, so we subtract it from 1.
                    var endSegment = CGPoint(x: xElemSize.width * CGFloat(x - xStart) - xOffset + xElemSize.width / 2, y: (heightBoundsForLineChart) * CGFloat(1 - s) + yElemSize.height / 2)
                    
                    if endSegment.x <= 0 {
                        continue
                    }
                    
                    lineSegments.addLine(toPoint: endSegment)
                    var lineSegment = LineSegmentLayer(startAt: startSegment, endAt: endSegment)
                    //println("Drawing line between points: \(startSegment) - \(endSegment)")

                    startSegment = endSegment
                }
            }

        }

        for rank in self.highlightedRanks{
            highlightLinesForElement(atRank: rank)
        }
    }

    func refreshLayers() {
        //println("refresh layers \(self.bounds) -> \(self.layer.sublayers.count)")
        self.layer.setNeedsDisplay()
        //println("sublayers = \(self.layer.sublayers.count)")
        for lineSegment in self.layer.sublayers {
            lineSegment.setNeedsDisplay()
        }
    }

    override func drawLayer(layer: CALayer!, inContext ctx: CGContext!) {
        super.drawLayer(layer, inContext: ctx)

    }
    
    func drawVerticalGridLines() {
        if let ds = delegate {
            var (xStart, xEnd) = ds.getXAxisDisplayedElementsRange()
            var xOffset = ds.getXAxisOffset()
            var xElemSize = ds.getXAxisElementDimensions()
            let dashes: [CGFloat] = [0.5, 1.0, 1.0, 0.5]
            for x in xStart ... xEnd {
                var gridLineLayer = CALayer()
                var gridLineTop = CGPoint(x: xElemSize.width * CGFloat(x - xStart) - xOffset + xElemSize.width/2, y: 0)
                if (gridLineTop.x > 0) {
                    var gridLineBotton = CGPoint(x: gridLineTop.x, y: self.bounds.height)
                    var path = UIBezierPath()
                    path.moveToPoint(gridLineTop)
                    path.addLineToPoint(gridLineBotton)
                    gridLinesColor.setStroke()
                    path.lineWidth = 0.5
                    path.setLineDash(dashes, count: dashes.count, phase: 0)
                    path.stroke()
                }
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
                drawVerticalGridLines()
    }

    func highlightLinesForElement(atRank rank: Int) {
        //println("highlight line at idx: \(rank)")

        var lineSegments: LineSegmentLayer?
        
        for layer in self.layer.sublayers {
            var lineSegment = layer as LineSegmentLayer
            if (lineSegment.rank == rank) {
                lineSegment.removeFromSuperlayer()
                lineSegment.highlighted = !lineSegment.highlighted
                self.layer.addSublayer(lineSegment)
                
                var idx: Int? = find (self.highlightedRanks, rank)
                
                if (lineSegment.highlighted == true) {
                    if (idx == nil) {
                        self.highlightedRanks.append(rank)
                    }
                }
                else {
                    
                    while (idx != nil) {
                        self.highlightedRanks.removeAtIndex(idx!)
                        idx = find (self.highlightedRanks, rank)
                    }
                }
                break
            }
        }

    }
}