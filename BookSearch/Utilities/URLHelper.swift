//
//  URLHelper.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/9/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation
import UIKit

class URLHelper {
    
    class func isValidUrl(urlString: String) -> Bool {
        guard let url = NSURL(string: urlString) else {
            // URL cannot be created with the string
            return false
        }
        
        // Check if scheme exists
        let urlScheme = url.scheme.lowercaseString
        guard (urlScheme == "http" || urlScheme == "https") else {
            return false
        }
        
        // Check if host exists
        guard let urlHost = url.host where !urlHost.isEmpty else {
            return false
        }
        
        return UIApplication.sharedApplication().canOpenURL(url)
    }
}