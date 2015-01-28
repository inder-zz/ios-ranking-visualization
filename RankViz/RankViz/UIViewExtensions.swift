//
//  UIViewExtensions.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 1/2/15.
//  Copyright (c) 2015 truquity. All rights reserved.
//

import Foundation
import UIKit

class ConstraintUtils {

}

extension UIView {
    func loadViewFromNib(forView viewName: String) -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: viewName, bundle: bundle)

        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as UIView
        return view
    }

    func setConstraints(let constraints: [NSLayoutConstraint], toActive active: Bool) {
        for constaint: NSLayoutConstraint in constraints {
            constaint.active = active
        }
    }

    //set the active flag on all the constraints to true.
    func activateAllConstraints(let constraints: [NSLayoutConstraint]) {
        setConstraints(constraints, toActive: true)
    }

    //set the active flag on all the supplied constraints to false.
    func deactivateAllConstraints(let constraints: [NSLayoutConstraint]) {
        setConstraints(constraints, toActive: false)
    }

    func addVisualConstraint(visualConstraints: String, viewsDict: [String:AnyObject]) -> [AnyObject] {
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(visualConstraints, options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict)
        self.addConstraints(constraints)
        return constraints
    }

}

extension UIViewController {
    func setConstraints(let constraints: [NSLayoutConstraint], toActive active: Bool) {
        for constaint: NSLayoutConstraint in constraints {
            constaint.active = active
        }
    }

    func activateAllConstraints(let constraints: [NSLayoutConstraint]) {
        setConstraints(constraints, toActive: true)
    }

    func deactivateAllConstraints(let constraints: [NSLayoutConstraint]) {
        setConstraints(constraints, toActive: false)
    }
}

