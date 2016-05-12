//
//  Connection.swift
//  BookSearch
//
//  Created by Gregory Rudolph on 4/5/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation

class Connection {
    
    let prefix = "https://localhost:8080/api"
    var nullUser = User(e: "null", u: "null", n: "null", un: "u00000000")
    func registerUser(unum: String, data: JSON) -> String {
        let url = NSURL(string: prefix + "/users/register/\(unum)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var message: String = ""
        let postString = data.stringValue
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
            let jsonData = JSON(data: data!)
            message = jsonData["message"].stringValue
        }
        task.resume()
        
        
        return message
    }
    
    func getUser(unum: String) -> User {
        
        let url = NSURL(string: prefix + "/users/get\(unum)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            print("response = \(response)")
            var jsonData = JSON(data!)
            let email = jsonData["email"].stringValue
            let name = jsonData["name"].stringValue
            let username = jsonData["uname"].stringValue
            let ret = User(e: email, u: username, n: name, un: unum)
            self.unNullUser(ret)
            
        }
        
        task.resume()
        return nullUser
    }
    
    func unNullUser(newUser: User) {
        nullUser = newUser
        
    }
    

    func postItem(item: JSON, owner: String) -> String{
        let url = NSURL(string: prefix + "/items/post/\(owner)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString = item.stringValue
        var message = ""
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            print("request = \(request)")
            print(postString)
            let jsonData = JSON(data: data!)
            message = jsonData["message"].stringValue
        }
        task.resume()
        
        
        return message
    }
    
    func postBook(item: JSON, owner: String) -> String{
        let url = NSURL(string: prefix + "/items/post/\(owner)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString = item.stringValue
        var message = ""
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            print("request = \(request)")
            print(postString)
            let jsonData = JSON(data: data!)
            message = jsonData["message"].stringValue
        }
        task.resume()
        
        
        return message
    }
    

    
}