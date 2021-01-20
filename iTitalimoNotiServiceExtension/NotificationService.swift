//
//  NotificationService.swift
//  iTitalimoNotiServiceExtension
//
//  Created by Kyaw Zin Htun on 07/01/2021.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
   
   var contentHandler: ((UNNotificationContent) -> Void)?
   var content: UNMutableNotificationContent?
   
   let notificationCenter = UNUserNotificationCenter.current()
   
   override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
      self.contentHandler = contentHandler
      content = (request.content.mutableCopy() as? UNMutableNotificationContent)
      
      NotificationCenter.default.post(name: Notification.Name("REFRESH_JOBS"), object: nil, userInfo: request.content.userInfo)
   
      let userInfo = request.content.userInfo
     
      guard let action = userInfo["action"] as? String
      else{return}
      
      if(action.uppercased() == "ASSIGN" || action.uppercased() == "REASSIGN"){
         guard let pickuptime = userInfo["pickuptime"] as? String,
               let pickuppoint = userInfo["pickuppoint"] as? String,
               let alightpoint = userInfo["alightpoint"] as? String,
               let vehicletype = userInfo["vehicletype"] as? String
         else{return}
         
         content!.title = content!.body
         content!.subtitle = "⭐ " + pickuptime + " ⭐ \n" // ⏰
         content!.body = "" + pickuppoint + "\n"
         content!.body += "  🔻 \n"
         content!.body += "" + alightpoint + "\n"
         content!.body += "" + vehicletype
         content!.sound = UNNotificationSound.default
         content!.badge = 1
         content!.categoryIdentifier = "JOB_ASSIGN"
         
      }else{
         if(action.uppercased() == "UNASSIGN"){
            guard
                  let displayMsg = userInfo["message"] as? String
            else{return}
            
            content!.title = "JOB UNASSIGN"
            content!.body = displayMsg
         }else{
            guard
                  let displayMsg = userInfo["displayMsg"] as? String
            else{return}
     
            content!.title = "URGENT JOB"
            content!.body = displayMsg
         }
      }
      
      if let bestAttemptContent = content {
            contentHandler(bestAttemptContent)
      }
     
   }
   
   override func serviceExtensionTimeWillExpire() {
      // Called just before the extension will be terminated by the system.
      // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
      if let contentHandler = contentHandler, let bestAttemptContent =  content {
         contentHandler(bestAttemptContent)
      }
   }
   
   
   
}
