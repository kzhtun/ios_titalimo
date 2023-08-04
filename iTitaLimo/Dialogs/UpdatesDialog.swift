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
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(outsideViewOnClick))
//        outsideView.addGestureRecognizer(gesture)
//        
        var newUpdates = (updates == "##-##") ? "" : updates
        
        self.txtUpdates.text = newUpdates.replacingOccurrences(of: "##-##" , with: "\n")
        
    }
    
    @IBAction func btnSaveOnClick(_ sender: Any) {
        
        self.callUpdateJobRemark(jobNo: self.jobNo, remark:   self.txtUpdates.text )
       
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
             if touch?.view == self.outsideView {
                 self.dismiss(animated: true, completion: nil)
            }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -200 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func viewDidLayoutSubviews() {
        buttonsReShape()
    }
    
    func buttonsReShape(){
        txtUpdates.setRoundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
        txtUpdates.isEditable = true
    }
    
    func callUpdateJobRemark(jobNo: String, remark: String){
        var jobInfo: [AnyHashable: Any]?
        var newRemark = ""
        
        newRemark = (remark.isEmpty) ? "\n" : remark
      //  newRemark = newRemark.replacingOccurrences(of: "", with: "")
        newRemark = newRemark.replacingOccurrences(of: "\n" , with: "##-##")
        newRemark = newRemark.replacingOccurrences(of: "/" , with: "|")
        newRemark = newRemark.replacingOccurrences(of: "\\" , with: "|")
        
       
        
        Router.sharedInstance().UpdateJobRemarks(jobNo: jobNo,  remark: newRemark,
                                               success: {(successObj) in
                                                 if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                     
                                                 self.view.makeToast("Update Job successfully")
                                                 self.dismiss(animated: true, completion: nil)
                                                     
                                                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                         // Notify JobListView
                                                         NotificationCenter.default.post(name: Notification.Name("REFRESH_JOBS"), object: nil, userInfo: jobInfo)
                                                     }
                                                     
                                                     
                                                 }
                                               }, failure: { (failureObj) in
                                                 self.view.makeToast(failureObj)
                                                 self.dismiss(animated: true, completion: nil)
                                               })
    }
   

}
