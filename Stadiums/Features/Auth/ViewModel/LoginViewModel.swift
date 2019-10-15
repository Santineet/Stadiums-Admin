//
//  LoginViewModel.swift
//  Stadiums-Admin
//
//  Created by Mairambek on 10/14/19.
//  Copyright © 2019 Santineet. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel: NSObject{
    
    var reachability:Reachability?

    
    //    MARK:    Function to authorization with PhoneNumber.
    //    MARK:    Функция для авторизации через PhoneNumber.
    func verifyPhoneNumber(verificationID:String, completion: @escaping (Data?, Error?) -> ()) {
        if self.isConnnected() == true {
            
            PhoneAuthProvider.provider().verifyPhoneNumber(verificationID, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    completion(nil, error)
                }
                if verificationID != nil {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    completion(Data.init(), nil)
                }
            }
        } else {
            completion(nil, NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    //    MARK:    Function to authorization with phone number.
    //    MARK:    Функция для авторизации через номер телефона.
    func authWithPhoneNumber(credential:AuthCredential, completion: @escaping (AuthDataResult?, Data?, Error?) -> ()) {
        if self.isConnnected() == true {
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if error != nil {
                    completion(nil, nil, error)
                    return
                }
                if authDataResult != nil {
                    completion(authDataResult, Data.init(), nil)
                }
            }
        } else {
            completion(nil, nil, NSError.init(message: "Для получения данных требуется подключение к интернету"))
        }
    }
    
    func logOut() -> String {
        do {
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            try Auth.auth().signOut()
            LoginLogoutManager.instance.updateRootVC()
            return "Success"
        } catch let signOutError as NSError {
            return signOutError.localizedDescription
        }
    }
    

    
    
    
    //    MARK:    Internet check function.
    //    MARK:    Функция для проверки интернета.
    func isConnnected() -> Bool{
        do {
            try reachability = Reachability.init()
            
            if (self.reachability?.connection) == .wifi || (self.reachability?.connection) == .cellular {
                return true
            } else if self.reachability?.connection == .unavailable {
                return false
            } else if self.reachability?.connection == .none {
                return false
            } else {
                return false
            }
        }catch{
            return false
        }
    }
    
    
    
}
