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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // keyboardをpickerViewにする
    func changeKeyboardTypeToPickerView(pickerData: [String]) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerDataList = pickerData
        inputTextField.inputView = pickerView
    }
    
    // pickerViewの場合にtextFieldに初期値を設定する
    func setInitialValue(pickerData: [String]) {
        inputTextField.text = pickerData[0]
    }
}

extension InputTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputTextField.text = pickerDataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataList[row]
    }
}

extension InputTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataList.count
    }
}
