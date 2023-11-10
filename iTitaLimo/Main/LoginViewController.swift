//
//  LoginViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 22/10/2020.
//

import UIKit
import Toast_Swift
import Alamofire
//import BEMCheckBox

class LoginViewController: UIViewController {
   let notificationCenter = UNUserNotificationCenter.current()
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   let datePicker = UIDatePicker()
   let CONST_USER_NAME = "UserName"
   
   
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var chkRemember: UISwitch!
    @IBOutlet weak var loginView: UIView!
   @IBOutlet weak var txtName: UITextField!
  // @IBOutlet weak var chkRemember: BEMCheckBox!
   @IBOutlet weak var btnLogin: UIButton!
   @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
   
   var cacheUserName = ""
   
    
    @IBAction func chkRemember_ValueChanged(_ sender: Any) {
        
        
    }
    
//    override func viewDidLayoutSubviews() {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    
//    }
    
    
    
    
   override func viewDidLoad() {
      super.viewDidLoad()
      
       
       let dictionary = Bundle.main.infoDictionary!
       
       let versionNo  = dictionary["CFBundleShortVersionString"] as! String
       let buildNo  = dictionary["CFBundleVersion"] as! String
       
       
       lblVersion.text = "Ver : " + versionNo + " (" + buildNo + ")"
       
    
       
      loginView.layer.cornerRadius = 10;
      loginView.layer.masksToBounds = true;
      loginView.layer.borderWidth = 1;
      loginView.layer.borderColor =  UIColor.init(hex: "#333333FF")?.cgColor
      
      txtName.layer.cornerRadius = 17;
      txtName.layer.masksToBounds = true;
      txtName.setLeftPaddingPoints(8)
      
      btnLogin.layer.cornerRadius = 20;
      btnLogin.layer.masksToBounds = false;
      
     
     
       
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
       
       
       let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
       print("buildNumber : " + buildNumber!)
       
       let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
       print("appVersion : " + appVersion!)
       
       
       callCheckVersion(ver: appVersion!)
       
       cacheUserName = UserDefaults.standard.string(forKey: CONST_USER_NAME) ?? ""

       if(cacheUserName != ""){
          txtName.text = cacheUserName
           chkRemember.setOn(true, animated: true)

           if(txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
              callValidateDriver()
           }

       }else{
          txtName.text = ""
       }
       
   }
    
    
    func callCheckVersion(ver: String){
        Router.sharedInstance().CheckVersion(version: ver) { successObj in
            if(successObj.responsemessage?.uppercased() == "OUTDATED"){
                
                let alert = UIAlertController(title: "Tita Limo", message: "There is a new version for Titalimo.\nPlease update on Google Playstore.\nTitalimo system is now closing.", preferredStyle: UIAlertController.Style.alert)
                        
                
                alert.addAction(UIAlertAction(title: "Open TestFlight", style: .default, handler: { UIAlertAction in
                    alert.dismiss(animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                    
                    self.openTestFligh()
                }))
                
                alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { UIAlertAction in
                    alert.dismiss(animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                }))
                
                self.present(alert, animated: true)

            }
        } failure: { error in
            
        }


    }

    func openTestFligh(){
        // Special scheme specific to TestFlight
        let presenceCheck = URL(string: "itms-beta://")!
        // Special link that includes the app's ID
        let deepLink = URL(string: "https://beta.itunes.apple.com/v1/app/1552828354")!
        let app = UIApplication.shared
        if app.canOpenURL(presenceCheck) {
            app.open(deepLink)
        }
        
//        
//            let urlStr = "https://beta.itunes.apple.com"
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
//                
//            } else {
//                UIApplication.shared.openURL(URL(string: urlStr)!)
//            }
    }
   
   @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -200 // Move view 150 points upward
   }

   @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
   }
    
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
  
   @IBAction func btnLoginOnClick(_ sender: Any) {
      
      if(chkRemember.isOn){
         UserDefaults.standard.setValue(txtName.text, forKey: CONST_USER_NAME)
          if(self.txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
              self.callValidateDriver()
          }
      }else{
         UserDefaults.standard.removeObject(forKey:  CONST_USER_NAME)
         
         // Warn to user about auto login
          let confirmAlert = UIAlertController(title: "Tita Limo", message: "By logging in without remember me checked, application will not automatically login whenever user touch the incomming job notifcations. You will need to login manually.\nAre you sure you want to login?", preferredStyle: UIAlertController.Style.alert)
          
          confirmAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
              if(self.txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                  self.callValidateDriver()
              }
          }))
          
          confirmAlert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action: UIAlertAction!) in
              return;
          }))
          
          self.present(confirmAlert, animated: true, completion: nil)
        
      }

   }
   
   func callValidateDriver(){
       // check network connection here
        if (!isConnectedToInternet()){
            let confirmAlert = UIAlertController(title: "Erro in connection.", message: "Please check your internet connection and try again.", preferredStyle: UIAlertController.Style.alert)
            
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                confirmAlert.dismiss(animated: true)
            }))
            
            self.present(confirmAlert, animated: true, completion: nil)
        }
      
       
      Router.sharedInstance().ValidateDriver(driver: txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { [self] (successObj) in
         
         // valid
         if(successObj.responsemessage?.uppercased() == "VALID"){
           // self.view.makeToast("Valid")
            
            App.DRIVER_NAME = txtName.text!
            App.AUT_TOKEN = successObj.token!
            
            callUpdateDevice()
           
            // invalid
         }else{
             let confirmAlert = UIAlertController(title: "Tita Limo", message: "Invalid username.", preferredStyle: UIAlertController.Style.alert)
             
             confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                 let startPosition = self.txtName.beginningOfDocument
                 let endPosition = self.txtName.endOfDocument
                 self.txtName.selectedTextRange = self.txtName.textRange(from: endPosition, to: endPosition)
             }))
             
             self.present(confirmAlert, animated: true, completion: nil)
         }
         
      } failure: { (err) in
         self.view.makeToast(err)
      }
   }
   
   func callUpdateDevice(){
      Router.sharedInstance().UpdateDevice(deviceID: getDeviceID(), fcnToken: App.FCM_TOKEN){
         [self] (successObj) in
        // self.view.makeToast("Update device successfully")
    
         let vc = self.storyBoard.instantiateViewController(withIdentifier: "JobListViewController") as! JobListViewController
          
      //    let vc = self.storyBoard.instantiateViewController(withIdentifier: "PatientHistoryViewController") as! PatientHistoryViewController
         
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
         
      } failure: { (failureObj) in
         self.view.makeToast(failureObj)
      }
   }
   
   
   func callConfirmJobReminder(jobNo: String){
      Router.sharedInstance().ConfirmJobReminder(jobNo: jobNo,
                                              success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   //self.view.makeToast("Confrim Job Reminder Success")
                                                 //  urgentJobConfirm(msg: "Confrim Job Reminder Success")
                                                }
                                              }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                              })
   }
   
}
   


   
//   //Mark: location notification events
//   func urgentJobConfirm(msg: String) {
//
//       let content = UNMutableNotificationContent()
//       let categoryIdentifire = "Delete Notification Type"
//
//       content.title = "Urgent"
//       content.body = msg
//       content.sound = UNNotificationSound.default
//       content.badge = 1
//       content.categoryIdentifier = categoryIdentifire
//
//       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//       let identifier = "CONFIRM"
//       let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//       notificationCenter.add(request) { (error) in
//           if let error = error {
//               print("Error \(error.localizedDescription)")
//           }
//       }
//
//      // notificationCenter.setNotificationCategories([category])
//   }
//
//
//
//   @objc func confirmClicked(notification: NSNotification){
//      guard let jobNo = notification.userInfo!["jobNo"] as? String,
//            let name = notification.userInfo!["Name"] as? String,
//            let phone = notification.userInfo!["phone"] as? String,
//            let displayMsg = notification.userInfo!["displayMsg"] as? String
//      else{return}
//
//      callConfirmJobReminder(jobNo: jobNo)
//   }
//
//   @objc func notiReceived(notification: NSNotification){
////      urgentJobConfirm(msg: "Noti Received")
////      print("notiReceived")
////      DispatchQueue.main.async {
////         let vc = self.storyBoard.instantiateViewController(withIdentifier: "NotiViewController") as! NotiViewController
////
////         vc.modalPresentationStyle = .fullScreen
////         self.present(vc, animated: true, completion: nil)
////      }}
//   }
//
 
   




