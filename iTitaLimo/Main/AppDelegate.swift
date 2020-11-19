//
//  AppDelegate.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 22/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   let gcmMessageIDKey = "gcm.Message_ID"
   var DRIVER_NAME = ""
   var AUT_TOKEN = ""
   var fullAddress = "Address not found"
   
   var searchParams: SearchFilter = SearchFilter()
   var recentJobList = [JobDetail]()
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
    //  searchParams = SearchFilter()
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

