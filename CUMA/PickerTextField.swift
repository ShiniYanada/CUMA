//
//  PickerTextField.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/08.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import UIKit

class PickerTextField: UITextField {

    override var canBecomeFirstResponder: Bool {
        return true
    }
    //　ギャレット非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }
    // コピーやペーストなどを無効
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    // 選択範囲を取らないようにしている
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

}
