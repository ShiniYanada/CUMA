//
//  TimeTableCell.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/24.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit

class TimeTableCell: UICollectionViewCell {
    
    @IBOutlet weak var classTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // Initialization code
    }

}
