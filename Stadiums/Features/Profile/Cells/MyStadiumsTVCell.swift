//
//  MyStadiumsTVCell.swift
//  Stadiums
//
//  Created by Mairambek on 10/17/19.
//  Copyright © 2019 Santineet. All rights reserved.
//

import UIKit

class MyStadiumsTVCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var stadiumImage: UIImageView!
    @IBOutlet weak var stadiumName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stadiumDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        dropShadow(view: myView)
    }

    func dropShadow(view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 8
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
