//
//  ProfileViewModel.swift
//  BffAdmin
//
//  Created by Mairambek on 17/07/2019.
//  Copyright © 2019 Azamat Kushmanov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth


class ProfileViewModel: NSObject {
   
    //    MARK:    Переменные
    let dispose = DisposeBag()
    let profileInfoBR = BehaviorRelay<ProfileInfo>(value: ProfileInfo())
    let errorBR = BehaviorRelay<Error>(value: NSError.init())
    let stadiumBR = BehaviorRelay<(EventType, Stadium)>(value: (EventType.Added, Stadium()))

    var reachability:Reachability?

    //    MARK:    ProfileRepistory object
    //    MARK:    Объект от ProfileRepistory
    let profileRepository = ProfileRepistory()
    
    //    MARK:    Function to retrieve profile information from ProfileRepistory.
    //    MARK:    Функция для получения информации о профиле из ProfileRepistory.
    func getProfileInfo(completion: (Error?) -> ()) {
        if self.isConnnected() == true {
        profileRepository.getProfileInfo()
            .subscribe(onNext: { (profileInfo) in
                self.profileInfoBR.accept(profileInfo)
            }, onError: { (error) in
                self.errorBR.accept(error)
            }).disposed(by: self.dispose)
        } else {
            completion( Constants.CONNECTION_ERROR )
        }
    }

    
    //    AMRK:    Function to log out.
    //    AMRK:    Функция для выхода из системы.
    func logOut(completion: (Error?) -> ()){
        
        if self.isConnnected() == true {
            do {
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                try Auth.auth().signOut()
                LoginLogoutManager.instance.updateRootVC()
//                return "Success"
            } catch {
                print(error)
                let signOutError = error
                completion(NSError.init(message: signOutError.localizedDescription) )
//                return signOutError.localizedDescription
            }
        } else {
            completion( Constants.CONNECTION_ERROR )
        }
        
    }
    
    
    //    MARK:    Function to retrieve profile information from ProfileRepistory.
    //    MARK:    Функция для получения информации о профиле из ProfileRepistory.
    func getStadiums() {
        profileRepository.getStadiums() 
            .subscribe(onNext: { (type, stadium) in
                self.stadiumBR.accept((type, stadium))
            }, onError: { (error) in
                self.errorBR.accept(error)
            }).disposed(by: self.dispose)
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
