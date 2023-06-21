//
//  PassengerOnBoardDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 09/11/2020.
//

import UIKit
import SignaturePad

class PassengerOnBoardDialog: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   var actionDialog: ActionDialog?
  
   var textFieldColor = "#FFFFFFFF"
   
   var jobAction = ""
   var jobNo = ""
   
   var signatureData: Data?
   
   let picker = UIImagePickerController()
   
    var hasSignature = false
  
  
    @IBOutlet var outsideView: UIView!
   @IBOutlet weak var signView: SignaturePad!
   @IBOutlet weak var tabPassenger: UIButton!
   @IBOutlet weak var tabSignature: UIButton!
   
   @IBOutlet weak var signatureWidth: NSLayoutConstraint!
   @IBOutlet weak var btnCamera: UIButton!
   
   @IBOutlet weak var photoView: UIView!
   
   @IBOutlet weak var imgPreview: UIImageView!
   
   @IBOutlet weak var remarks: UITextView!
   
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBAction func btnClear_TouchDown(_ sender: Any) {
        signView.clear()
        //print("Clear OnClick");
        hasSignature = false
    }
    
  
    @IBAction func btnDone_TouchDown(_ sender: Any) {
        
        if(hasSignature){
            // upload signature
            if (signView.getSignature() != nil) {
                //  self.btnErase.isHidden = true
                //  self.btnEraseHeightConstraints.constant = 0
                
                DispatchQueue.main.async{
                    if(self.photoView.isHidden){
                        if let signature = self.signView.getSignature() {
                            self.signatureData = signature.jpegData(compressionQuality: 0.5)!
                        }
                    }
                    self.uploadFTP2(imageData: self.signatureData!, fileName: "\(self.jobNo)_sign.jpg")
                }
            }
        }else{
            // show confirmation dialog to user
            var confirmAlert = UIAlertController(title: "Tita Limo", message: "Signature is blank do you want to save this?", preferredStyle: UIAlertController.Style.alert)

            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
              }))

            confirmAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
              }))

            present(confirmAlert, animated: true, completion: nil)
        }
    }
    
    
    
   override func viewWillAppear(_ animated: Bool) {
      let gesture = UITapGestureRecognizer(target: self, action: #selector(outsideViewOnClick))
      outsideView.addGestureRecognizer(gesture)
      
      remarks.backgroundColor = UIColor(hex: textFieldColor)
      
    //  actionDialog?.dismiss(animated: true, completion: nil)
      
      // show/ hide signature
      if(jobAction == "NS"){
         signatureWidth.constant = 0
         tabPassenger.sendActions(for: .touchUpInside)
      }
      
      
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
   }
   
   @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -200 // Move view 150 points upward
   }

   @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
   }
   
   @objc func outsideViewOnClick(sender : UITapGestureRecognizer){
      self.dismiss(animated: true, completion: nil)
      print("Outside View OnClick")
   }
   
  
   
   func buttonsReShape(){
      tabSignature.setTopButtonCornerRounded(value: 5)
      tabPassenger.setTopButtonCornerRounded(value: 5)
      
      signView.setBottomViewCornerRounded(value: 5)
      photoView.setBottomViewCornerRounded(value: 5)
      
      remarks.setRoundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 5)
      remarks.isEditable = true
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if UIImagePickerController.isSourceTypeAvailable(.camera){
         picker.sourceType =  .camera //.photoLibrary
         picker.delegate = self
         picker.allowsEditing = false
      }
      
      tabSignature.backgroundColor = UIColor(hex: textFieldColor)
      tabPassenger.backgroundColor = nil
      
      photoView.isHidden = true
      signView.delegate = self
      
      buttonsReShape()
   }
   
   func closeParentView(){
      let parentVC = self.presentingViewController as? ActionDialog
      parentVC?.dismiss(animated: false, completion: nil)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)
    //  closeParentView()
   }
   override func viewDidAppear(_ animated: Bool) {
      buttonsReShape()
   }
    
   
   
   @IBAction func SubmitOnClick(_ sender: Any) {
       
       // upload passenger photo
       var subfix = ""
       if(jobAction == "NS"){
          subfix = "_no_show.jpg"
       }else{
          subfix = "_show.jpg"
       }
       
       //  uploadFTP()
       if let imagedata = imgPreview.image?.jpegData(compressionQuality: 0.5) {
          DispatchQueue.main.async{
             self.uploadFTP(imageData: imagedata, fileName: self.jobNo + subfix)
          }
       }
       
      if(remarks.text.isEmpty){
         remarks.text = " "
      }
      
      // Call Passenger No Show
      if(jobAction == "NS"){
         Router.sharedInstance().UpdateJobNoShowConfirm(jobNo: jobNo, address: App.fullAddress, remarks: remarks.text.replaceEscapeChr, status: "Passenger No Show") { [self] (successObj) in
            self.view.makeToast("Update job successfully")
            updateJobDetail()
            self.dismiss(animated: true, completion: nil)
            self.closeParentView()
         } failure: { (failureObj) in
            self.view.makeToast(failureObj)
         }
      }else{
         
         // Call Passenger On Board
         Router.sharedInstance().UpdateJobShowConfirm(jobNo: jobNo, address: App.fullAddress, remarks: remarks.text.replaceEscapeChr, status: "Passenger On Board") { (successObj) in
            self.view.makeToast("Update job successfully")
            self.updateJobDetail()
            self.dismiss(animated: true, completion: nil)
            self.closeParentView()
         } failure: { (failureObj) in
            self.view.makeToast(failureObj)
         }
      }
       
    //   btnErase.isHidden = false
     //  btnEraseHeightConstraints.constant = 32
    
   }
   
   func updateJobDetail(){

      let jobInfo: [AnyHashable: Any] = ["jobno" : jobNo] as [AnyHashable : Any]
      
      NotificationCenter.default.post(name: Notification.Name("SILENT_REFRESH_JOBS"), object: nil, userInfo: jobInfo)
      
      closeParentView()
   }
   
   @IBAction func SignOnClick(_ sender: Any) {
      tabSignature.backgroundColor = UIColor(hex: textFieldColor)
      tabPassenger.backgroundColor = nil
      
      signView.isHidden = false
      photoView.isHidden = true
       
    
       btnClear.isHidden = false
       btnDone.isHidden = false
      
     
   }
   
   @IBAction func PhotoOnClick(_ sender: Any) {
      tabSignature.backgroundColor = nil
      tabPassenger.backgroundColor = UIColor(hex: textFieldColor)
      
      photoView.backgroundColor = UIColor(hex: textFieldColor)
       
      signView.isHidden = true
      photoView.isHidden = false
       
       btnClear.isHidden = true
       btnDone.isHidden = true
      
      // upload signature
      if let signature = signView.getSignature() {
         signatureData = signature.jpegData(compressionQuality: 0.5)!
      }
   }
   
   
   @IBAction func cameraOnClick(_ sender: Any) {
      present(picker, animated: true)
   }
   
   
   func uploadFTP(imageData: Data, fileName: String){
       var dialogMessage = UIAlertController(title: "", message: "Initializing ...", preferredStyle: .alert)
       // Present alert to user
       self.present(dialogMessage, animated: true, completion: nil)
     
       let ftpup = FTPUpload()
       
      ftpup.send(data: imageData, with: fileName, success: {(success) -> Void in
         if !success {
            print("Upload failured!")
             dialogMessage.dismiss(animated: true)
         }
         else {
            print("Image uploaded!")
             dialogMessage.dismiss(animated: true)
         }
      })
   }
   
   func uploadFTP2(imageData: Data, fileName: String){
       var dialogMessage = UIAlertController(title: "", message: "Initializing ...", preferredStyle: .alert)
       // Present alert to user
       self.present(dialogMessage, animated: true, completion: nil)
     
       let ftpup = FTPUpload()
       
      
      ftpup.send(data: imageData, with: fileName, success: {(success) -> Void in
         if !success {
            print("Upload failured!")
             dialogMessage.dismiss(animated: true)
         }
         else {
            print("Image uploaded!")
             dialogMessage.dismiss(animated: true)
         }
      })
   }
}


extension PassengerOnBoardDialog: SignaturePadDelegate {
   func didStart() {
      print("Did Start")
      //   signView.backgroundColor = UIColor(hex: "#5c5c5cff")
   }
   
   func didFinish() {
      print("Did Finish")
       hasSignature = true

      //  signView.backgroundColor = UIColor(hex: "#5c5c5cff")
   }
   
   
}


extension PassengerOnBoardDialog: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated: true, completion: nil)
   }
   
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
         return
      }
      imgPreview.image = image
      
      picker.dismiss(animated: true, completion: nil)
      imgPreview.bringSubviewToFront(btnCamera)
      
       
       
   }
}

