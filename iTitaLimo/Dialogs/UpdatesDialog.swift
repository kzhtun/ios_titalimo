//
//  UpdatesDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 5/5/23.
//

import UIKit

class UpdatesDialog: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
    var textFieldColor = "#8a8a8aff"
    
    
    var jobAction = ""
    var jobNo = ""
    var updates = ""
    
    @IBOutlet var outsideView: UIView!
    @IBOutlet weak var txtUpdates: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    override func viewWillAppear(_ animated: Bool) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(outsideViewOnClick))
        outsideView.addGestureRecognizer(gesture)
        
        
        self.txtUpdates.text = updates.replacingOccurrences(of: "##-##" , with: "\n")
        
    }
    
    @IBAction func btnSaveOnClick(_ sender: Any) {
        callUpdateJobRemark(jobNo: self.jobNo, remark:   self.txtUpdates.text.replacingOccurrences(of: "\n" , with: "##-##") )
            
        self.view.makeToast("Update Job successfully")
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func outsideViewOnClick(sender : UITapGestureRecognizer){
       self.dismiss(animated: true, completion: nil)
       print("Outside View OnClick")
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -200 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func viewDidAppear(_ animated: Bool) {
       txtUpdates.setRoundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
        txtUpdates.isEditable = true
    }
    
    
    func callUpdateJobRemark(jobNo: String, remark: String){
        var jobInfo: [AnyHashable: Any]?
       
        Router.sharedInstance().UpdateJobRemarks(jobNo: jobNo,  remark: txtUpdates.text.replacingOccurrences(of: "\n" , with: "##-##"),
                                               success: {(successObj) in
                                                 if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                  
                                                     
                                                     NotificationCenter.default.post(name: Notification.Name("REFRESH_JOBS"), object: nil, userInfo: jobInfo)
                                                 }
                                               }, failure: { (failureObj) in
                                                 self.view.makeToast(failureObj)
                                               })
    }
   

}
