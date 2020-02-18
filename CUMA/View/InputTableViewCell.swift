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
    @IBOutlet weak var inputTextField: TextFieldForCell!
    var pickerDataList: [String]!
    var delegate: InputTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inputTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // pickerViewの場合にtextFieldに初期値を設定する
    func setInitialValue(pickerData: [String]) {
        inputTextField.text = pickerData[0]
    }
}

extension InputTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.pressReturn(textField)
        return true
    }
}

// このCellのTextFieldでReturnが押下された時にこのprotocolを準拠しているVCに値を渡すためのprotocol
protocol InputTableViewCellDelegate {
    // このdelegateを準拠したprotocolにtexdtFieldインスタンスを渡す
    func pressReturn(_ textField: UITextField) -> ()
}
