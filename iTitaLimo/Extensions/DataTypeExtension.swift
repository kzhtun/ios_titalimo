//
//  DataTypeExtension.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 17/11/2020.
//

import Foundation

extension String{
   var replaceEscapeChr: String{
      return self.replacingOccurrences(of: ",", with: "###")
   }
}
