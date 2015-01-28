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

        var portfolio = portfolios[0]
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

        portfolio = portfolios[1]
        //portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PE.name)
        portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PEG.name)
        portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PS.name)
        portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PC50.name)
        portfolio.addInterestInMetric(MetricsMgr.sharedInstance.PC200.name)
        
        //data from yahoo finance.
        createStock("BOX", company: "Box, Inc.", pe: 0, peg: 0, ps: 13.21, price: 19.78, pc50: -11.60, pc200: -11.60, forPortfolio: portfolio)
        createStock("FB", company: "Facebook Inc.", pe: 70.79, peg: 1.19, ps: 18.86, price: 76.24, pc50: -1.71, pc200: 0.76, forPortfolio: portfolio)
        createStock("FUEL", company: "Rocket Fuel Inc.", pe: 0, peg: -0.35, ps: 1.56, price: 12.88, pc50: -16.41, pc200: -24.37, forPortfolio: portfolio)
        //createStock("GIMO", company: "Gigamon Inc.", pe: 0, peg: -349.55, ps: 3.41, price: 15.77, pc50: -6.13, pc200: 19.10, forPortfolio: portfolio)
        createStock("GPRO", company: "GoPro Inc.", pe: 150.03, peg: 1.43, ps: 5.86, price: 51.46, pc50: -11.66, pc200: -17.85, forPortfolio: portfolio)
        createStock("GOOG", company: "Google Inc.", pe:27.12, peg: 1.46, ps: 5.18, price: 515.94, pc50: -0.23, pc200:-6.63, forPortfolio: portfolio)
        createStock("HDP", company: "Hortonworks, Inc.", pe: 0, peg: -0.05, ps: 21.36, price: 22.36, pc50: -11.94, pc200: -11.94, forPortfolio: portfolio)
        createStock("MKTO", company: "Marketo, Inc.", pe: 0, peg: -2.07, ps: 10.46, price: 10.46, pc50: 1.96, pc200: 7.88, forPortfolio: portfolio)
        createStock("NEWR", company: "New Relic, Inc.", pe: 0, peg: 0, ps: 17.37, price: 31.04, pc50: -6.18, pc200: -6.18, forPortfolio: portfolio)
        createStock("NFLX", company: "Netflix, Inc.", pe: 102.42, peg: 5.18, ps: 4.98, price: 442.46, pc50: 26.63, pc200: 8.99, forPortfolio: portfolio)
        createStock("NOW", company: "ServiceNow, Inc.", pe: 0, peg: -15.33, ps: 23.99, price: 68.91, pc50: 3.65, pc200: 10.96, forPortfolio: portfolio)
        createStock("SPLK", company: "Splunk, Inc.", pe: 0, peg: 38.32, ps: 16.69, price: 53.41, pc50: -7.69, pc200: -4.56, forPortfolio: portfolio)
        createStock("TWTR", company: "Twitter, Inc.", pe: 0, peg: 5.31, ps: 20.86, price: 37.15, pc50: -1.31, pc200: -14.52, forPortfolio: portfolio)
        createStock("WDAY", company: "Workday, Inc.", pe: 0, peg: -5.82, ps: 21.43, price: 78.66, pc50: -3.99, pc200: -7.78, forPortfolio: portfolio)
        createStock("YELP", company: "Yelp, Inc.", pe: 0, peg: 9.16, ps: 11.92, price: 53.00, pc50: -0.36, pc200: -18.10, forPortfolio: portfolio)
        
        portfolio.buildGrid()
        
        portfolio_map[portfolio.id] = portfolio

        
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
