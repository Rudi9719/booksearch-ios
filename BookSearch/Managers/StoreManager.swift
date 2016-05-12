//
//  StoreManager.swift
//  BookSearch
//
//  Created by Gregory Rudolph on 4/9/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation

class StoreManager {
    
    var supportDirectory = String()
    var cacheDirectory = String()
    var userLock: NSLocking
    var accessToken: String?
    var deviceToken: NSData?
    
    init() {
        let rootSupportDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let pathSupportDirectory = NSBundle.mainBundle().bundleIdentifier
        
        let rootCacheDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last
        let pathCacheDirectory = NSBundle.mainBundle().bundleIdentifier
        
        supportDirectory = rootSupportDirectory! + "/" + pathSupportDirectory!
        cacheDirectory = rootCacheDirectory! + "/" + pathCacheDirectory!
        userLock = NSRecursiveLock()
    }
    
    func cacheDirectoryForUsername(username: String) -> String {
        
        let directory = self.cacheDirectory.stringByAppendingString("/\(username)")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(directory) {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(directory, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Error creating directory=\(directory), error=\(error)")
            }
            
            print("Created directory=\(directory)")
            
        }
        return directory
    }
    
    // MARK - Archive to Disk
    
    func archive(object: AnyObject?, path: String) {
        if path.characters.count == 0 {
            print("Asked to archive an object to an empty path, skipping archive.")
            return
        }
        
        if object == nil {
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                print("Clearing archive \(path)")
                
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(path)
                } catch let error as NSError {
                    print("Error deleting archive path=\(path), error=\(error)")
                }
                
            }
        } else {
            NSKeyedArchiver.archiveRootObject(object!, toFile: path)
            print("Archiving object=\(object) to path=\(path)")
        }
    }
    
    func unarchive(path: String) -> AnyObject? {
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            return NSKeyedUnarchiver.unarchiveObjectWithFile(path)!
        }
        return nil
    }
    
    // MARK - Save to Keychain
    
    func saveToKeychain(key: String, data: NSData) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ]
        
        SecItemDelete(query as CFDictionaryRef)
        
        let status: OSStatus = SecItemAdd(query as CFDictionaryRef, nil)
        
        return status == noErr
    }
    
    func deleteFromKeychain(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key]
        
        let status: OSStatus = SecItemDelete(query as CFDictionaryRef)
        
        return status == noErr
    }
    
    func loadFromKeychain(key: String) -> NSData? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne ]
        
        var dataTypeRef: AnyObject?
        let status = withUnsafeMutablePointer(&dataTypeRef) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let data = dataTypeRef as! NSData? {
                return data
            }
        } else {
            print("loadFromKeychain unsuccessful: \(status)")
        }
        return nil
    }
    
    // MARK - Stored Data
    
    func setConfig(config:Dictionary<String,AnyObject>) {
        self.userLock.lock()
        let path = self.cacheDirectory.stringByAppendingString("/config")
        self.archive(config, path: path)
        self.userLock.unlock()
    }
    
    func getConfig() -> Dictionary<String,AnyObject>? {
        self.userLock.lock()
        let path = self.cacheDirectory.stringByAppendingString("/config")
        return self.unarchive(path) as? Dictionary<String,AnyObject>
        self.userLock.unlock()
    }
    
    func setLoginUser(user : User) {
        self.userLock.lock()
        let path = self.cacheDirectory.stringByAppendingString("/user")
        self.archive(user, path: path)
        self.userLock.unlock()
    }
    
    func clearLoginUser() {
        let path = self.cacheDirectory.stringByAppendingString("/user")
        self.archive(nil, path: path)
    }
    
    func getLoginUser() -> User? {
        self.userLock.lock()
        let path = self.cacheDirectory.stringByAppendingString("/user")
        return self.unarchive(path) as? User
        self.userLock.unlock()
    }
    
    func setInitialLoginDate(initialDate: NSDate) {
        NSUserDefaults.standardUserDefaults().setObject(initialDate, forKey: "initialDate")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getInitialLoginDate() -> NSDate? {
        return NSUserDefaults.standardUserDefaults().objectForKey("initialDate") as? NSDate
    }
    
    func setDateElapsedSinceInitialLogin(daysElapsed: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(daysElapsed, forKey: "daysElapsed")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getDateElapsedSinceInitialLogin() -> Int? {
        return NSUserDefaults.standardUserDefaults().integerForKey("daysElapsed") as Int
    }
    
    
    func setResetPasswordToken(token: String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "resetPasswordToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func clearResetPasswordToken() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("resetPasswordToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getResetPasswordToken() -> String {
        return NSUserDefaults.standardUserDefaults().objectForKey("resetPasswordToken") as! String
    }
    
    func setAccessToken(accessToken : String) {
        if let accessTokenData = accessToken.dataUsingEncoding(NSUTF8StringEncoding) {
            saveToKeychain("accessToken", data: accessTokenData)
            self.accessToken = accessToken
        }
    }
    
    func clearAccessToken() {
        deleteFromKeychain("accessToken")
        self.accessToken = nil
    }
    
    func getAccessToken() -> String? {
        if let accessToken = accessToken {
            return accessToken
        }
        
        guard let accessTokenData = loadFromKeychain("accessToken") else {
            return nil
        }
        
        accessToken = String(data: accessTokenData, encoding: NSUTF8StringEncoding)
        return accessToken
    }
    
    func setDeviceToken(deviceToken: NSData) {
        saveToKeychain("deviceToken", data: deviceToken)
        self.deviceToken = deviceToken
    }
    
    func getDeviceToken() -> NSData? {
        if let deviceToken = deviceToken {
            return deviceToken
        }
        
        deviceToken = loadFromKeychain("deviceToken")
        return deviceToken
    }
    
    func logout() {
        clearLoginUser()
        clearResetPasswordToken()
        clearAccessToken()
    }
    
}