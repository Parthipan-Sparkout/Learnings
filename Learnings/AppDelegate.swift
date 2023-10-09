//
//  AppDelegate.swift
//  Learnings
//
//  Created by Hxtreme on 21/09/23.
//

import UIKit

struct Country {
    
}

struct Address {
    let city: String
}

@dynamicMemberLookup
struct User {
    let address: Address
    // It will return city
    subscript(dynamicMember member: String) -> String {
        if member == "city" {
            return address.city
        } else {
            return address.city
        }
    }
    
    // It will return city
    subscript(dynamicMember member: Int) -> String {
        if member == 1 {
            return address.city
        } else {
            return address.city
        }
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let a: [String: String] = ["dfdf": "fdfdf"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

