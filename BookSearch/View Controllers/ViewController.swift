//
//  ViewController.swift
//  BookSearch
//
//  Created by Gregory Rudolph on 4/4/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var InterfaceView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.InterfaceView.layer.cornerRadius = 8.0
        testPaths()
        
    }

    @IBAction func loginClicked(sender: AnyObject) {
    }
    
    @IBAction func registerClicked(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func testPaths() {
        var item1: Item
        var item2: Item
        var book1: Book
        var book2: Book
        var user1: User
        
        user1 = User(e: "rudolpg@sunyit.edu", u: "rudolpg", n: "Gregory Rudolph", p: "Password1", un: "u00284828")
        user1.registerUser()
        sleep(10)

        
        item1 = Item(type: "fridge", name: "IdkFridge", image: "/static/img/logo.png", owner: "u00284828", price: "50.00")
        item2 = Item(type: "TV", name: "Samsung 22 Inch", image: "/static/img/logo.png", owner: "u00284828", price: "50.00")
        book1 = Book(subject: "PSY", title: "Psychology 101", isbn: "ISBNISBNISBIN", author: "Doctor Cavic", image: "/static/img/logo.png", owner: "u00284828", price: "800.00")
        book2 = Book(subject: "ENG", title: "50 Shades of White", isbn: "ISBNISBNISBIN", author: "Anne Rice", image: "/static/img/logo.png", owner: "u00284828", price: "24.00")
        
        item1.postItem()
        item2.postItem()
        book1.postBook()
        book2.postBook()
        
        
    }


}

