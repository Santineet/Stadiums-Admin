//
//  ProfileTVC.swift
//  Stadiums
//
//  Created by Mairambek on 10/15/19.
//  Copyright © 2019 Santineet. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift
import SDWebImage


class ProfileTVC: UITableViewController {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var profileVM: ProfileViewModel?
    var profileInfo = ProfileInfo()
    var stadiums = [Stadium]()
    let dispose = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Профиле"
        getProfileInfo()
        tableView.allowsSelection = false
        setupProfileImageViewStyle()
    }
    
    func setupProfileImageViewStyle(){
        //        profileImage.frame = CGRect(x:0, y: 0, width: 1, height: 150)
        let imageBounds:CGFloat = userImage.bounds.size.width
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = 0.5 * imageBounds
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.contentMode = .scaleAspectFill
        userImage.isUserInteractionEnabled = false
    }
    
    
    
    func getProfileInfo() {
        HUD.show(.progress)
        self.profileVM = ProfileViewModel()
        self.profileVM?.getProfileInfo(completion: { (error) in
            if let error = error {
                HUD.hide()
                Alert.displayAlert(title: "", message: error.localizedDescription, vc: self)
            }
        })
        
        self.profileVM?.profileInfoBR.skip(1).subscribe(onNext: { (profileInfo) in
            self.profileInfo = profileInfo

            self.setupOutlets()
            
            self.getStadiums()
        }, onError: { (error) in
            HUD.hide()
        }).disposed(by: self.dispose)
        
    }
    
    func getStadiums(){
        
        self.profileVM = ProfileViewModel()
        self.profileVM?.getStadiums()
        self.profileVM?.stadiumBR.skip(1).subscribe(onNext: { (type, stadium) in
            
            self.tableView.reloadData()
            HUD.hide()
            switch type {
            case .Added:
                if let index = self.stadiums.firstIndex(where: { (item) -> Bool in
                    return item.id == stadium.id
                }){
                    self.stadiums[index] = stadium
                    self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }else{
                    self.stadiums.append(stadium)
                    self.tableView.insertRows(at: [IndexPath(row: self.stadiums.count-1, section: 0)], with: .automatic)
                }
                break
            case .Changed:
                if let index = self.stadiums.firstIndex(where: { (item) -> Bool in
                    return item.id == stadium.id
                }){
                    self.stadiums[index] = stadium
                    self.tableView.insertRows(at: [IndexPath(row: self.stadiums.count-1, section: 0)], with: .automatic)
                }
                break
            case .Removed:
                if let index = self.stadiums.firstIndex(where: { (item) -> Bool in
                    return item.id == stadium.id
                }){
                    self.stadiums.remove(at: index)
                    self.tableView.insertRows(at: [IndexPath(row: self.stadiums.count-1, section: 0)], with: .left)
                }
                break
            }
        }).disposed(by: dispose)
    }

    func setupOutlets(){
        
        self.name.text = self.profileInfo.name
        self.phoneNumber.text = self.profileInfo.numberPhone
        self.userImage.sd_setImage(with: URL(string:self.profileInfo.previewImageUrl), placeholderImage: UIImage(named: ""))
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.stadiums.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0{

            let cell = tableView.dequeueReusableCell(withIdentifier: "AddStadiumCell", for: indexPath) as! AddStadiumCell

            cell.addStadiumButton.addTarget(self, action: #selector(addStadiumButtonTapped), for: .touchUpInside)
            return cell

        }
        
        let stadium = self.stadiums[indexPath.row - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyStadiumsTVCell", for: indexPath) as! MyStadiumsTVCell

        cell.stadiumName.text = stadium.stadName
        cell.stadiumDescription.text = stadium.stadDescription
        cell.price.text = stadium.price

        cell.stadiumImage.sd_setImage(with: URL(string:stadium.images.first?.originalUrl ?? ""), placeholderImage: UIImage(named: ""))
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 70
        } else {
            return 210
        }

    }
    
    @objc func addStadiumButtonTapped(){
    
        Alert.displayAlert(title: "", message: "Кнопка еще не кликабельна", vc: self)
        
    }

    

}
