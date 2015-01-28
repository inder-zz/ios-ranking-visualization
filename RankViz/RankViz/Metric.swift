//
//  Metric.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 12/15/14.
//  Copyright (c) 2014 truquity. All rights reserved.
//

// The metrics based on which different items in a portfolio are measured.

import Foundation


class Metric {

    unowned var owner: Equity

    var score: Float = 0.0

    //key into MetricMetaInformation
    let name: String

    var value: Float {
        willSet {
            oldValue = value
        }
    }

    var rank: Int {
        willSet {
            oldRank = rank
        }
    }


    var oldValue: Float?
    var oldRank: Int?

    init(name: String, value: Float, owner: Equity) {
        self.name = name
        self.value = value
        self.rank = -1
        self.owner = owner
    }

}

