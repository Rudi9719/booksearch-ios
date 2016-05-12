//
//  LoginView.swift
//  BookSearch
//
//  Created by Gregory Rudolph on 4/4/16.
//  Copyright © 2016 STEiN-Net. All rights reserved.
//

import UIKit

class LoginView: UIViewController {
    
    @IBOutlet weak var loginForm: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var uName: UITextField!
    @IBOutlet weak var uPass: UITextField!
    @IBOutlet weak var registerView: UIView!

    var tapLogin = UITapGestureRecognizer()
    var tapForgotPassword = UITapGestureRecognizer()
    var tapRegister = UITapGestureRecognizer()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNeedsStatusBarAppearanceUpdate()
        setViewEdges()

        
        tapLogin.addTarget(self, action: #selector(LoginView.login))
        
        tapForgotPassword.addTarget(self, action: #selector(LoginView.forgotPassword))
        
        tapRegister.addTarget(self, action: #selector(LoginView.register))
        
        registerView.addGestureRecognizer(tapRegister)
        loginView.addGestureRecognizer(tapLogin)
        forgotPasswordView.addGestureRecognizer(tapForgotPassword)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setViewEdges() {
        
        self.loginForm.layer.cornerRadius = 8.0
        self.loginView.layer.cornerRadius = 8.0
        self.forgotPasswordView.layer.cornerRadius = 8.0
    }
    
    func login() {
        print("Login tapped")
        
    }
    
    func forgotPassword() {
        print("Forgot Password tapped")
    }
    func register() {
        print("Register clicked")
    }
    
    
}

