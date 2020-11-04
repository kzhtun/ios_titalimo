//
//  LoginViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 22/10/2020.
//

import UIKit
import Toast_Swift
import BEMCheckBox

class LoginViewController: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   let datePicker = UIDatePicker()
   
   let CONST_USER_NAME = "UserName"
   
   @IBOutlet weak var loginView: UIView!
   @IBOutlet weak var txtName: UITextField!
   
   @IBOutlet weak var chkRemember: BEMCheckBox!
   
   @IBOutlet weak var btnLogin: UIButton!
   
   var cacheUserName = ""
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      loginView.layer.cornerRadius = 10;
      loginView.layer.masksToBounds = true;
      loginView.layer.borderWidth = 1;
      loginView.layer.borderColor =  UIColor.init(hex: "#333333FF")?.cgColor
      
      txtName.layer.cornerRadius = 17;
      txtName.layer.masksToBounds = true;
      txtName.setLeftPaddingPoints(8)
      
      btnLogin.layer.cornerRadius = 20;
      btnLogin.layer.masksToBounds = false;
      
      cacheUserName = UserDefaults.standard.string(forKey: CONST_USER_NAME) ?? ""
      
      if(cacheUserName != ""){
         txtName.text = cacheUserName
         chkRemember.on = (YESSTR != 0)
        
      }else{
         txtName.text = ""
      }
      
      
   }
   
   
   
   @IBAction func btnLoginOnClick(_ sender: Any) {
      if(chkRemember.on){
         UserDefaults.standard.setValue(txtName.text, forKey: CONST_USER_NAME)
      }else{
         UserDefaults.standard.removeObject(forKey:  CONST_USER_NAME)
      }
      
      if(txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
         callValidateDriver()
      }
   }
   
   
   func callValidateDriver(){
      Router.sharedInstance().ValidateDriver(driver: txtName.text!.trimmingCharacters(in: .whitespacesAndNewlines)) { [self] (successObj) in
         
         // valid
         if(successObj.responsemessage?.uppercased() == "VALID"){
            self.view.makeToast("Valid")
            
            App.DRIVER_NAME = txtName.text!
            App.AUT_TOKEN = successObj.token!
            
            
            let vc = self.storyBoard.instantiateViewController(withIdentifier: "JobListViewController") as! JobListViewController

            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            
         
         // invalid
         }else{
            self.view.makeToast("Invalid")
         }
         
      } failure: { (err) in
         self.view.makeToast(err)
      }
   }
  
}



