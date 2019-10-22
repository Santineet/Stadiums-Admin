//
//  TableView.swift
//  Stadiums
//
//  Created by Mairambek on 10/18/19.
//  Copyright © 2019 Santineet. All rights reserved.
//

import UIKit

class TableView: UITableView {

    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        guard let header = tableHeaderView else { return }
        
        let offSetY = -contentOffset.y
   
        height.constant = max(header.bounds.height, header.bounds.height + offSetY)
        
    }

}
