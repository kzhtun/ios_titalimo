//
//  ResponseObject.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 23/10/2020.
//

import Foundation

struct ResponseObject: Codable {
   var jobcount: String!
   var jobcountlist: String!
   var jobdatelist: String!
   var jobdetails: String!
   var jobs: [JobDetail]!
   var responsemessage: String!
   var status: String!
   var token: String!
}
