//
//  SearchFilter.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 28/10/2020.
//

import Foundation

struct SearchFilter{
   
   // search filter
   var passenger = ""
   var updates = ""
   var sDate = ""
   var eDate = ""
   var sorting = ""
   
    init(passenger: String = "", updates: String = "", sDate: String = "", eDate: String = "", sorting: String = "") {
        self.updates = updates
        self.passenger = passenger
        self.sDate = sDate
        self.eDate = eDate
        self.sorting = sorting
   }
   
   
}
