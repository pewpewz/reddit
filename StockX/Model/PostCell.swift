//
//  PostCell.swift
//  StockX
//
//  Created by terrylee on 4/8/21.
//

import UIKit

/// Model used by PostCell
struct PostCellModel {
    let title:String
    let subTitle:String
}

/// Cell for List for each post
class PostCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    func configure(_ model: PostCellModel) {
        self.title.text = model.title
        self.subTitle.text = model.subTitle
        self.backgroundColor = UIColor.clear
    }
}
