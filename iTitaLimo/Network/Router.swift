//
//  Router.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 22/10/2020.
//

import Foundation
import Alamofire

class Router{
   let App = UIApplication.shared.delegate as! AppDelegate
   static var instance: Router?
  

    // DEV
// let baseURL = "http://128.106.129.15/RestApiTitanium/MyLimoService.svc/"
    
    // LIVE
 let baseURL = "http://97.74.89.233/RestApiTitanium/MyLimoService.svc/"
    
   
   static var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
   
   static func sharedInstance() -> Router {
      allowedQueryParamAndKey.remove(charactersIn: ";?@&=+$#")         
      
      if self.instance == nil {
         self.instance = Router()
      }
      return self.instance!
   }

   
   func ValidateDriver( driver: String,
                        success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let url = String(format: "%@%@/%@", baseURL, "validatedriver", driver)
      
      AF.request(url, method: .get)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("ValidateUser Success, No Data")
               return
            }
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("ValidateUser Success")
            }catch{
               failure("ValidateUser Failed")
            }
         }
   }
   
   func UpdateDevice(deviceID: String, fcnToken: String,
                        success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      let url = String(format: "%@%@/%@,%@,%@", baseURL, "updatedevice", deviceID, "iOS", fcnToken)
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("UpdateDevice Success, No Data")
               return
            }
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("UpdateDevice Success")
            }catch{
               failure("UpdateDevice Failed")
            }
         }
   }
   
  // @GET("getdrivercurrentlocation/{latitude},{longitude},{status},{address}")
   func UpdateDriverLocation(latitude: String, longitude: String, gpsStatus: String, address: String,
                        success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "getdrivercurrentlocation", latitude, longitude, gpsStatus, App.fullAddress)
      
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("UpdateDriverLocation Success, No Data")
               return
            }
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("UpdateDriverLocation Success")
            }catch{
               failure("UpdateDriverLocation Failed")
            }
         }
   }
   
   func GetJobsCount(success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
         
      ]
      
      let url = String(format: "%@%@", baseURL, "getJobsCount")
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("GetJobsCount Success, No Data")
               return
            }
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("GetJobsCount Success")
            }catch{
               failure("GetTodayJobs Failed")
            }
         }
   }
   
   
   func GetTodayJobs(success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
         
      ]
      
      let url = String(format: "%@%@", baseURL, "getTodayJobsList")
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("GetTodayJobs Success, No Data")
               return
            }
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("GetTodayJobs Success")
            }catch{
               failure("GetTodayJobs Failed")
            }
         }
   }
   
   
   func GetTomorrowJobs(success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
         
      ]
      
      let url = String(format: "%@%@", baseURL, "getTomorrowJobsList")
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("GetTomorrowJobs Success, No Data")
               return
            }
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("GetTomorrowJobs Success")
            }catch{
               failure("GetTomorrowJobs Failed")
            }
         }
   }
   
   func GetFutureJobs(from: String, to: String, passenger: String, sort: String,
                       success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "getFutureJobsList",
                        from,
                        to,
                        passenger,
                        sort)
      
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("GetFutureJobs Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("GetFutureJobs Success")
            }catch{
               failure("GetFutureJobs Failed")
            }
         }
   }
   
   func GetHistoryJobs(from: String, to: String, passenger: String, updates: String, sort: String,
                       success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@,%@,%@,%@,%@", baseURL, "getHistoryJobsList",
                        from,
                        to,
                        passenger,
                        updates,
                        sort)
      
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("GetHistoryJobs Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("GetHistoryJobs Success")
            }catch{ //} let error {
                failure("GetHistoryJobs Failed")
            }
         }
   }
   
   
   func GetJobDetail(jobNo: String,
                     success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@", baseURL, "getJobDetails", jobNo)
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("GetJobDetail Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("GetJobDetail Success")
            }catch{
               failure("GetJobDetail Failed")
            }
         }
   }
   
   func UpdateJobStatus(jobNo: String, address: String, status: String,
                        success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                        
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@,%@,%@", baseURL, "updateJobStatus", jobNo, address, status)
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!

      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
 
            guard let data = response.data else{
              // print("UpdateJobStatus Success, No Data")
               print( response.error?.localizedDescription as Any)
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("UpdateJobStatus Success")
            }catch{
               failure("UpdateJobStatus Failed")
            }
         }
   }
    
    func UpdateJobRemarks(jobNo: String, remark: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                         
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       var url = String(format: "%@%@/%@,%@", baseURL, "updateJobRemark", jobNo, remark)
       url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!

       AF.request(url, method: .get, headers: headers)
          .response{
             (response) in
  
             guard let data = response.data else{
                print( response.error?.localizedDescription as Any)
                return
             }
             
             do{
                let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
                
                success(objRes)
                
                print("UpdateJobRemark Success")
             }catch{
                failure("UpdateJobRemark Failed")
             }
          }
    }
   
   func UpdateJobShowConfirm(jobNo: String, address: String, remarks: String, status: String,
                             success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "updateShowConfirmJob", jobNo, (address.isEmpty) ? " " : address, (remarks.isEmpty) ? " " : remarks, status)
 
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("UpdateJobShowConfirm Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("UpdateJobShowConfirm Success")
            }catch{
               failure("UpdateJobShowConfirm Failed")
            }
         }
   }
   
   func UpdateJobNoShowConfirm(jobNo: String, address: String, remarks: String, status: String,
                               success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "updateNoShowJob", jobNo, (address.isEmpty) ? " " : address, (remarks.isEmpty) ? " " : remarks, status)

      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("UpdateJobNoShowConfirm Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("UpdateJobNoShowConfirm Success")
            }catch{
               failure("UpdateJobNoShowConfirm Failed")
            }
         }
   }
   
   func UpdateCompleteJob(jobNo: String, address: String, remarks: String, status: String,
                               success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      
      var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "updateCompleteJob", jobNo, (address.isEmpty) ? " " : address, (remarks.isEmpty) ? " " : remarks, status)
  
      url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("UpdateCompleteJob Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("UpdateCompleteJob Success")
            }catch{
               failure("UpdateCompleteJob Failed")
            }
         }
   }
 
   func ConfirmJobReminder(jobNo: String,
                               success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
      
      let headers: HTTPHeaders = [
         "driver": self.App.DRIVER_NAME,
         "token": self.App.AUT_TOKEN
      ]
      
      var url = String(format: "%@%@/%@", baseURL, "confirmjobreminder", jobNo)
      
      AF.request(url, method: .get, headers: headers)
         .response{
            (response) in
            
            guard let data = response.data else{
               print("ConfirmJobReminder Success, No Data")
               return
            }
            
            do{
               let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
               
               success(objRes)
               
               print("ConfirmJobReminder Success")
            }catch{
               failure("ConfirmJobReminder Failed")
            }
         }
   }
  
}

