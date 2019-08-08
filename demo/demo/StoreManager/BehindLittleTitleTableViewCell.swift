//
//  BehindLittleTitleTableViewCell.swift
//  demo
//
//  Created by uinpay on 2019/8/7.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit

class BehindLittleTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var bigTitleLabel: UILabel!
    
    @IBOutlet weak var smallTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setInfo(title:String,author:String) {
        self.bigTitleLabel.text = title;
        self.smallTitleLabel.text = "-"+author;
    }
}
