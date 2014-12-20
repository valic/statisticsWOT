//
//  TodayViewController.swift
//  test
//
//  Created by Мялин Валентин on 12/8/14.
//  Copyright (c) 2014 Мялин Валентин. All rights reserved.
//

//import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {

    @IBOutlet weak var outWOTStatistic: NSTextField!
    override var nibName: String? {
        
        outWOTStatistic.stringValue = "Hello word"
        
        
        return "TodayViewController"
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }

}
