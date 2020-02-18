//
//  Class.swift
//  CUMA
//
//  Created by 簗田信緯 on 2020/01/13.
//  Copyright © 2020 Shini Yanada. All rights reserved.
//

import Foundation
import RealmSwift

class Class: Object {
    @objc dynamic var id = ""
    @objc dynamic var year = 2020
    @objc dynamic var semester = ""
    let term = List<String>()
    let dayAndPeriod = List<String>()
    let studentYear = List<String>()
    @objc dynamic var name = ""
    @objc dynamic var teacher = ""
    @objc dynamic var room = ""
    @objc dynamic var credit = 1
    let timetables = LinkingObjects(fromType: TimeTable.self, property: "classes")
    @objc dynamic var day = "月曜日"
    @objc dynamic var hour = "1限"
}
