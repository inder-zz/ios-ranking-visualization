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

    let default_portfolio_names = ["Tech Large Cap", "Growth Tech"]

    lazy var portfolios: [Portfolio] = [Portfolio(name: "Tech Large Cap"), Portfolio(name: "Growth Tech")]

    var portfolio_map: [String:Portfolio] = [:]

    init() {

        initMeta()

        for (idx, portfolio) in enumerate(portfolios) {
            portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PE.name)
            portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PEG.name)
            portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PS.name)
            portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PC200.name)

            //data from yahoo finance.
            createStock("IBM", company: "International Business Machines Corporation", pe: 12.86, peg: 2.13, ps: 1.64, price: 153.08, pc50: -2.86, pc200: -12.60, forPortfolio: portfolio)
            createStock("HPQ", company: "Hewlett-Packard Company", pe: 14.37, peg: 1.93, ps: 0.61, price: 37.71, pc50: -4.04, pc200: 2.46, forPortfolio: portfolio)
            createStock("ORCL", company: "Oracle Corporation", pe: 18.01, peg: 1.72, ps: 4.91, price: 43.29, pc50: -0.51, pc200: 5.80, forPortfolio: portfolio)
            createStock("MSFT", company: "Microsoft Corporation", pe: 16.93, peg: 2.09, ps: 3.75, price: 41.98, pc50: -10.15, pc200: -8.89, forPortfolio: portfolio)
            createStock("AAPL", company: "Apple Inc.", pe: 18.16, peg: 1.16, ps: 3.50, price: 117.25, pc50: 6.09, pc200: 11.90, forPortfolio: portfolio)
            createStock("GOOG", company: "Google Inc.", pe:27.12, peg: 1.46, ps: 5.18, price: 515.94, pc50: -0.23, pc200:-6.63, forPortfolio: portfolio)
            createStock("FB", company: "Facebook Inc.", pe: 71.36, peg: 1.19, ps: 18.86, price: 76.81, pc50: -0.88, pc200: 1.61, forPortfolio: portfolio)
            createStock("EBAY", company: "ebayInc.", pe: 0, peg: 1.60, ps: 3.76, price: 54.38, pc50: -2.53, pc200: 1.18, forPortfolio: portfolio)
            createStock("SAP", company: "SAP SE", pe: 21.05, peg: 1.28, ps: 4.00, price: 64.19, pc50: -5.45, pc200: -10.88, forPortfolio: portfolio)
            createStock("CSCO", company: "Cisco Systems Inc.", pe: 1.65, peg: 1.28, ps: 2.91, price: 26.81, pc50: -3.05, pc200: 3.99, forPortfolio: portfolio)
            
            portfolio.buildGrid()

            portfolio_map[portfolio.id] = portfolio
        }
    }

    func createStock(symbol: String, company: String, pe: Float, peg: Float, ps: Float, price: Float, forPortfolio portfolio: Portfolio) {
        var stock = Equity(fromSymbol: symbol, fromExchange: "NSDQ", companyName: company)
        stock[MetricsMgr.sharedInstance.PE.name] = Metric(name: MetricsMgr.sharedInstance.PE.name, value: pe, owner: stock)
        stock[MetricsMgr.sharedInstance.PEG.name] = Metric(name: MetricsMgr.sharedInstance.PEG.name, value: peg, owner: stock)
        stock[MetricsMgr.sharedInstance.PS.name] = Metric(name: MetricsMgr.sharedInstance.PS.name, value: ps, owner: stock)
        stock.price = price
        
        portfolio.addEquity(stock)
    }

    func createStock(symbol: String, company: String, pe: Float, peg: Float, ps: Float, price: Float, pc50: Float, pc200: Float, forPortfolio portfolio: Portfolio) {
        var stock = Equity(fromSymbol: symbol, fromExchange: "NSDQ", companyName: company)
        stock[MetricsMgr.sharedInstance.PE.name] = Metric(name: MetricsMgr.sharedInstance.PE.name, value: pe, owner: stock)
        stock[MetricsMgr.sharedInstance.PEG.name] = Metric(name: MetricsMgr.sharedInstance.PEG.name, value: peg, owner: stock)
        stock[MetricsMgr.sharedInstance.PS.name] = Metric(name: MetricsMgr.sharedInstance.PS.name, value: ps, owner: stock)
        
        stock[MetricsMgr.sharedInstance.PS.name] = Metric(name: MetricsMgr.sharedInstance.PS.name, value: ps, owner: stock)
        
        stock[MetricsMgr.sharedInstance.PC50.name] = Metric(name: MetricsMgr.sharedInstance.PC50.name, value: pc50, owner: stock)
        stock[MetricsMgr.sharedInstance.PC200.name] = Metric(name: MetricsMgr.sharedInstance.PC200.name, value: pc200, owner: stock)
        
        stock.price = price
        
        portfolio.addEquity(stock)
    }
    
    func initMeta() {
        MetricsMgr.sharedInstance.getMetricMeta(byName: MetricsMgr.sharedInstance.PE.name)
        MetricsMgr.sharedInstance.getMetricMeta(byName: MetricsMgr.sharedInstance.PEG.name)
        MetricsMgr.sharedInstance.getMetricMeta(byName: MetricsMgr.sharedInstance.PS.name)
    }

    func getPortfolioById(let id: String) -> Portfolio? {
        return portfolio_map[id]
    }

}
