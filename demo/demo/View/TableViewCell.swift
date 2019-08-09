//
//  TableViewCell.swift
//  demo
//
//  Created by uinpay on 2019/8/1.
//  Copyright © 2019 U-NAS. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(title:String,author:String) {
        self.titleLabel.text = title;
        self.authorLabel.text = author;
    }
    
    @IBAction func forMoreClick(_ sender: UIButton) {
        print("123123");
    }
    
}
