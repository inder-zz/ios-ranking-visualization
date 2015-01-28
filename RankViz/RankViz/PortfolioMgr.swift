//
//  PortfolioMgr.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 12/17/14.
//  Copyright (c) 2014 truquity. All rights reserved.
//

import Foundation

//manages a user's portfolio.

class CustomPortfolios {

    class var sharedInstance: CustomPortfolios {

        struct Static {
            static let instance: CustomPortfolios = CustomPortfolios()
        }

        return Static.instance
    }

    let default_portfolio_names = ["Technology Momentum", "Oil Refiners", "Medical Device Manufacturers", "Big Box Retailers"]

    lazy var portfolios: [Portfolio] = [Portfolio(name: "Technology Momentum"), Portfolio(name: "Oil Refiners"), Portfolio(name: "Medical Device Manufacturers"), Portfolio(name: "Big Box Retailers"), Portfolio(name: "Technology Momentum"), Portfolio(name: "Oil Refiners"), Portfolio(name: "Medical Device Manufacturers"), Portfolio(name: "Big Box Retailers"), Portfolio(name: "Technology Momentum"), Portfolio(name: "Oil Refiners"), Portfolio(name: "Medical Device Manufacturers"), Portfolio(name: "Big Box Retailers")]

    var portfolio_map: [String:Portfolio] = [:]

    let pe_ratio = "PE Ratio"
    let gain_1m = "Gain 1M"

    init() {

        initMeta()

        for (idx, portfolio) in enumerate(portfolios) {
            portfolio.addInterestInMetric(pe_ratio)
            portfolio.addInterestInMetric(gain_1m)

            var stock: Equity = Equity(fromSymbol: "SPLK", fromExchange: "NSDQ", companyName: "Splunk, Inc.")
            stock[pe_ratio] = Metric(name: pe_ratio, value: 70, owner: stock)
            stock[gain_1m] = Metric(name: gain_1m, value: 100000, owner: stock)
            portfolio.addEquity(stock)

            createStock("GOOG", company: "Google, Inc", pe: 20.5, volume: 10000, forPortfolio: portfolio)
            createStock("MSFT", company: "Microsoft, Inc", pe: 27.5, volume: 10000, forPortfolio: portfolio)
            createStock("WDAY", company: "Workday.com", pe: 33, volume: 100000, forPortfolio: portfolio)
            createStock("DATA", company: "Tableau", pe: 30, volume: 135000, forPortfolio: portfolio)
            createStock("JUNK", company: "Junk, Inc", pe: 22, volume: 93000, forPortfolio: portfolio)
            createStock("CAP", company: "Capitol, Inc", pe: 10, volume: 800, forPortfolio: portfolio)

            createStock("ATT", company: "Att, Inc", pe: 44.32, volume: 260000, forPortfolio: portfolio)
            createStock("VZ", company: "Verizon, Inc", pe: 18, volume: 60000, forPortfolio: portfolio)
            createStock("WH", company: "White House, Inc", pe: 10, volume: 300000, forPortfolio: portfolio)

            portfolio.buildGrid()

            portfolio_map[portfolio.id] = portfolio
        }
    }

    func createStock(symbol: String, company: String, pe: Float, volume: Float, forPortfolio portfolio: Portfolio) {
        var stock = Equity(fromSymbol: symbol, fromExchange: "NSDQ", companyName: company)
        stock.price = 100.99
        stock[pe_ratio] = Metric(name: pe_ratio, value: pe, owner: stock)
        stock[gain_1m] = Metric(name: gain_1m, value: volume, owner: stock)
        portfolio.addEquity(stock)
    }

    func initMeta() {
        MetricsMgr.sharedInstance.getMetricMeta(byName: pe_ratio)
        MetricsMgr.sharedInstance.getMetricMeta(byName: gain_1m)
    }

    func getPortfolioById(let id: String) -> Portfolio? {
        return portfolio_map[id]
    }

}

class PortfolioMgr {
    class var sharedInstance: PortfolioMgr {

        struct Static {
            static let instance: PortfolioMgr = PortfolioMgr()
        }

        return Static.instance
    }

    private var _user: AnyObject?

    var user: AnyObject? {
        get {
            return _user
        }
        set {
            _user = newValue
        }
    }


    init() {

    }

    var isSignedIn: Bool {
        if let u: AnyObject = user {
            return true
        }
        return false
    }

    var _portfolios = [Portfolio]()

    var _followingPortfolios = [Portfolio]()

    var portfolios: [Portfolio] {
        return _portfolios
    }

    var followingPortfolios: [Portfolio] {
        return _followingPortfolios
    }

    //reload all portfolios again.
    func reloadPortfolios() {

    }

}

class TestPortfolioMgr: PortfolioMgr {

}
