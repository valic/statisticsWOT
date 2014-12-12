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
    
     var nickNameIn = inputNickName.stringValue
    
        println(nickNameIn)
        
        func getJSON(urlToRequest: String) -> NSData{
            return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
        }
        func parseJSON(inputData: NSData) -> NSDictionary{
            var error: NSError?
            var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            
            return boardsDictionary
        }
        
        func parseAccountID(userName: String) -> (account_id: NSNumber?, nickname: String?, status: String?, codeError: Int?, message: String?, value:String?, Field:String? )! {
            
            var account_id:NSNumber?
            var nickname:String?
            var status:String?
            var codeError: Int?
            var message:String?
            var value:String?
            var field:String?
            var parseError:NSDictionary!
            
            let parseAccountID = (parseJSON(getJSON("https://api.worldoftanks.ru/wot/account/list/?application_id=c2f02a1fea169312db457a323fd41441&fields=account_id,nickname&type=exact&search=" + userName)))
            
            
            if let parse = parseAccountID as? [String: AnyObject] {
                
                status = parse["status"] as String! // ‘ok’ — запрос выполнен успешно; ‘error’ — ошибка при выполнении запроса.
                
                if status == "ok" {
                    
                    if let data = parse["data"] as? [AnyObject] {
                        for start in data {
                            account_id = start["account_id"] as? NSNumber! // Идентификатор аккаунта игрока
                            nickname = start["nickname"] as? String //Ник игрока
                        }
                    }
                }
                else
                {
                    parseError = parseAccountID["error"] as NSDictionary
                    
                        codeError = parseError["code"] as? Int
                        message = parseError["message"] as? String
                        value = (parseError["value"] as String)
                        field = (parseError["field"] as String)
                }
            }
            return (account_id,nickname, status!, codeError, message, value, field)
        }
        
      println(parseAccountID(nickNameIn))

        
        
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

