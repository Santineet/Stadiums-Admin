//
//  LoginVCViewController.swift
//  Stadiums-Admin
//
//  Created by Mairambek on 10/13/19.
//  Copyright © 2019 Santineet. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

   
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var phoneNumber: UITextField!
    
    var loginVM: LoginViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.phoneNumber.delegate = self


    }
    
    @IBAction func loginButton(_ sender: UIButton) {
    
        guard let number = phoneNumber.text else { return }
        guard let country = countryCode.text else { return }
        
        if number == "" {
            Alert.displayAlert(title: "", message: "Введите номер телефона", vc: self)
        } else {
            
            let alert = UIAlertController(title: "Номер телефона", message: "Это ваш номер телефона? \n \(country + number)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Да", style: UIAlertAction.Style.default) { (UIAlertAction) in
                sender.isUserInteractionEnabled = false
                sender.alpha = 0.5
                
                let verificationID: String = self.countryCode.text! + self.phoneNumber.text!
                
                self.loginVM = LoginViewModel()
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
                        let enterCodeVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EnterCodeVC") as! EnterCodeVC
                        enterCodeVC.verificationID = verificationID
                        self.phoneNumber.text = ""

                        self.present(enterCodeVC, animated: true, completion: nil)
                        

                    } else {
                        sender.alpha = 1
                        sender.isUserInteractionEnabled = true
                        sender.isEnabled = true
                        Alert.displayAlert(title: "", message: "Произошла ошибка", vc: self)

                    }
                })
            }
            let cancel = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)

 
                
            }
            
            
        }
        
        
    }
    


extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumber.resignFirstResponder()
        return true
    }
    
    
}

