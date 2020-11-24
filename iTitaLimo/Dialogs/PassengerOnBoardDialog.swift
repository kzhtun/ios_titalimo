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
   
   let picker = UIImagePickerController()
   
   @IBOutlet var outsideView: UIView!
   @IBOutlet weak var signView: SignaturePad!
   @IBOutlet weak var tabPassenger: UIButton!
   @IBOutlet weak var tabSignature: UIButton!
   
   @IBOutlet weak var signatureWidth: NSLayoutConstraint!
   @IBOutlet weak var btnCamera: UIButton!
   
   @IBOutlet weak var photoView: UIView!
   
   @IBOutlet weak var imgPreview: UIImageView!
   
   @IBOutlet weak var remarks: UITextView!
   
   
   
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
   }
   
   
   @objc func outsideViewOnClick(sender : UITapGestureRecognizer){
      self.dismiss(animated: true, completion: nil)
      print("Outside View OnClick")
   }
   
   @IBAction func easerOnClick(_ sender: Any) {
      signView.clear()
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
      
      picker.sourceType =  .photoLibrary // .camera
      picker.delegate = self
      
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
      closeParentView()
   }
   override func viewDidAppear(_ animated: Bool) {
      buttonsReShape()
   }
   
   @IBAction func SubmitOnClick(_ sender: Any) {
      // upload signature
      if let signature = signView.getSignature() {
         let imagedata =  signature.jpegData(compressionQuality: 0.5)!
         uploadFTP(imageData: imagedata, fileName: "\(jobNo)_sign.jpg")
      }
      
      // upload passenger photo
      if let imagedata = imgPreview.image?.jpegData(compressionQuality: 0.5) {
         uploadFTP(imageData: imagedata, fileName: "\(jobNo)_sign.jpg")
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
         } failure: { (failureObj) in
            self.view.makeToast(failureObj)
         }
      }else{
         
         // Call Passenger On Board
         Router.sharedInstance().UpdateJobShowConfirm(jobNo: jobNo, address: App.fullAddress, remarks: remarks.text.replaceEscapeChr, status: "Passenger On Board") { (successObj) in
            self.view.makeToast("Update job successfully")
            self.updateJobDetail()
            self.dismiss(animated: true, completion: nil)
         } failure: { (failureObj) in
            self.view.makeToast(failureObj)
         }
      }
      
      
   }
   
   func updateJobDetail(){
      var info = [String: String]()
      info["jobNo"] = jobNo
   
      NotificationCenter.default.post(name: Notification.Name("UPDATE_JOB_DETAIL"), object: nil, userInfo: info)
      
      closeParentView()
   }
   
   @IBAction func SignOnClick(_ sender: Any) {
      tabSignature.backgroundColor = UIColor(hex: textFieldColor)
      tabPassenger.backgroundColor = nil
      
      signView.isHidden = false
      photoView.isHidden = true
   }
   
   @IBAction func PhotoOnClick(_ sender: Any) {
      tabSignature.backgroundColor = nil
      tabPassenger.backgroundColor = UIColor(hex: textFieldColor)
      
      photoView.backgroundColor = UIColor(hex: textFieldColor)
      signView.isHidden = true
      photoView.isHidden = false
   }
   
   
   @IBAction func cameraOnClick(_ sender: Any) {
      present(picker, animated: true)
   }
   
   
   func uploadFTP(imageData: Data, fileName: String){
      let ftpup = FTPUpload(baseUrl: "alexisinfo121.noip.me", userName: "ipos", password: "iposftp", directoryPath: "mycoachpics")
      
      ftpup.send(data: imageData, with: fileName, success: {(success) -> Void in
         if !success {
            print("Upload failured!")
         }
         else {
            print("Image uploaded!")
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
      
      //  uploadFTP()
   }
}

