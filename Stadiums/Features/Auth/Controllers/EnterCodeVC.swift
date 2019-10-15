//
//  EnterCodeVC.swift
//  Stadiums-Admin
//
//  Created by Mairambek on 10/14/19.
//  Copyright © 2019 Santineet. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseAuth


class EnterCodeVC: UIViewController {

   
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    var loginVM: LoginViewModel?

    var verificationID: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.resendButton.addTarget(self, action: #selector( resendCode(sender:)), for: .touchUpInside)
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        
        guard let code = codeField.text, codeField.text?.count == 6  else {
            Alert.displayAlert(title: "", message: "Убедитесь в правильности кода", vc: self)
            return
        }
        
        let verificationID: String = UserDefaults.standard.string(forKey: "authVerificationID")!
        
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        self.loginVM = LoginViewModel()
        
        
        
        self.loginVM?.authWithPhoneNumber(credential: credential, completion: { (authDataResult, data, error) in
            
            HUD.show(.progress)
            
            guard error == nil else {
                
                Alert.displayAlert(title: "", message: error?.localizedDescription ?? "Произошла ошибка, попробуйте позже", vc: self)
                HUD.hide()
                return
            }
            
            if data != nil {
                
                
                UserDefaults.standard.setValue(1, forKey: "isLoggedIn")
                HUD.hide()
                LoginLogoutManager.instance.updateRootVC()
                
            } else {
                
                if self.loginVM?.logOut() == "Success" {
                    LoginLogoutManager.instance.updateRootVC()
                } else {
                    LoginLogoutManager.instance.updateRootVC()
                }
            }
        })
    }
   
    
    @objc func resendCode(sender: UIButton){
        
        guard let verificationID = self.verificationID else { return }
        
        self.loginVM?.verifyPhoneNumber(verificationID: verificationID, completion: { (data, error) in
            
            guard error == nil else{
                sender.alpha = 1
                sender.isUserInteractionEnabled = true
                sender.isEnabled = true
                
                Alert.displayAlert(title: "", message: error?.localizedDescription ?? "Произошло ошибка", vc: self)
                
                return
            }
            
            if data != nil {
                sender.alpha = 1
                sender.isUserInteractionEnabled = true
                sender.isEnabled = true

                Alert.displayAlert(title: "", message: "СМС с кодом был переотправлен", vc: self)

            } else {
                sender.alpha = 1
                sender.isUserInteractionEnabled = true
                sender.isEnabled = true
                Alert.displayAlert(title: "", message: "Произошла ошибка", vc: self)
                
            }
        })
    }
    
    
}





