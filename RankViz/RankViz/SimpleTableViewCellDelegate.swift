//
//  SimpleTableViewCellDelegate.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/22/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation

@objc protocol SimpleTableViewCellDelegate: class {
    
    optional func recycle(source: SimpleBidirectionalTableView)
    
    optional func highlight(source: SimpleBidirectionalTableView)
    
}