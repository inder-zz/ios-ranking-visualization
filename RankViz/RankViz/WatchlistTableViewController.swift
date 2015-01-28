//
//  PortfoliosListTableViewController.swift
//  Reverse Graph
//
//  Created by Inder Sabharwal on 12/17/14.
//  Copyright (c) 2014 truquity. All rights reserved.
//

import UIKit
import Foundation

class WatchlistTableViewController : UITableViewController {

    override func loadView() {
        super.loadView()
        self.title = "Watchlists"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomPortfolios.sharedInstance.portfolios.count;
    }

    let portfolio_cell_reuse_identifier = "WatchlistCell"
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier(portfolio_cell_reuse_identifier, forIndexPath: indexPath) as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                    reuseIdentifier: portfolio_cell_reuse_identifier)
        }
        
        var portfolio = CustomPortfolios.sharedInstance.portfolios[indexPath.row]
        cell!.textLabel?.text = portfolio.name
        cell!.detailTextLabel?.text = portfolio.longDescription()
        return cell!
    }


    let show_chart_viz_segue: String = "ShowChartVizSegue"

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == show_chart_viz_segue) {
            var dest: LineChartVizViewController = segue.destinationViewController as LineChartVizViewController
            let idx = self.tableView.indexPathForSelectedRow()
            var portfolio: Portfolio? = CustomPortfolios.sharedInstance.portfolios[idx!.row]

            if let p = portfolio {
                dest.portfolio = p
            }
        } else {
            println("Bad segue identifier!!")
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == show_chart_viz_segue && sender is UITableViewCell)
        {
            let idx = self.tableView.indexPathForCell(sender! as UITableViewCell)
            var portfolio: Portfolio? = CustomPortfolios.sharedInstance.portfolios[idx!.row]
            return portfolio != nil
        }
        return false
    }

}
