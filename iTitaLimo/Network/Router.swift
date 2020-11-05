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
    let baseURL = "http://info121.sytes.net/RestAPITitanium/MyLimoService.svc/"
    
    
    static func sharedInstance() -> Router {
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
   
   
   func GetHistoryJobs(from: String, to: String, passenger: String, sort: String,
      success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let headers: HTTPHeaders = [
            "driver": self.App.DRIVER_NAME,
            "token": self.App.AUT_TOKEN
         
       ]
       
       var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "getHistoryJobsList", from, to, passenger, sort)
       
      var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
      allowedQueryParamAndKey.remove(charactersIn: ";?@&=+$")
      
      url = url.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
     
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
   
   
   func GetJobDetail(jobNo: String,
      success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let headers: HTTPHeaders = [
            "driver": self.App.DRIVER_NAME,
            "token": self.App.AUT_TOKEN
         
       ]
       
       var url = String(format: "%@%@/%@", baseURL, "getJobDetails", jobNo)
       
      var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
      allowedQueryParamAndKey.remove(charactersIn: ";?@&=+$")
      
      url = url.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
     
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

}

