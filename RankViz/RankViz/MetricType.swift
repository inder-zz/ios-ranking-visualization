//
//  MetricType.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/5/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation

class MetricMetaInformation {

    var name: String

    var displayName: String?

    //range from 0-3
    //3 = more important than others.
    //2 = equally important as others.
    //1 = less important than others.
    //0 = not relevant at all - display only.
    var weight: Int = 2

    var translatedWeight: Float {
        switch weight {
        case 0:
            return 0
        case 1:
            return 0.75
        case 2:
            return 1
        case 3:
            return 1.25
        default:
            return 1
        }
    }
    // precision to use for displayin the metric value.
    var precision: Int = 2

    //are higher values better or worse.
    var higherIsBetter: Bool = true

    init(name: String, importance weight: Int?, isHigherBetter higherIsBetter: Bool?) {
        self.name = name

        if let w = weight {
            self.weight = w
        }

        if let b = higherIsBetter {
            self.higherIsBetter = b
        }
    }

    func clone() -> MetricMetaInformation {
        return MetricMetaInformation(name: self.name, importance: self.weight, isHigherBetter: self.higherIsBetter)
    }
}
