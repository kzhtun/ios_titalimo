//
//  Router.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 22/10/2020.
//

import Foundation
import Alamofire

public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let App = UIApplication.shared.delegate as! AppDelegate
    
    let output = items.map { "\($0)" }.joined(separator: separator)
    
    let now = Date()
    let formatter = DateFormatter()

    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"

    let dateString = formatter.string(from: now)
    
    App.StackTraceLog += "\(dateString) :     \(output)\n"
    
    Swift.print(output, terminator: terminator)
}

class Router{
   let App = UIApplication.shared.delegate as! AppDelegate
   static var instance: Router?
  
    //http://info121.sytes.net/RestApiTitanium/MyLimoService.svc
    // DEV
   // let baseURL = "http://118.200.137.124/RestApiTitanium/MyLimoService.svc/"
    let baseURL = "http://info121.sytes.net/RestApiTitanium/MyLimoService.svc/"
    

    
    // LIVE
//  let baseURL = "http://97.74.89.233/RestApiTitanium/MyLimoService.svc/"
    
   
   static var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
   
   static func sharedInstance() -> Router {
      allowedQueryParamAndKey.remove(charactersIn: ";?@&=+$#")         
      
      if self.instance == nil {
         self.instance = Router()
      }
      return self.instance!
   }

   
    func CheckVersion(version: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let url = String(format: "%@%@/%@", baseURL, "getcurrentversion", version)
       
       AF.request(url, method: .get)
          .response{
             (response) in
             
             guard let data = response.data else{
                print("CheckVersion Success, No Data")
                return
             }
             do{
                let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
                
                // self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("CheckVersion Success")
             }catch{
                failure("CheckVersion Failed")
             }
          }
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
               
               //self.CheckSession(objRes: objRes)
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
               
              //  self.CheckSession(objRes: objRes)
                success(objRes)
               
               print("GetJobsCount Success")
            }catch{
               failure("GetJobsCount Failed")
            }
         }
   }
   
   
    func GetPatientHistory(custoCode: String, from: String, to: String,  sort: String,
                        success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
       
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       var url = String(format: "%@%@/%@,%@,%@,%@", baseURL, "getPatientHistory",
                        custoCode,
                         from,
                         to,
                         sort)
       
       url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!
       
       AF.request(url, method: .get, headers: headers)
          .response{
             (response) in
             
             guard let data = response.data else{
                print("GetPatientHistory Success, No Data")
                return
             }
             
             do{
                let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
                
                 self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("GetPatientHistory Success")
             }catch{
                failure("GetPatientHistory Failed")
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
             
                self.CheckSession(objRes: objRes)
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
               
                self.CheckSession(objRes: objRes)
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
               
                self.CheckSession(objRes: objRes)
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
               
                self.CheckSession(objRes: objRes)
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
               
                self.CheckSession(objRes: objRes)
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
               
               self.CheckSession(objRes: objRes)
               success(objRes)
               
               print("UpdateJobStatus Success" + " -> Status : " + status)
            }catch{
               failure("UpdateJobStatus Failed" + " -> Status : " + status)
            }
         }
   }
    
    func UpdateJobRemarks(jobNo: String, remark: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                         
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       
        let parameters: [String: Any] = [
            "jobno" : jobNo,
            "remarks" : remark
            ]
        
       // var url = String(format: "%@%@/%@,%@", baseURL, "updateJobRemark", jobNo, remark)
        var url = String(format: "%@%@", baseURL, "updatelongremarks")
           
       // url = url.addingPercentEncoding(withAllowedCharacters: Router.allowedQueryParamAndKey)!

       AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
          .response{
             (response) in
  
             guard let data = response.data else{
                print( response.error?.localizedDescription as Any)
                return
             }
             
             do{
                let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
                
                 
                self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("UpdateJobRemark Success")
             }catch{
                failure("UpdateJobRemark Failed")
             }
          }
    }
    
    
    
    func UpdateMobileLog(StackTraceLog: String, Remarks: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                         
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       
        let parameters: [String: Any] = [
            "stacktracelog" : App.StackTraceLog,
            "remarks" : Remarks
            ]
     
       var url = String(format: "%@%@", baseURL, "updatemobilelog")
     
       AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
          .response{
             (response) in
  
             guard let data = response.data else{
                print( response.error?.localizedDescription as Any)
                return
             }
             
             do{
                let objRes = try JSONDecoder().decode(ResponseObject.self, from: data)
                
                 self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("UpdateMobileLog  Success")
             }catch{
                failure("UpdateMobileLog Failed")
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
               
                self.CheckSession(objRes: objRes)
               success(objRes)
               
               print("UpdateJobShowConfirm Success" + " -> Status : " + status)
            }catch{
               failure("UpdateJobShowConfirm Failed" + " -> Status : " + status)
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
               
                self.CheckSession(objRes: objRes)
               success(objRes)
               
               print("UpdateJobNoShowConfirm Success" + " -> Status : " + status)
            }catch{
               failure("UpdateJobNoShowConfirm Failed" + " -> Status : " + status)
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
               
                self.CheckSession(objRes: objRes)
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
               
                self.CheckSession(objRes: objRes)
               success(objRes)
               
               print("ConfirmJobReminder Success")
            }catch{
               failure("ConfirmJobReminder Failed")
            }
         }
   }
    
    
//    @GET("saveshowpic/{jobno},{filename}")
//        Call<JobRes> SaveShowPic(@Path("jobno") String jobno, @Path("filename") String filename);
//
//        @GET("savesignature/{jobno},{filename}")
//        Call<JobRes> SaveSignature(@Path("jobno") String jobno, @Path("filename") String filename);
//
//        @GET("savenoshowpic/{jobno},{filename}")
//        Call<JobRes> SaveNoShowPic(@Path("jobno") String jobno, @Path("filename") String filename);
    
    
    func SaveSignature(jobNo: String, fileName: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                         
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       var url = String(format: "%@%@/%@,%@", baseURL, "savesignature", jobNo, fileName)
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
                
                 self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("SaveSignature Success")
             }catch{
                failure("SaveSignature Failed")
             }
          }
    }
    
    func SaveShowPic(jobNo: String, fileName: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                         
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       var url = String(format: "%@%@/%@,%@", baseURL, "saveshowpic", jobNo, fileName)
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
                
                 self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("SaveShowPic Success")
             }catch{
                failure("SaveShowPic Failed")
             }
          }
    }
    
    func SaveNoShowPic(jobNo: String, fileName: String,
                         success: @escaping (_ responseObject: ResponseObject) -> Void, failure: @escaping (_ error: String) -> Void){
                         
       let headers: HTTPHeaders = [
          "driver": self.App.DRIVER_NAME,
          "token": self.App.AUT_TOKEN
       ]
       
       var url = String(format: "%@%@/%@,%@", baseURL, "savenoshowpic", jobNo, fileName)
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
                
                 self.CheckSession(objRes: objRes)
                success(objRes)
                
                print("SaveNoShowPic Success")
             }catch{
                failure("SaveNoShowPic Failed")
             }
          }
    }
    
    
    func CheckSession(objRes: ResponseObject){
        if(objRes.status == "0"){
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("SHOW_SESSION_EXPIRED"), object: nil, userInfo: nil)
            }
            return;
        }
    }
  
}




