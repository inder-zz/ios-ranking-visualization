//
//  Equity.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 12/14/14.
//  Copyright (c) 2014 truquity. All rights reserved.
//

import Foundation

class Equity: Printable {

    let symbol: String
    let exchange: String
    var companyName: String
    var price: Float?
    private var _rank: Float?
    private var _oldRank: Float?
    private var _totalScore: Float?

    var description: String {
        return "\(self.companyName), score=\(self.totalScore)"
    }
    var totalScore: Float {
        get {
            if let ts = _totalScore {
                return ts
            }
            return -1
        }
        set {
            self._totalScore = newValue
        }
    }

    var rank: Float? {
        get {
            return _rank
        }
        set {
            self._rank = newValue
        }
    }

    var oldRank: Float? {
        get {
            return _oldRank
        }
        set {
            self._oldRank = newValue
        }
    }

    //metrics
    var metrics: [String:Metric] = [:]

    // Create an instance of Equity with a given symbol, for a given exchange.
    init(fromSymbol symbol: String, fromExchange xchg: String, companyName: String?) {
        self.symbol = (symbol as NSString).uppercaseString
        self.exchange = (xchg as NSString).uppercaseString
        if let c = companyName {
            self.companyName = c
        } else {
            self.companyName = symbol
        }
    }

    init(fromKey key: String) {
        var arr = split(key) {
            $0 == ":"
        }
        self.symbol = arr[0]
        self.exchange = arr.count > 1 ? arr[1] : Equity.defaultExchange()
        self.companyName = self.symbol
    }

    class func defaultExchange() -> String {
        return "NYSE"
    }

    //Allow Equity to be used as a dictionary for its metrics.
    subscript(key: String) -> Metric? {
        get {
            return self.metrics[key]
        }
        set {
            //also, allows it to be set to nil.
            if let val = newValue {
                self.metrics[key] = val
            } else {
                self.metrics.removeValueForKey(key)
            }
        }
    }

    class func key(fromSymbol symbol: String, fromExchange exchange: String) -> String {
        return "\(symbol):\(exchange)"
    }
}