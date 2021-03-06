//
//  CompleteDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 18/11/2020.
//

import UIKit

class CompleteDialog: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   var textFieldColor = "#8a8a8aff"
   
   var jobAction = ""
   var jobNo = ""
   
  
   @IBOutlet var outsideView: UIView!
   @IBOutlet weak var jobDate: UILabel!
   @IBOutlet weak var jobTime: UILabel!
   @IBOutlet weak var address: UILabel!
   @IBOutlet weak var remarks: UITextView!
   
   func updateJobDetail(){
      let jobInfo: [AnyHashable: Any] = ["jobno" : jobNo] as [AnyHashable : Any]
   
      NotificationCenter.default.post(name: Notification.Name("SILENT_REFRESH_JOBS"), object: nil, userInfo: jobInfo)
      
      closeParentView()
   }
   
   func closeParentView(){
      let parentVC = self.presentingViewController as? JobDetailViewController
      parentVC?.dismiss(animated: false, completion: nil)
   }
   
   @IBAction func completeOnClick(_ sender: Any) {
      Router.sharedInstance().UpdateCompleteJob(jobNo: jobNo, address: App.fullAddress, remarks: remarks.text.replaceEscapeChr, status: "Completed") { [self] (successObj) in
         self.view.makeToast("Update Complete Job successfully")
         updateJobDetail()
         
         self.dismiss(animated: true, completion: nil)
      } failure: { (failureObj) in
         self.view.makeToast(failureObj)
      }
   }
   
   @objc func outsideViewOnClick(sender : UITapGestureRecognizer){
      self.dismiss(animated: true, completion: nil)
      print("Outside View OnClick")
   }
   
   override func viewWillAppear(_ animated: Bool) {
      let gesture = UITapGestureRecognizer(target: self, action: #selector(outsideViewOnClick))
      outsideView.addGestureRecognizer(gesture)
      
      remarks.setRoundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
      remarks.backgroundColor = UIColor(hex: textFieldColor)
      remarks.isEditable = true
      
      jobDate.text = getCurrentDateTimeString(formatString: "EEE, dd MMM yyyy")
      jobTime.text = getCurrentDateTimeString(formatString: "hh:mm a")
      address.text = App.fullAddress
    
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
   }
   
   @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -200 // Move view 150 points upward
   }

   @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
   }
   
   override func viewDidAppear(_ animated: Bool) {
      remarks.setRoundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
      remarks.isEditable = true
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
   
   }
   
}
