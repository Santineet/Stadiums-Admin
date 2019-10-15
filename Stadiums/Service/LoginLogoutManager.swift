//
//  LoginLogoutManager.swift
//  BffClient
//
//  Created by Avazbek Kodiraliev on 6/10/19.
//  Copyright © 2019 Avazbek Kodiraliev. All rights reserved.
//

import UIKit
import  Firebase

class LoginLogoutManager: NSObject {
    
    static let instance = LoginLogoutManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateRootVC() {
        if (Auth.auth().currentUser?.phoneNumber == nil && UserDefaults.standard.value(forKey: "isLoggedIn") == nil){
            let vc = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
        appDelegate.window?.makeKeyAndVisible()

    }
}
