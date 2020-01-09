//
//  InputPickerViewCell.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/08.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import UIKit

class InputPickerViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: PickerTextField!
    var pickerDataList: [String]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        inputTextField.inputView = pickerView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func iniPickerView(pickerData: [String]) {
        pickerDataList = pickerData
        inputTextField.text = pickerData[0]
    }
    
}

extension InputPickerViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputTextField.text = pickerDataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataList[row]
    }
}

extension InputPickerViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataList.count
    }
}
