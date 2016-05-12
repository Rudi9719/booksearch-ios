//
//  RegisterView.swift
//  BookSearch
//
//  Created by Gregory Rudolph on 4/4/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import UIKit

class RegisterView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var registerFormView: UIView!
    @IBOutlet weak var registerButtonView: UIView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var uNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    let nextField = [1:2, 2:3, 3:4, 4:5, 5:6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        setViewEdges()
        for i in 1...6 {
            if let textField = self.view.viewWithTag(i) as? UITextField {
                textField.delegate = self
            }
        }
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewEdges() {
        self.registerFormView.layer.cornerRadius = 8.0
        self.registerButtonView.layer.cornerRadius = 8.0
    }
   
    // This is called when the user hits the Next/Return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Consult our dictionary to find the next field
        if let nextTag = nextField[textField.tag] {
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                // Have the next field become the first responder
                nextResponder.becomeFirstResponder()
            }
        }
        if (textField.tag == 6) {
            self.view.endEditing(true)
        }
        // Return false here to avoid Next/Return key doing anything
        return false
    }
    
    func registerUser() {
        
    }

}
