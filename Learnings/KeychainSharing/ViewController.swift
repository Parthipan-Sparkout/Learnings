//
//  ViewController.swift
//  Learnings
//
//  Created by Hxtreme on 21/09/23.
//

import UIKit
import Security
import SwiftKeychainWrapper

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        var domain = "app.test"
        /* let username: String = username.text ?? ""
        let password = passwordField.text?.data(using: .utf8)!

        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username ?? "john",
            kSecValueData as String: password ?? "test",
        ]

        
        SecAddSharedWebCredential("www.example.com" as CFString, username as CFString, passwordField.text! as CFString) { error in
            if error != nil {
             print("error occured")
              return
            }

            // The credentials have been successfully saved.
        } */
     let keyChain = KeychainWrapper(serviceName: "test", accessGroup: "6CWF679Z8N.sharingUserInfo")
       let success = keyChain.set("Parthipan", forKey: "name")
        keyChain.set("Jai", forKey: "subname")
        print(success)
    }
    
    
}

