//
//  ViewController.swift
//  MyMoves
//
//  Created by Travis Whitten on 10/7/16.
//  Copyright © 2016 Travis Whitten. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.stringForKey(KEY_UID) {
            print("TRAVIS: ID found in keychain")
            performSegue(withIdentifier: "goToProfile", sender: nil)
        }
    }


    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("TRAVIS: Unable to authenticate with Facebook - \(error)")
            }else if result?.isCancelled == true {
                print("TRAVIS: User cancelled Facebook authentication")
            } else {
                print ("TRAVIS: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        
    }

  }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("TRAVIS: Unable to authenticate with Firebase - \(error)")
                
            } else {
                print("TRAVIS: Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                    
                }
            }
    })
  }

    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: {(user, error) in
                if error == nil {
                    print("TRAVIS: Email user auth with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("TRAVIS: BIG EORROR-\(error)")
                        } else {
                            print ("TRAVIS: Successfully signed up with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)                            }
                        }
                    })
                }
        })
        
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        print("TRAVIS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToProfile", sender: nil)
        
    }
    
}
