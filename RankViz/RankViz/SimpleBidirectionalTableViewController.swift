//
//  SimpleBidirectionalTableViewController.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/22/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class SimpleBidirectionalTableViewController : UIViewController {
    
    var tableView: SimpleBidirectionalTableView!
    var direction = SimpleBidirectionalTableView.Direction.Vertical
    
    init( direction: SimpleBidirectionalTableView.Direction) {
        self.direction = direction
        //invoked the designated initializer.
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = UIView(frame: CGRectZero)
        self.tableView = SimpleBidirectionalTableView(forDirection: self.direction)
        tableView.sizeToFit()
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.blueColor()
        
        let contentView = tableView.contentView
        
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.backgroundColor = UIColor.redColor()
        tableView.addSubview(contentView)
        tableView.contentView = contentView
        
        self.view.addVisualConstraint("H:|-0-[scrollView]-0-|", viewsDict: ["scrollView": tableView])
        self.view.addVisualConstraint("V:|-0-[scrollView]-0-|", viewsDict: ["scrollView": tableView])
        
        self.view.addVisualConstraint("H:|[contentView]|", viewsDict: ["contentView": contentView])
        self.view.addVisualConstraint("V:|[contentView]|", viewsDict: ["contentView": contentView])
        
        //make the width of content view to be the same as that of the containing view.
        switch direction {
        case .Vertical:
            self.view.addVisualConstraint("H:[contentView(==mainView)]", viewsDict: ["contentView": contentView, "mainView": self.view])
        case .Horizontal:
            self.view.addVisualConstraint("V:[contentView(==mainView)]", viewsDict: ["contentView": contentView, "mainView": self.view])
        }
        
        
        self.view.contentMode = UIViewContentMode.Redraw
        
    }
    
    override func viewDidLoad() {
        
    }

}