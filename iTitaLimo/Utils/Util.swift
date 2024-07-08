//
//  Util.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 24/11/2020.
//

import Foundation
import UIKit


func getDeviceID()->String{
   if let uuid = UIDevice.current.identifierForVendor?.uuidString{
      return uuid
   }
   return ""
}

func covertDateToString(date: Date, formatString: String)->String{
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = formatString
   
   return dateFormatter.string(from: date)
}

func getCurrentDateTimeString(formatString: String)->String{
   let currentDate = Date()
   
   let dateFormatter = DateFormatter()
   dateFormatter.timeZone = .some(TimeZone(abbreviation: "UTC+08")!)
   
   dateFormatter.dateFormat = formatString
   
   return dateFormatter.string(from: currentDate)
}


func convertUIImageToBase64String(uiImage: UIImage)-> String{
    
    return uiImage.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
}


func performNotificationFeedback(){
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
}

func performImpactFeedback(){
    let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)
    generator.impactOccurred()
}

