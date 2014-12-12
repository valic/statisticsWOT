//
//  ViewController.swift
//  statisticsWOT
//
//  Created by Мялин Валентин on 12/6/14.
//  Copyright (c) 2014 Мялин Валентин. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var inputNickName: NSTextField!
    @IBOutlet weak var outNickName: NSTextField!
    @IBAction func getStart(sender: AnyObject) {
    
     var nickName = inputNickName.stringValue
    
        println(nickName)
        
        
        func getJSON(urlToRequest: String) -> NSData{
            return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
        }
        func parseJSON(inputData: NSData) -> NSDictionary{
            var error: NSError?
            var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            
            return boardsDictionary
        }
        
        let parseAccountID = (parseJSON(getJSON("https://api.worldoftanks.ru/wot/account/list/?application_id=c2f02a1fea169312db457a323fd41441&fields=account_id&search=valicm")))
        
        println(parseAccountID)
        
        
        
        let parseAccountID_data: NSDictionary! = parseAccountID["account_id"] as? NSDictionary
        
        println(parseAccountID_data)
        
        /*
        let nicknameWOT = parseAccountID["data"] as AnyObject? as? NSDictionary
       // let account_id: NSString! = parseAccountID_data["account_id"] as? NSString
        
        println(nicknameWOT)
        */
        
        let parse = (parseJSON(getJSON("https://api.worldoftanks.ru/wot/account/info/?application_id=demo&fields=nickname,global_rating&account_id=5074337")))
        println(parse)
        let jsonDate: NSDictionary! = parse["data"] as? NSDictionary
        let jsonDate2: NSDictionary! = jsonDate["5074337"] as? NSDictionary
        let nicknameWOT: NSString! = jsonDate2["nickname"] as? NSString
        println(nicknameWOT)
        let global_rating: Int! = jsonDate2["global_rating"] as? Int
        println(global_rating)
        let jsonTime: Int! = parse["count"] as Int
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

