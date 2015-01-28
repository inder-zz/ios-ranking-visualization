//
//  Portfolio.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 12/14/14.
//  Copyright (c) 2014 truquity. All rights reserved.
//

import Foundation

// Collection of Equities

@objc class Portfolio {

    let id: String = NSUUID().UUIDString

    let name: String

    var equities = [String: Equity]()

    var rankings: [(String, Equity)] = []

    //metric name and it's order.
    private var _orderedColumns: [String:Int] = [:]

    //metrics that i am interested in, and the order in which they are displayed.
    var _interestedMetrics = [String]()

    var interestedMetrics: [String] {
        var v = [String](_interestedMetrics)
        return v
    }

    var interestedMetricTypes: [MetricMetaInformation] {
        var list: [MetricMetaInformation] = []
        for m in self._interestedMetrics {
            var mmi: MetricMetaInformation? = self.getMetricMeta(byName: m)
            if (mmi != nil) {
                list.append(mmi!)
            }
        }
        return list
    }

    var customMetricMetaList: [String:MetricMetaInformation] = [:]

    init(name: String) {
        self.name = name
    }

    // i know this is confusing as hell, so this is how it is organized:
    // dictionary of columnNames -> Array of (Metric, Value) tuples
    var grid = [String: GridColumn]()

    func buildGrid() {
        grid.removeAll(keepCapacity: true)

        for equity in equities.values {
            equity.totalScore = -1
            for (key, metric) in equity.metrics {
                //metric.score = 0
                var column: GridColumn? = grid[key]
                if (column == nil) {
                    var metaInfo: MetricMetaInformation? = getMetricMeta(byName: key)
                    if (metaInfo != nil) {
                        column = GridColumn(name: key, meta: metaInfo!)
                        grid[key] = column!
                    }
                    else {
                        println("null metainfo for \(key)")
                    }
                }
                column!.values.append(metric)
            }
        }

        self.sortAllMetrics()
        self.buildRankings()
    }

    func buildRankings() {

        self.rankings = []

        //dictionary of metricName -> array of equityName -> score

        var allScores: [String:[(equity:Equity, score:Float)]] = [:]
        
        for (key: String, column: GridColumn) in grid {
            println("--->>> Calculating scores for \(key) <<<<----")
            var scores: [(Equity, Float)] = []
            var metrics = column.values
            if (metrics.count == 0) {
                continue
            }

            var best = metrics[0]
            var worst = metrics.last!
            var range = best.value - worst.value

            for metric: Metric in metrics {
                var rawScore = metric.value - worst.value
                var score = (rawScore / range) * 100.0
                scores += [(equity: metric.owner, score: score)]
                println("Metric: \(key) Equity: \(metric.owner.symbol) Score: \(score)")
                metric.score = score
            }
        }

        var totalWeights: Float = 0.0
        for metricType: MetricMetaInformation in interestedMetricTypes {
            totalWeights += metricType.translatedWeight
        }

        for equity in self.equities.values {
            var interestedMetricTypes: [MetricMetaInformation] = self.interestedMetricTypes
            var numMetrics = interestedMetricTypes.count

            var totalScore: Float = 0.0

            for metricType: MetricMetaInformation in interestedMetricTypes {
                var metric = equity.metrics[metricType.name]
                if (metric == nil) {
                    continue
                }
                totalScore += (metric!.score * metricType.translatedWeight)
            }
            equity.totalScore = totalScore / totalWeights
        }

        //does not account for equities which have no totalScores ( = -1) - is that a valid case?
        self.rankings = sorted(self.equities) {
            $0.1.totalScore > $1.1.totalScore
        }

        println("---- Rankings -----")
        println(self.rankings)
    }

    func sortAllMetrics() {
        for column in grid.values {
            column.sort()
        }
    }

    func addEquity(equity: Equity) {
        equities[equity.symbol] = equity
    }

    func longDescription() -> String {
        var desc: String = ""
        for (idx, e) in enumerate(equities.values) {
            if (idx > 0) {
                desc += ", "
            }
            desc += "\(e.symbol)"
//            if (idx == 4 && equities.count > 5) {
//                desc += " ..\(equities.count-(idx+1)) more"
//            }
//            if (idx == 4) {
//                break
//            }
        }
        return desc
    }

    //rank is 0 indexed.
    func getMetric(name: String, forRank rank: Int) -> Metric? {
        var metrics: GridColumn? = grid[name]

        if (metrics != nil && rank < metrics!.values.count) {
            return metrics!.values[rank]
        }

        return nil
    }

    func setMetricMeta(meta: MetricMetaInformation) -> MetricMetaInformation {
        customMetricMetaList[meta.name] = meta.clone()
        return customMetricMetaList[meta.name]!
    }

    func hasInterestInMetric(metricName: String) -> Bool {
        return contains(self.interestedMetrics, metricName)
    }

    func getMetricMeta(byName name: String) -> MetricMetaInformation? {

        var meta: MetricMetaInformation? = customMetricMetaList[name]

        if (meta != nil) {
            return meta
        }

        return MetricsMgr.sharedInstance.getMetricMeta(byName: name)
    }

    func addInterestInMetric(metricName: String) {
        if (find(self._interestedMetrics, metricName) == nil) {
            self._interestedMetrics.append(metricName)
        }
    }

    func removeInterstFromMetric(metricName: String) {
        var idx = find(self._interestedMetrics, metricName)
        if (idx != nil && self._interestedMetrics.count > 1) {
            self._interestedMetrics.removeAtIndex(idx!)
        }
    }

    func getCustomInterestedMetric(metricName: String) -> MetricMetaInformation {
        self.addInterestInMetric(metricName)
        var meta = self.customMetricMetaList[metricName]
        if (meta == nil) {
            meta = MetricsMgr.sharedInstance.getMetricMeta(byName: metricName)
            if (meta != nil) {
                meta = meta!.clone()
            } else {
                meta = MetricMetaInformation(name: metricName, importance: 2, isHigherBetter: true)
            }
            self.customMetricMetaList[metricName] = meta!
        }
        return meta!
    }
}

class GridColumn {
    //column name
    var name: String
    unowned var meta: MetricMetaInformation

    //column values
    var values: [Metric] = []

    init(name: String, meta: MetricMetaInformation) {
        self.name = name
        self.meta = meta
    }

    func sort() {
        if meta.higherIsBetter {
            values.sort({ $0.value > $1.value })
        } else {
            values.sort({ $0.value < $1.value })
        }
    }
}

