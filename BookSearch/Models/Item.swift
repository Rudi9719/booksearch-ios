//
//  Item.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/5/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject {
    var type: String
    var name: String
    var image: UIImage
    var imageURL: String
    var owner: String
    var price: Double
    
    init(type: String, name: String, image: String, owner: String, price: String) {
        self.type = type
        self.name = name
        self.owner = owner
        self.price = Double(price) ?? 0.0
        self.image = UIImage()
        if let url = NSURL(string: image) {
            if let data = NSData(contentsOfURL: url) {
                self.image = UIImage(data: data)!
            }        
        }
        self.imageURL = image
        
    }
    
    func postItem() {
        var item = [String: String]()
        item["type"] = self.type
        item["name"] = self.name
        item["image"] = self.imageURL
        item["owner"] = self.owner
        item["price"] = String(self.price)
        let ret = Connection().postItem(JSON(item), owner: owner)
        print(ret)
        
    }


    
    

   
}
