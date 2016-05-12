//
//  Connection.swift
//  BookSearch
//
//  Created by Gregory Rudolph on 4/5/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    private struct APIURLEndpoint {
        private static let prefix = NSBundle.mainBundle().infoDictionary!["BookSearchBaseAPIURL"] as! String
        
        static let UsersLogin =             APIURLEndpoint.url("users/login")!
        static let UsersLogout =            APIURLEndpoint.url("users/logout")!
        static let UsersResetPassword =     APIURLEndpoint.url("users/reset-password")!
        static let UsersForgotPassword =    APIURLEndpoint.url("users/forgot-password")!
        
        
        
        static func UsersRegister(unum: String) -> NSURL? {
            return self.url("users/register/\(unum)")
        }
        
        static let Devices =                APIURLEndpoint.url("devices")!
        static func DeviceDelete(deviceToken: String) -> NSURL? {
            return self.url("devices/\(deviceToken)")
        }
        
        private static func url(suffix: String) -> NSURL? {
            return NSURL(string: prefix.stringByAppendingString(suffix))
        }
    }
    
    let accessToken = AppDelegate.appDelegate?.storeManager.getAccessToken()
    
    func registerUser(authenticatedUser: AuthenticatedUser, callback: (loginResult: APIResult, jsonDictionary: Dictionary<String, AnyObject>?) -> () ) {
        
        let body = authenticatedUser.user.toDict() 
        postJSON(headers: nil, body: body, url: APIURLEndpoint.UsersRegister(authenticatedUser.user.unum)!) { (statusCode, jsonDictionary) -> () in
            if statusCode == 200 {
                callbackOnMain(callback, .Success, jsonDictionary)
            } else {
                callbackOnMain(callback, .Failure, jsonDictionary)
            }
        }
    }
    func userLoginWithEmail(email: String, password: String, callback:(loginResult: APIResult, userJSONDictionary: Dictionary<String, AnyObject>?) -> ()) {
        
        let toBody = ["email": email, "password": password, "login_type": "email"]
        
        postJSON(headers: nil, body: toBody, url: APIURLEndpoint.UsersLogin, logoutOnUnauthorized: false) { (statusCode, jsonDictionary) in
            if statusCode == 200 {
                callbackOnMain(callback, .Success, jsonDictionary)
            } else {
                callbackOnMain(callback, .Failure, jsonDictionary)
            }
        }
    }
    func userLoginWithUsername(username: String, password: String, callback:(loginResult: APIResult, userJSONDictionary: Dictionary<String, AnyObject>?) -> ()) {
        
        let toBody = ["uname": username, "upass": password]
        
        postJSON(headers: nil, body: toBody, url: APIURLEndpoint.UsersLogin, logoutOnUnauthorized: false) { (statusCode, jsonDictionary) in
            if statusCode == 200 {
                callbackOnMain(callback, .Success, jsonDictionary)
            } else {
                callbackOnMain(callback, .Failure, jsonDictionary)
            }
        }
    }

    func usersLogout() {
        var headers = Dictionary<String,String>()
        if AuthenticatedUser.isValid {
            headers["Authorization"] = AuthenticatedUser.sharedInstance()?.apiAccessToken
        }
        
        postJSON(headers: headers, body: nil, url: APIURLEndpoint.UsersLogout, logoutOnUnauthorized: false) { (statusCode, jsonDictionary) in
            // TODO: once we change the callback, we may want to note that the logout didn't complete (perhaps for network reasons)
        }
    }

    func resetPassword(password: String, resetToken: String, callback:(resetResult: APIResult, jsonDictionary: Dictionary<String, AnyObject>?) -> Void) {
        
        let toBody = ["password": password, "reset_token": resetToken]
        
        postJSON(headers: nil, body: toBody, url: APIURLEndpoint.UsersResetPassword) { (statusCode, jsonDictionary) in
            if statusCode == 200 {
                callbackOnMain(callback, .Success, jsonDictionary)
            } else {
                callbackOnMain(callback, .Failure, jsonDictionary)
            }
        }
    }
    
    func forgotPassword(email: String, callback:(resetResult: APIResult, jsonDictionary: Dictionary<String, AnyObject>?) -> Void) {
        
        let toBody = ["email": email]
        
        postJSON(headers: nil, body: toBody, url: APIURLEndpoint.UsersForgotPassword) { (statusCode, jsonDictionary) in
            if statusCode == 200 {
                callbackOnMain(callback, .Success, jsonDictionary)
            } else {
                callbackOnMain(callback, .Failure, jsonDictionary)
            }
        }
    }
    func postJSON(headers headers: Dictionary<String,String>?, requestType: String? = nil, body : Dictionary<String, AnyObject>? = nil, url: NSURL, logoutOnUnauthorized: Bool = true, callback: (statusCode: Int, jsonDictionary: Dictionary<String, AnyObject>?) -> () ) {
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 10)
        let session = NSURLSession.sharedSession()
        
        if let typeOfRequest = requestType {
            request.HTTPMethod = typeOfRequest
        } else {
            request.HTTPMethod = "POST"
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Accept")
        
        if headers != nil {
            for (header, value) in headers! {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        if body != nil {
            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(body!, options: NSJSONWritingOptions(rawValue: 0))
        }
        
        let task = session.dataTaskWithRequest(request) {data, response, error -> Void in
            
            guard let httpUrlResponse = response as? NSHTTPURLResponse else {
                print("there was a problem converting the response to HTTP")
                callbackOnMain(callback, error?.code ?? 0, error?.userInfo as? [String: AnyObject])
                return
            }
            
            if error != nil {
                print("There was an error processing the request")
                print("Error: \(error)")
                print("Response: \(response)")
            }
            
            guard let dataUnwrapped = data else {
                print("Response data was nil")
                callbackOnMain(callback, error?.code ?? 0, error?.userInfo as? [String: AnyObject])
                return
            }
            
            if dataUnwrapped.length > 0 {
                guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: NSJSONReadingOptions(rawValue: 0)) else {
                    print("Error reading JSON response data from API call")
                    callbackOnMain(callback, error?.code ?? 0, error?.userInfo as? [String: AnyObject])
                    return
                }
                
                guard let jsonDictionary = jsonObject as? Dictionary<String, AnyObject> else {
                    print("Error converting JSON NSDictionary to Swift Dictionary")
                    callbackOnMain(callback, error?.code ?? 0, error?.userInfo as? [String: AnyObject])
                    return
                }
                
                if httpUrlResponse.statusCode == 401 && logoutOnUnauthorized {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        LoginManager().logout()
                    })
                } else {
                    callbackOnMain(callback, httpUrlResponse.statusCode, jsonDictionary)
                }
            } else {
                callbackOnMain(callback, httpUrlResponse.statusCode, nil)
            }
        }
        task.resume()
    }
    
    func getJSON(url: NSURL, accessToken: String? = nil, logoutOnUnauthorized: Bool = true, callback:(statusCode: Int, jsonDictionary: Dictionary<String, AnyObject>?) -> ()) {
        performRequest("GET", url: url, accessToken: accessToken, logoutOnUnauthorized: logoutOnUnauthorized, callback: callback)
    }
    
    func deleteJSON(url: NSURL, accessToken: String? = nil, logoutOnUnauthorized: Bool = true, callback:(statusCode: Int, jsonDictionary: Dictionary<String, AnyObject>?) -> ()) {
        performRequest("DELETE", url: url, accessToken: accessToken, logoutOnUnauthorized: logoutOnUnauthorized, callback: callback)
    }
    
    func performRequest(method: String, url: NSURL, accessToken: String? = nil, logoutOnUnauthorized: Bool = true, callback:(statusCode: Int, jsonDictionary: Dictionary<String, AnyObject>?) -> ()) {
        let request = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 10)
        
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = method
        
        if let token = accessToken {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request) { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard let httpUrlResponse = response as? NSHTTPURLResponse else {
                print("there was a problem converting the response to HTTP")
                return
            }
            
            if error != nil {
                print("There was an error processing the request")
                print("Error: \(error)")
                print("Response: \(response)")
            }
            
            guard let dataUnwrapped = data else {
                print("Response data was nil")
                return
            }
            
            if dataUnwrapped.length > 0 {
                guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(dataUnwrapped, options: NSJSONReadingOptions(rawValue: 0)) else {
                    print("Error reading JSON response data from API call")
                    return
                }
                
                guard let jsonDictionary = jsonObject as? Dictionary<String, AnyObject> else {
                    print("Error converting JSON NSDictionary to Swift Dictionary")
                    return
                }
                
                if httpUrlResponse.statusCode == 401 && logoutOnUnauthorized {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                       // LoginManager().logout()
                    })
                } else {
                    callbackOnMain(callback, httpUrlResponse.statusCode, jsonDictionary)
                }
            } else {
                callbackOnMain(callback, httpUrlResponse.statusCode, nil)
            }
        }
        
        task.resume()
    }
    
    // Helpers
    
    func keyValueToQueryParam(key: String, value: String) -> String {
        let percentEscapedKey = key.stringByAddingPercentEncodingForURLQueryValue()!
        let percentEscapedValue = value.stringByAddingPercentEncodingForURLQueryValue()!
        return "\(percentEscapedKey)=\(percentEscapedValue)"
 
    }
    
    // Convert from JSON to nsdata
    func jsonToNSData(json: AnyObject?) -> NSData?{
        guard let json = json else {
            return nil
        }
        
        do {
            return try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions(rawValue: 0))
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }


    
    func postDeviceToken(deviceToken: NSData, callback: (result: APIResult) -> () ) {
        if let accessToken = AppDelegate.appDelegate?.storeManager.getAccessToken() {
            let headers = ["Authorization": accessToken]
            let tokenString = dataToHex(deviceToken)
            postJSON(headers: headers, body: ["device_token": tokenString], url: APIURLEndpoint.Devices) { (statusCode, jsonDictionary) -> () in
                print(jsonDictionary)
                if statusCode == 200 {
                    callbackOnMain(callback, .Success)
                } else {
                    callbackOnMain(callback, .Failure)
                }
            }
        } else {
            callbackOnMain(callback, .Error(description: "No access token"))
        }
    }
    
    func deleteDeviceToken(deviceToken: NSData, callback: (result: APIResult) -> () ) {
        if let accessToken = AppDelegate.appDelegate?.storeManager.getAccessToken(),
            url = APIURLEndpoint.DeviceDelete(dataToHex(deviceToken)) {
            let headers = ["Authorization": accessToken]
            postJSON(headers: headers, requestType: "DELETE", url: url) { (statusCode, jsonDictionary) -> () in
                print(jsonDictionary)
                if statusCode == 200 {
                    callbackOnMain(callback, .Success)
                } else {
                    callbackOnMain(callback, .Failure)
                }
            }
        } else {
            callbackOnMain(callback, .Error(description: "No access token"))
        }
    }
    
    // see http://stackoverflow.com/a/26346543/357641
    func dataToHex(data: NSData) -> String {
        var str: String = String()
        let p = UnsafePointer<UInt8>(data.bytes)
        let len = data.length
        
        for i in 0 ..< len {
            str += String(format: "%02.2X", p[i])
        }
        
        return str.lowercaseString
    }
}

extension Int {
    func toBool() -> Bool? {
        switch self {
        case 1:
            return true
        case 0:
            return false
        default:
            return nil
        }
    }
}

extension String {
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._~")
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joinWithSeparator("&")
    }

}