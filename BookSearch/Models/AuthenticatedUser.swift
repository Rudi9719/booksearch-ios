//
//  AuthenticatedUser.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/9/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import UIKit

class AuthenticatedUser {
    
    // there can only be a single authenticated user at a time
    private static var _authenticatedUser: AuthenticatedUser?
    
    static func sharedInstance() -> AuthenticatedUser? {
        return _authenticatedUser
    }
    
    static var isValid: Bool {
        get {
            return _authenticatedUser != nil
        }
    }
    
    // instance properties and methods
    
    let apiAccessToken: String?
    let user: User
    
    private init(apiAccessToken: String?, userJSONDictionary: Dictionary<String, AnyObject>) {
        self.apiAccessToken = apiAccessToken
        let email: String = userJSONDictionary["email"]!.stringValue
        let username: String = userJSONDictionary["uname"]!.stringValue
        let name: String = userJSONDictionary["name"]!.stringValue
        let unum = userJSONDictionary["unum"]!.stringValue
        
        self.user = User(e: email, u: username, n: name, un: unum)
        
    }
    
    func logout() {
        APIManager().usersLogout()
        AuthenticatedUser._authenticatedUser = nil
        AppDelegate.appDelegate?.storeManager.logout()
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.userLoggedOut()
    }

    // class methods
    
    class func loadUserFromAPIFromAutoLogin(jsonDictionary: Dictionary<String, AnyObject>) -> User {
        
       
        let authenticatedUser = AuthenticatedUser(apiAccessToken: jsonDictionary["access_token"] as? String, userJSONDictionary: jsonDictionary)
        
        AuthenticatedUser._authenticatedUser = authenticatedUser
        
        if let accessToken = jsonDictionary["access_token"] as? String {
            let storeManager = AppDelegate.appDelegate?.storeManager
            storeManager?.setLoginUser(authenticatedUser.user)
            storeManager?.setAccessToken(accessToken)
        }
        return authenticatedUser.user
    }
    
    class func loadUserFromAPI(username: String? = nil, password: String? = nil, callback: (loginResult: APIResult) -> () ) {
        
        // nil this out, to make sure it is empyt even if the load fails
        AuthenticatedUser._authenticatedUser = nil
        
        
        
            
            APIManager().userLoginWithUsername(username!, password: password!) { (loginResult, userJSONDictionary) -> () in
                if loginResult == .Success {
                    guard let _ = userJSONDictionary?["access_token"] as? String else {
                        callbackOnMain(callback, .Error(description: "Access Token missing from server response"))
                        return
                    }
                }
                
                let authenticatedUser = AuthenticatedUser(apiAccessToken: userJSONDictionary?["access_token"] as? String, userJSONDictionary: userJSONDictionary!)
                
                AuthenticatedUser._authenticatedUser = authenticatedUser
                
                if let accessToken = userJSONDictionary?["access_token"] as? String {
                    let storeManager = AppDelegate.appDelegate?.storeManager
                    storeManager?.setLoginUser(authenticatedUser.user)
                    storeManager?.setAccessToken(accessToken)
                }
                
               callbackOnMain(callback, loginResult)
            }
            
        
    }
    class func registerUserWithAPI(authenticatedUser: AuthenticatedUser, callback: (loginResult: APIResult, info: [String: AnyObject]?) -> () ) {
        if let authenticatedUser = sharedInstance() {
            APIManager().registerUser(authenticatedUser) { (loginResult, jsonDictionary) -> () in
                if loginResult == .Success {
                    AuthenticatedUser.loadUserFromAPI(callback: { (loginResult) -> () in
                        callbackOnMain(callback, loginResult, nil)
                    })
                } else {
                    callbackOnMain(callback, loginResult, jsonDictionary)
                }
            }
        }
    }

    
}
