//
//  TimeTable.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/11/14.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//

import Foundation
import RealmSwift

class TimeTable: Object {
    @objc dynamic var name = ""
    @objc dynamic var day = 5
    @objc dynamic var hour = 6
    @objc dynamic var selected = false
    @objc dynamic var createdAt =  Date()
    let classes = List<Class>()
}
