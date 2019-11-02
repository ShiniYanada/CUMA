//
//  ClassCell.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/31.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var classRoomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(lesson: Lesson){
        courseTitleLabel.text = lesson.course
        teacherLabel.text = lesson.teacher
        classRoomLabel.text = lesson.room
    }
    
}
