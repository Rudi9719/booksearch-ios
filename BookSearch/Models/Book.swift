//
//  Book.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/5/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation
import UIKit

class Book: NSObject {
    var subject: String
    var title: String
    var isbn: String
    var author: String
    var image: UIImage
    var imageURL: String
    var owner: String
    var price: Double
    
    init(subject: String, title: String, isbn: String, author: String, image: String, owner: String, price: String) {
        self.author = author
        self.isbn = isbn
        self.title = title
        self.subject = subject
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
    
    func postBook() {
        var item = [String: String]()
        item["isbn"] = self.isbn
        item["author"] = self.author
        item["title"] = self.title
        item["subject"] = self.subject
        item["image"] = self.imageURL
        item["owner"] = self.owner
        item["price"] = String(self.price)
        let ret = Connection().postItem(JSON(item), owner: owner)
        print(ret)
    }
    
    
    
    
    
    
}
