//
//  StringExtensions.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/20/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation

extension String {
    var xtFloatValue: Float {
        return (self as NSString).floatValue
    }
    
    var xtLength: Int {
        return countElements(self)
    }
}
