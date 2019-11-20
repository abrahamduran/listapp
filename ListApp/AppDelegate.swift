//
//  AppDelegate.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/17/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import IQKeyboardManagerSwift
import NVActivityIndicatorView
import Parse
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let configuration = ParseClientConfiguration {
            $0.applicationId = <#Back4App: Application Id#>
            $0.clientKey = <#Back4App: Client Key#>
            $0.server = <#Back4App: Server Url#>
        }
        
        Parse.initialize(with: configuration)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        NVActivityIndicatorView.DEFAULT_COLOR = .primary
        NVActivityIndicatorView.DEFAULT_TYPE = .circleStrokeSpin
        NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 500
        
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
}
