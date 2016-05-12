//
//  ItemDetailView.swift
//  BookSearch
//
//  Created by Gregory Rudolph-Alverson on 4/5/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailView: UIViewController {
    
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var priceView: UILabel!
    @IBOutlet weak var typeView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var listing: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameView.text = listing?.name
        priceView.text = String(listing?.price)
        typeView.text = listing?.type
        imageView.image = listing?.image
        
    }

    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        // Go back
        
    }
    @IBAction func imageLongPressed(sender: UILongPressGestureRecognizer) {
        // Contact sender or share
        
    }
    func shareListing() {
        let textToShare = "Check out this listing on BookSearch!"
        
        if let listingWebsite = NSURL(string: "booksearch.stein13.net/path/to/call/item") {
            let objectsToShare = [textToShare, listingWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    func contactOwner() {
        let email = listing?.owner
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}