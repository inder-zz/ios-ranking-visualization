//
//  MetricsManager.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/6/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation

class MetricsMgr {
    class var sharedInstance: MetricsMgr {

        struct Static {
            static let instance: MetricsMgr = EquityMetricsMgr()
        }

        return Static.instance
    }

    //metrics group name -> display order
    var _metricsGroups: [String] = []

    var _stdMetrics: [String:[MetricMetaInformation]] = [:]

    var _allMetrics: [String:MetricMetaInformation] = [:]

    init() {

    }

    var numSections: Int {
        return _metricsGroups.count
    }

    var metricsGroups: [String] {
        return _metricsGroups
    }

    func getMetricMetaListForSection(let section: Int) -> [MetricMetaInformation]? {
        if (section >= _metricsGroups.count) {
            return []
        }
        return _stdMetrics[_metricsGroups[section]]
    }

    func getMetricMeta(let section: Int, let row: Int) -> MetricMetaInformation? {
        var metrics = getMetricMetaListForSection(section)
        return metrics?[row]
    }

    func getMetricMeta(byName name: String) -> MetricMetaInformation? {
        if (_allMetrics[name] == nil) {
            println("Metric NOT FOUND \(name)")
        }
        return _allMetrics[name]
    }
}

class EquityMetricsMgr: MetricsMgr {

    //price/earnings
    let PE = MetricMetaInformation(name: "PE Ratio", importance: 2, isHigherBetter: false)
    //price/book
    let PB = MetricMetaInformation(name: "PB Ratio", importance: 2, isHigherBetter: false)
    //deb/equity
    let DEQ = MetricMetaInformation(name: "Debt/Equity", importance: 2, isHigherBetter: false)
    //free cash flow
    let FCF = MetricMetaInformation(name: "FCF", importance: 2, isHigherBetter: true)
    //PEG Ratio
    let PEG = MetricMetaInformation(name: "PEG", importance: 2, isHigherBetter: true)
    
    let GAIN1M = MetricMetaInformation(name: "Gain 1M", importance: 2, isHigherBetter: true)
    let GAIN3M = MetricMetaInformation(name: "Gain 3M", importance: 2, isHigherBetter: true)
    let PS = MetricMetaInformation(name: "Price/Rev", importance: 2, isHigherBetter: false)
    let VOLUME = MetricMetaInformation(name: "Avg Vol", importance: 2, isHigherBetter: true)

    override init() {
        super.init()
        super._stdMetrics["Popular"] = [PE, GAIN1M, GAIN3M]
        super._allMetrics[PE.name] = PE
        super._allMetrics[PEG.name] = PEG
        
        super._stdMetrics["Basic"] = [PE, GAIN1M, GAIN3M, PS, VOLUME]
        super._allMetrics[PS.name] = PS
        super._allMetrics[VOLUME.name] = VOLUME
        super._allMetrics[PB.name] = PB
        super._allMetrics[DEQ.name] = DEQ
        super._allMetrics[FCF.name] = FCF
        super._allMetrics[PEG.name] = PEG
        super._allMetrics[GAIN1M.name] = GAIN1M
        super._allMetrics[GAIN3M.name] = GAIN3M

        super._metricsGroups = ["Popular", "Basic"]
    }
}


//some code about sorting dictionaries
//    func sortMetricsGroups () {
//        var arr : [String] = []
//        let sortedKeysAndValues = sorted(_metricsGroups) { $0.1 < $1.1 }
//        for (k, v) in sortedKeysAndValues {
//            arr.append(k)
//        }
//        _sortedSections = arr
//    }

