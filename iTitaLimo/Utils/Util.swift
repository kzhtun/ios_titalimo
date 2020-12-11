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

