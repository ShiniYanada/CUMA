//
//  InputTableViewCell.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/05.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import UIKit

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var InputTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
