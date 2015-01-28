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

    private var _value: Float
    private var _rank: Int
    private var _score: Float = 0.0

    //key into MetricMetaInformation
    let name: String

    var value: Float {
        get {
            return self._value
        }
        set {
            oldValue = self._value
            _value = newValue
        }
    }

    var rank: Int {
        get {
            return self._rank
        }
        set {
            oldRank = _rank
            self._rank = newValue
        }
    }

    var score: Float {
        get {
            return self._score
        }
        set {
            self._score = newValue
        }
    }

    var oldValue: Float?
    var oldRank: Int?

    init(name: String, value: Float, owner: Equity) {
        self.name = name
        self._value = value
        self._rank = -1
        self.owner = owner
    }

}

