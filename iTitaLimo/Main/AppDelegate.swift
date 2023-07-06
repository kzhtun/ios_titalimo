//
//  AppDelegate.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 22/10/2020.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?
   
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   let notificationCenter = UNUserNotificationCenter.current()
   
   let gcmMessageIDKey = "gcm.Message_ID"
   var DRIVER_NAME = ""
   var AUT_TOKEN = ""
   var FCM_TOKEN = "nil"
   var lat: Double = 0.0
   var lng: Double = 0.0
   var fullAddress = "Address not found"
    
  
   
   var phones: [String]?
   var jobInfo: [AnyHashable: Any]?
   
   var ButtonRed = "#FF1400FF"
   var ButtonGreen = "#0DAA00FF"
   
    
   var  searchParams: SearchFilter = SearchFilter()
   var recentJobList = [JobDetail]()
   var recentTab = 0
    

   
   func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
     return true
   }

   func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
     return true
   }

   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      if #available(iOS 10.0, *) {
         // For iOS 10 display notification (sent via APNS)
         UNUserNotificationCenter.current().delegate = self

         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
      } else {
         let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
         application.registerUserNotificationSettings(settings)
      }

      application.registerForRemoteNotifications()
      
      // Use Firebase library to configure APIs
      FirebaseApp.configure()
      Messaging.messaging().delegate = self
      
      // localNotification(title: "Noti", body: "Test")
       
       notificationCenter.delegate = self
       notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { isSuccessful, error in
                   guard isSuccessful else{
                       return
                   }
                   print(">> SUCCESSFUL APNs REGISTRY")
               }
               application.registerForRemoteNotifications()
               return true
      
     // return false
   }
   
   
   // MARK: UISceneSession Lifecycle
   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }
   
   
   func applicationDidFinishLaunching(_ application: UIApplication) {
      application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
   }
   
   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }
   
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("REFRESH_JOBS"), object: nil, userInfo: jobInfo)
        
        
    }
    
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
  
       print("didReceiveRemoteNotification NEW 2")
       
     
   }
   
   
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
   
      print("didReceiveRemoteNotification NEW 1")
      
      NotificationCenter.default.post(name: Notification.Name("REFRESH_JOBS"), object: nil, userInfo: jobInfo)

      // =================================== //
      jobInfo = userInfo

      // localNotification(title: "Test", body: "This is local notification");
       
       switch UIApplication.shared.applicationState {
           case .background, .inactive:
                print("Application is in Background")
           case .active:
                print("Application is in Foreground")
           default:
               break
       }
       
      // job update
      if let action = userInfo["action"] as? String{
         if(action.uppercased() == "ASSIGN" || action.uppercased() == "REASSIGN"){
             newJobNotification(userInfo: userInfo)
             //localNotification(title: action.uppercased(), body: userInfo["jobNo"] as! String )
         }

         if(action.uppercased() == "CANCEL FULL NOTIFICATION" || action.uppercased() == "UNASSIGN"){
            cancelNotification(userInfo: userInfo)
            //localNotification(title: action.uppercased(), body: userInfo["jobNo"] as! String )
         }
      }
      else{
         urgentJobNotification(userInfo: userInfo)
      }
      // =================================== //
      
      completionHandler(UIBackgroundFetchResult.newData)
   }
   
   
   func cancelNotification(userInfo: [AnyHashable: Any]){
      guard let jobNo = userInfo["jobno"] as? String
      else{return}
      
      notificationCenter.getDeliveredNotifications(completionHandler: {deliveredNotifications -> () in
         for notification in deliveredNotifications{
            // find jobNo in notifications
            if notification.request.identifier.hasPrefix(jobNo){
               self.notificationCenter.removeDeliveredNotifications(withIdentifiers: [notification.request.identifier])
               break
            }
         }
      })
   }
}



// MessagingDelegate
extension AppDelegate: MessagingDelegate{
   func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(fcmToken ?? "fcm not found")")
      self.FCM_TOKEN = fcmToken ?? "fcm not found"
      print("didReceiveRegistrationToken")

      //  NotificationCenter.default.post(name: Notification.Name("ValidateUser"), object: nil)
      // let dataDict:[String: String] = ["token": self.FCM_TOKEN]
   }
}


// UNUserNotificationCenterDelegate
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
   
   // Receive displayed notifications for iOS 10 devices.
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
     let userInfo = notification.request.content.userInfo
      jobInfo = userInfo
      print("willPresent notification")
      
      NotificationCenter.default.post(name: Notification.Name("REFRESH_JOBS"), object: nil, userInfo: jobInfo)
      
    //  newJobNotification(userInfo: userInfo)
      
      completionHandler([.banner, .list , .badge, .sound])
   }
   
   
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
         print("Message ID: \(messageID)")
      }
      
      print("didReceive response")
      
      let identifier = response.actionIdentifier
     // let request = response.notification.request
      
      completionHandler()
      
      // Action button clicked
//      if identifier == "ACCEPT"{
//         if let jobNo = userInfo["jobno"] as? String{
//            //callUpdateJobStatus(jobNo: jobNo, status: "Confirm")
//            //callUpdateDriverLocation()
//         }
//      }
//
//      if identifier == "CALL1"{
//         if let url = URL(string: "tel://\(phones![0])"),
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//         }
//      }
//
//      if identifier == "CALL2"{
//         if let url = URL(string: "tel://\(phones![1])"),
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//         }
//      }
//
//      if identifier == "CONFIRM"{
//         NotificationCenter.default.post(name: Notification.Name("URGENT_JOB_CONFIRM"), object: nil, userInfo: jobInfo )
//      }

      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if  let notiVc = storyboard.instantiateViewController(withIdentifier: "NotiViewController") as? NotiViewController {
         // set the view controller as root
         self.window?.rootViewController = notiVc
      }
      
   }
  
//   // Custom Functions
   func normalJobNotification(userInfo: [AnyHashable: Any]) {
      let content = UNMutableNotificationContent()

      guard let title = userInfo["title"] as? String,
            let message = userInfo["message"] as? String
      else{return}

      content.title = title
      content.body = message
      content.sound = UNNotificationSound.default
      content.categoryIdentifier = "NORMAL_NOTI"

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

      notificationCenter.add(request) { (error) in
         if let error = error {
            print("Error \(error.localizedDescription)")
         }
      }

      let category = UNNotificationCategory(identifier: content.categoryIdentifier,
                                            actions: [],
                                            intentIdentifiers: [],
                                            options: [])

      notificationCenter.setNotificationCategories([category])
   }


   func newJobNotification(userInfo: [AnyHashable: Any]) {
      let content = UNMutableNotificationContent()

      guard let jobNo = userInfo["jobno"] as? String,
//            let jobtype = userInfo["jobtype"] as? String,
            let jobdate = userInfo["jobdate"] as? String,
            let pickuptime = userInfo["pickuptime"] as? String,
            let pickuppoint = userInfo["pickuppoint"] as? String,
            let alightpoint = userInfo["alightpoint"] as? String,
           // let clientname = userInfo["clientname"] as? String,
            let vehicletype = userInfo["vehicletype"] as? String,
         //   let driver = userInfo["driver"] as? String,
            let   message = userInfo["message"] as? String
      else{return}

//      content.title = "Accept Click"
//      content.subtitle = "⭐ " + pickuptime + " ⭐ \n" // ⏰
//      content.body = "" + pickuppoint + "\n" // displayMsg + "\n Pickup \t:\t Arumugan Road. ⭐ "
//      content.body += "  🔻 \n"
//      content.body += "" + alightpoint + "\n"
//      content.body += "" + vehicletype
//      content.sound = UNNotificationSound.default
//      content.badge = 1
//      content.categoryIdentifier = "JOB_ASSIGN"
//
       
       content.title = "NEW JOB"
       content.subtitle = "📅 " + jobdate + " \t ⏰ " + pickuptime + "\n" //
       content.body = "🔺 " + pickuppoint  // displayMsg + "\n Pickup \t:\t Arumugan Road. ⭐ "
       content.body += " \t 🔻 " + alightpoint + "\n"
       content.body += "⭐ " + vehicletype
       content.sound = UNNotificationSound.default
       content.badge = 1
       content.categoryIdentifier = "JOB_ASSIGN"

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
       
      let request = UNNotificationRequest(identifier: "\(jobNo)_\(UUID().uuidString)" , content: content, trigger: trigger)

      notificationCenter.add(request) { (error) in
         if let error = error {
            print("Error \(error.localizedDescription)")
         }
      }

      let acceptAction = UNNotificationAction(identifier: "ACCEPT", title: "ACCEPT", options: [])
      let category = UNNotificationCategory(identifier:  content.categoryIdentifier,
                                            actions: [],
                                            intentIdentifiers: [],
                                            options: [])

      notificationCenter.setNotificationCategories([category])
   }
   
   
   func localNotification(title: String, body: String) {
      let content = UNMutableNotificationContent()
      content.title = title
      content.subtitle = body

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString , content: content, trigger: trigger)

      notificationCenter.add(request) { (error) in
         if let error = error {
            print("Error \(error.localizedDescription)")
         }
      }

      let acceptAction = UNNotificationAction(identifier: "OK", title: "OK", options: [])
      let category = UNNotificationCategory(identifier:  content.categoryIdentifier,
                                            actions: [acceptAction],
                                            intentIdentifiers: [],
                                            options: [])

      notificationCenter.setNotificationCategories([category])
   }
      


    
   func urgentJobNotification(userInfo: [AnyHashable: Any]) {
      let content = UNMutableNotificationContent()

      guard let jobNo = userInfo["jobNo"] as? String,
          //  let name = userInfo["Name"] as? String,
            let phone = userInfo["phone"] as? String,
            let displayMsg = userInfo["displayMsg"] as? String
      else{return}

      phones = phone.components(separatedBy: ",")

      content.title = "URGENT JOB"
      //content.subtitle = " ⭐ " + + " ⭐ "
      content.body = displayMsg
      content.sound = UNNotificationSound.default
      content.categoryIdentifier = "URGNET_JOB"

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      let request = UNNotificationRequest(identifier: jobNo, content: content, trigger: trigger)

      notificationCenter.add(request) { (error) in
         if let error = error {
            print("Error \(error.localizedDescription)")
         }
      }

      let call1Action = UNNotificationAction(identifier: "CALL1", title: "CALL \(phones![0])", options: [])
      let call2Action = UNNotificationAction(identifier: "CALL2", title: "CALL \(phones![1])", options: [])
      let confirmAction = UNNotificationAction(identifier: "CONFIRM", title: "CONFIRM", options: [])
      let remindAction = UNNotificationAction(identifier: "REMIND_LATER", title: "REMIND LATER", options: [.destructive])
      let category = UNNotificationCategory(identifier:  content.categoryIdentifier,
                                            actions: [call1Action, call2Action, confirmAction, remindAction],
                                            intentIdentifiers: [],
                                            options: [])

      notificationCenter.setNotificationCategories([category])
   }

   
//   func callUpdateJobStatus(jobNo: String, status: String){
//
//      Router.sharedInstance().UpdateJobStatus(jobNo: jobNo, address: fullAddress, status: status,
//                                              success: { [self](successObj) in
//                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
//                                                   //localNotification(title: "SUCCESS", body: jobNo)
//                                                    self.makeToast("SUCCESS")
//                                                   NotificationCenter.default.post(name: Notification.Name("ACCEPT_SUCCESSFUL"), object: nil, userInfo: jobInfo )
//                                                }
//                                              }, failure: { (failureObj) in
//                                                self.makeToast(failureObj)
//                                                //self.localNotification(title: "FAILURE", body: jobNo)
//                                              })
//   }
//
//   func callUpdateDriverLocation(){
//      Router.sharedInstance().UpdateDriverLocation(latitude: "\(lat)" , longitude: "\(lng)", gpsStatus: "nil", address: fullAddress, success: { (successObj) in
//         if(successObj.responsemessage.uppercased() == "SUCCESS"){
//            print("Update Driver Location Success")
//         }
//       }, failure: { (failureObj) in
//         print(failureObj)
//       })
//   }
}






