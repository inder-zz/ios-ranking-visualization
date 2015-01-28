//
//  LineSegmentLayer.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/15/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

//draws a line segment between two points in a layer - that's it.

class LineSegmentLayer: CALayer, Equatable {

    var lineThickness: CGFloat = 0.5 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    var highlighted: Bool = false {
        didSet {
            if (highlighted) {
                lineThickness = 3
            }
            else {
                lineThickness = 0.5
            }
            
            self.setNeedsDisplay()
        }
    }

    var rank: Int? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var linePoints: [CGPoint] = []

    func addLine(toPoint point: CGPoint) {
        linePoints.append(point)
    }

    // MARK: - drawing functions.

    override func drawInContext(ctx: CGContext!) {
        //println("drawInContext")

        UIGraphicsPushContext(ctx)
        var path = UIBezierPath()
        
        var lineStarted = false
        for (idx, point) in enumerate(linePoints) {
            if (point.y > 0 && point.y < self.bounds.height) {
                if (!lineStarted) {
                    path.moveToPoint(point)
                    lineStarted = true
                } else {
                    path.addLineToPoint(point)
                }
            }
        }

        var lineColor = UIColor(red: 43.0 / 255.0, green: 63.0 / 255.0, blue: 86.0 / 255.0, alpha: 0.75)
        path.lineWidth = self.lineThickness
        if (!highlighted) {
            let dashes: [CGFloat] = [self.lineThickness, self.lineThickness * 3]
            path.setLineDash(dashes, count: dashes.count, phase: 0)
        }
        lineColor.setStroke()

        path.stroke()

        for (idx, point) in enumerate(linePoints) {
            var circle = CGRect(origin: CGPoint(x: point.x - 4, y: point.y - 4), size: CGSizeMake(8, 8))
            path = UIBezierPath(ovalInRect: circle)
            UIColor.whiteColor().setFill()
            UIColor(red: 43.0 / 255.0, green: 63.0 / 255.0, blue: 86.0 / 255.0, alpha: 0.75).setStroke()
            if (highlighted) {
                path.lineWidth = 2
                if (idx == 1) {
                    path.lineWidth = 3
                    circle = CGRect(origin: CGPoint(x: point.x - 10, y: point.y - 10), size: CGSizeMake(20, 20))
                    path = UIBezierPath(ovalInRect: circle)
                    UIColor.grayColor().setFill()
                }

            } else {
                let dashes: [CGFloat] = [self.lineThickness, self.lineThickness]
                path.setLineDash(dashes, count: dashes.count, phase: 0)
                path.lineWidth = self.lineThickness
            }
            path.fill()
            path.stroke()

            //draw the text on the filled layer to get anti-aliasing.
            if (highlighted && idx == 1) {
                if let r = rank {
                    var label = CATextLayer()
                    label.font = "Helvetica"
                    label.fontSize = 16
                    label.frame = circle
                    label.string = "\(r)"
                    label.alignmentMode = kCAAlignmentCenter
                    label.backgroundColor = UIColor.clearColor().CGColor
                    label.foregroundColor = UIColor.whiteColor().CGColor
                    self.addSublayer(label)
                }
            }
        }

        UIGraphicsPopContext()
    }


    // MARK: - deprecated properties and functions - #willbenuked.


    enum Direction {
        case UP
        case DOWN
        case STRAIGHT
    }

    var direction = Direction.DOWN

    init(startAt start: CGPoint, endAt end: CGPoint) {
        super.init()
        var frame: CGRect!

        if (end.y > start.y) {
            frame = CGRectMake(start.x, start.y, (end.x - start.x), (end.y - start.y) + lineThickness * 2)
            //up to down
        } else if (end.y < start.y) {
            direction = Direction.UP
            frame = CGRectMake(start.x, end.y, (end.x - start.x), (start.y - end.y) + lineThickness * 2)
        } else {
            direction = Direction.STRAIGHT
            frame = CGRectMake(start.x, end.y, (end.x - start.x), lineThickness * 2)
        }

        self.frame = frame
    }

}

func ==<T:Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }

    for index in 0 ..< lhs.count {
        if lhs[index] != rhs[index] {
            return false
        }
    }

    return true
}

// MARK: - Equatable protocol
func ==(lhs: LineSegmentLayer, rhs: LineSegmentLayer) -> Bool {
    return rhs.rank == lhs.rank
}