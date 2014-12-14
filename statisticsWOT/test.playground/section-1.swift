// Playground - noun: a place where people can play

import UIKit
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely()

func getJSON(urlToRequest: String) -> NSData{
    return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
}
func parseJSON(inputData: NSData) -> NSDictionary{
    var error: NSError?
    var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
    
    return boardsDictionary
}


//  Поиск по никнейму игрока и узнать его account_id.
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
    return (account_id,nickname, status!, codeError, message, value, field)
}
println(parseAccountID("sundnepr").account_id!)