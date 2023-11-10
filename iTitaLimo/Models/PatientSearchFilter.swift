//
//  PatientSearchFilter.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 11/10/23.
//

import Foundation
struct PatientSearchFilter{
   
   // search filter
   var sDate = ""
   var eDate = ""
   var sorting = ""
   
    init(sDate: String = "", eDate: String = "", sorting: String = "") {
        self.sDate = sDate
        self.eDate = eDate
        self.sorting = sorting
   }
   
}
