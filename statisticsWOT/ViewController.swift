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
    
        let nickNameIn = inputNickName.stringValue
      
    
        println(nickNameIn)
        
        func getJSON(urlToRequest: String) -> NSData{
            return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
        }
        func parseJSON(inputData: NSData) -> NSDictionary{
            var error: NSError?
            var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            
            return boardsDictionary
        }
        func stringErorr(codeError: Int) -> () {
          var stringErorr:String?
            switch (codeError) {
            case 402: stringErorr = "Не задано значение параметра search"
            case 407: stringErorr = "Недостаточная длина параметра search. Минимум: 3 символа."
            default: stringErorr = "Сервер вернул неизвестную ошибку"
            }
            println(stringErorr)
            
        }
      
        //  По никнейму игрока и узнаем его account_id.
        func parseAccountID(userName: String) -> (account_id: NSNumber?, nickname: String?, status: String?, count: Int?,  codeError: Int?, message: String?, value: String?, Field: String?)! {
            
            var account_id:NSNumber?
            var nickname:String?
            var status:String?
            var count:Int?
            var parseError:NSDictionary!
            var codeError: Int?, message: String?, value: String?, field: String?
            
            let parseAccountID = (parseJSON(getJSON("https://api.worldoftanks.ru/wot/account/list/?application_id=c2f02a1fea169312db457a323fd41441&fields=account_id,nickname&type=exact&search=" + userName)))
            
            
            if let parse = parseAccountID as? [String: AnyObject] {
                println(parse)
                status = parse["status"] as String! // ‘ok’ — запрос выполнен успешно; ‘error’ — ошибка при выполнении запроса.
                count = parse["count"] as Int!
                
                
                if status == "ok" { // Проверка запрос выполнен успешно или нет.
                    
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
            return (account_id, nickname, status, count, codeError, message, value, field)
        }
        func parseAccountInfo(account_id: NSNumber) -> (battle_avg_xp: Int?, battles: Int?, status: String?, codeError: Int?, message: String?, value:String?, Field:String? )! {
            
            var battle_avg_xp:Int?
            var battles: Int?
            var status:String?
            var codeError: Int?
            var message:String?
            var value:String?
            var field:String?
            var parseError:NSDictionary!
            
            let parseAccountID = (parseJSON(getJSON("http://api.worldoftanks.ru/wot/account/info/?application_id=c2f02a1fea169312db457a323fd41441&fields=statistics.all.battles,statistics.all.battle_avg_xp&access_token=736bce94326dc5d2c7030928993d8c651c5eeb31&account_id=" + account_id.stringValue)))
            
            
            if let parse = parseAccountID as? [String: AnyObject] {
                
                //println(parse)
                
                status = parse["status"] as String! // ‘ok’ — запрос выполнен успешно; ‘error’ — ошибка при выполнении запроса.
                
                if status == "ok" { // Проверка запрос выполнен успешно или нет.
                    
                    if let data = parse["data"] as? NSDictionary {
                        
                        var ID = data[account_id.stringValue] as? NSDictionary
                        var statistics = ID!["statistics"] as? NSDictionary
                        var all = statistics!["all"] as? NSDictionary
                        battle_avg_xp = all!["battle_avg_xp"] as? Int
                        battles = all!["battles"] as? Int
                        
                        
                        
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
            return (battle_avg_xp,battles, status!, codeError, message, value, field)
        }
        
        let accountID = parseAccountID(nickNameIn)
        var account_id:NSNumber?
        
        if accountID.status == "ok"  { // Проверка статуса
            if accountID.count > 0 { 
        account_id = accountID.account_id // Идентификатор аккаунта игрока
                
            let accountInfo = parseAccountInfo(account_id!)
            println(accountInfo)
            
                
                
            }
            else { outNickName.stringValue = "Ни найден пользователь с таким ником"}
        }
        else
        {
            stringErorr(accountID.codeError!)
        }

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

