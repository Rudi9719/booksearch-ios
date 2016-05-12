//
//  User.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/5/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation

class User: NSObject {
    var email: String
    var username: String
    var name: String
    var unum: String
    var upass: String = ""
    var access_token: String?
    
    init(e: String, u: String, n: String, un: String) {
        self.email = e
        self.username = u
        self.name = n
        self.unum = un
        
    }
    init(e: String, u: String, n: String, p: String, un: String) {
        self.email = e
        self.username = u
        self.name = n
        self.unum = un
        self.upass = p
        
    }
    

    func getAccessToken() -> String? {
        return access_token
    }
   
    func registerUser() {
        var user = [String:String]()
        user["uname"] = username
        user["upass"] = upass
        user["email"] = email
        user["name"] = name
       
        
        
        
        
    }
    func toDict() -> Dictionary<String, AnyObject> {
        var user : Dictionary<String, AnyObject> = [:]
        user["uname"] = username
        user["upass"] = upass
        user["email"] = email
        user["name"] = name
        
        return user
        
    }


}