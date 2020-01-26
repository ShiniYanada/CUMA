//
//  AppDelegate.swift
//  CUMA
//
//  Created by 簗田信緯 on 2019/10/24.
//  Copyright © 2019 Shini Yanada. All rights reserved.
//
// Xcode Version 11.2.1 (11B500)
//PODS:
//  - InstantSearchClient (7.0.3)
//  - Realm (4.3.0):
//    - Realm/Headers (= 4.3.0)
//  - Realm/Headers (4.3.0)
//  - RealmSwift (4.3.0):
//    - Realm (= 4.3.0)
//  - SwiftyJSON (4.3.0)
//
//DEPENDENCIES:
//  - InstantSearchClient (~> 7.0)
//  - RealmSwift
//  - SwiftyJSON (~> 4.0)
//
//COCOAPODS: 1.8.4

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
//        let defaultParentURL = defaultURL.deletingLastPathComponent()
//        let initialDataURL = defaultParentURL.appendingPathComponent("timetable.realm")
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        let timetable = TimeTable(value: ["時間割", 5, 6, true])
        try! realm.write {
            realm.add(timetable)
        }
//        if FileManager.default.fileExists(atPath: initialDataURL.path) {
//            print("exist")
//        } else {
//            print("not exist")
//            let bundleRealmPath = Bundle.main.url(forResource: "initial-compact", withExtension: "realm")
//            do {
//                try FileManager.default.copyItem(at: bundleRealmPath!, to: initialDataURL)
//            } catch { print("coppy error")}
//        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func createInitialCompactedData(){
        // 初期データ
        let timeTable = TimeTable()
        timeTable.name = "時間割1"
        timeTable.selected = true
        // schemaVersionの設定
        let config = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 5) {
                    
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        //初期データを追加
        realm.deleteAll()
        try! realm.write {
            realm.add(timeTable)
        }
        
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let defaultParentURL = defaultURL.deletingLastPathComponent()
        //realm圧縮データのファイルパスを設定
        let compactedURL = defaultParentURL.appendingPathComponent("initial-compact.realm")
        print(defaultURL)
        // 圧縮データファイルパスに圧縮データを作成
        try! realm.writeCopy(toFile: compactedURL)
    }

}

