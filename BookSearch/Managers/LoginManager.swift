//
//  LoginManager.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/9/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation

class LoginManager {
    
    func login(email: String?=nil, password: String?=nil, callback: (loginResult: APIResult) -> () ) {
        
        self.setNSDateOfLatestLoginRegister()
        
            AuthenticatedUser.loadUserFromAPI(email, password: password, callback: { (loginResult) -> () in
                if let deviceToken = AppDelegate.appDelegate?.storeManager.getDeviceToken() {
                    APIManager().postDeviceToken(deviceToken, callback: { (result) -> () in
                        if !(result == APIResult.Success) {
                            callbackOnMain(callback, result)
                        }
                    })
                }
                callbackOnMain(callback, loginResult)
            })
        
    }
    
    
    func register(authenticatedUser: AuthenticatedUser, callback: (loginResult: APIResult, info: [String: AnyObject]?) -> () ) {
        AuthenticatedUser.registerUserWithAPI(authenticatedUser) { (loginResult, info) -> () in
            if loginResult == .Success {
                self.setNSDateOfLatestLoginRegister()
                
                if let deviceToken = AppDelegate.appDelegate?.storeManager.getDeviceToken() {
                    APIManager().postDeviceToken(deviceToken, callback: { (result) -> () in
                    })
                }
            }
            callbackOnMain(callback, loginResult, info)
        }
    }
    
    func logout() {
        let apiManager = APIManager()
        if let appDelegate = AppDelegate.appDelegate {
            if let token = appDelegate.storeManager.deviceToken {
                apiManager.deleteDeviceToken(token, callback: { (result) -> () in
                    apiManager.usersLogout()
                })
            } else {
                apiManager.usersLogout()
            }
            appDelegate.storeManager.logout()
            appDelegate.userLoggedOut()
        }
        
    }
    
    // MARK: Helper
    
    func setNSDateOfLatestLoginRegister() {
        let storeManager = AppDelegate.appDelegate?.storeManager
        storeManager?.setInitialLoginDate(NSDate())
    }
}


enum APIResult {
    case Success
    case Failure
    case Canceled
    case Unregistered
    case Error(description: String)
}

func ==(a: APIResult, b: APIResult) -> Bool {
    switch (a, b) {
    case (.Success, .Success): return true
    case (.Failure, .Failure): return true
    case (.Canceled, .Canceled): return true
    case (.Error(let a), .Error(let b)) where a == b: return true
    default: return false
    }
}
