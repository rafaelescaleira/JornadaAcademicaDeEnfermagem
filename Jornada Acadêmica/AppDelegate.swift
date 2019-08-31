//
//  AppDelegate.swift
//  Jornada Acadêmica
//
//  Created by Rafael Escaleira on 30/08/19.
//  Copyright © 2019 Rafael Escaleira. All rights reserved.
//

import UIKit
import SharkORM

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SRKDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SharkORM.setDelegate(self)
        SharkORM.openDatabaseNamed("JornadaDatabase")
        
        return true
    }
}

