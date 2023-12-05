//
//  AnalyticsReportDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 12/5/23.
//

import UIKit

class AnalyticsReportDialog: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var txtRemark: UITextView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBAction func btnCancelTouchDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnSubmitTouchDown(_ sender: Any) {
        Router.sharedInstance().UpdateMobileLog(StackTraceLog: App.StackTraceLog, Remarks: txtRemark.text,
                                               success: {(successObj) in
                                                 if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                     print("Log Update Successful")
                                                     self.view.makeToast("Stack Trace Sending Successful")
                                                     
                                                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                         self.dismiss(animated: true, completion: nil)
                                                     }
                                                     
                                                   
                                                 }
                                               }, failure: { (failureObj) in
                                                   print("Log Update Failed")
                                                   self.view.makeToast("Stack Trace Sending Failed")
                                                   
                                                   DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                       self.dismiss(animated: true, completion: nil)
                                                   }
                                               })
        
    }
    
    

}
