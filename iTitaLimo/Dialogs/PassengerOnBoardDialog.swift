//
//  PassengerOnBoardDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 09/11/2020.
//

import UIKit
import SignaturePad
import SDWebImage


class PassengerOnBoardDialog: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
    var actionDialog: ActionDialog?
    
  
    @IBOutlet weak var lblTitle: UILabel!
    
    var textFieldColor = "#FFFFFFFF"
    
    var jobAction = ""
    var jobNo = ""
    var job = JobDetail()
    var titleText = ""
    
    
    @IBOutlet weak var signPreviewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var signPreviewConstraintWidth: NSLayoutConstraint!
    var signatureData: Data?
    
    let picker = UIImagePickerController()
    
    var hasSignature = false
    
    @IBOutlet weak var signPreview: UIImageView!
    
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
    var indicator: UIActivityIndicatorView!
    
    
  
    var dialogInitializing = UIAlertController(title: "Initializing ...", message: "\n\nPlease wait. This may take 10 to 15 seconds ", preferredStyle: .alert)
   
    
    @IBAction func btnPassengerTouchDown(_ sender: Any) {
        PhotoOnClick(tabPassenger!)
    }
    
    @IBAction func btnSignatureTouchDown(_ sender: Any) {
        SignOnClick(tabSignature!)
    }
    
    
    
    override func viewWillLayoutSubviews() {
        indicator = UIActivityIndicatorView(frame: dialogInitializing.view.bounds)
                indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                //add the activity indicator as a subview of the alert controller's view
                dialogInitializing.view.addSubview(indicator)
                indicator.color = .blue
                indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        
        
        lblTitle.text = titleText
    
    }
    
    func loadSignatureAndPassengerPhoto(){
        var signURL: String = ""
        var photoURL: String =  ""
       
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        // load signature photo
        signURL =  FTPUpload.getPhotoURL() + job.JobNo + "_signature.jpg"
        signPreview.sd_setImage(with: URL(string: signURL)){ (image, error, cache, url) in
            let cgref = self.signPreview.image?.cgImage
            let cim = self.signPreview.image?.ciImage
            
            if(cim == nil && cgref == nil){
                self.changeSignaturePadMode(mode: "NEW")
           
            }else{
                self.changeSignaturePadMode(mode: "EDIT")
            }
        }
     
        // load passenger photo
        if(jobAction == "NS"){
            photoURL = FTPUpload.getPhotoURL() + job.NoShowPhoto
        }else{
            photoURL = FTPUpload.getPhotoURL() + job.ShowPhoto
        }
      
        
        DispatchQueue.main.async { [weak self] in
                        self?.imgPreview.isHidden = false
                        self?.imgPreview.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self?.imgPreview.sd_setImage(with: URL(string: photoURL))
                    }
        
    }
    
    @IBAction func btnClear_TouchDown(_ sender: Any) {
        signView.clear()
        print("Clear OnClick");
        hasSignature = false
        
        changeSignaturePadMode(mode: "NEW")
        
       // let img = UIImage(named: "signPreview")?.withAlpha(0.5)
        
//        signPreviewConstraintWidth.constant = 0
//        signPreviewConstraintHeight.constant = 0
       // self.btnDone.setTitle("DONE", for: .normal)
    }
    
    
    func changeSignaturePadMode(mode: String){
        if(mode == "EDIT"){
            signPreview.isHidden = false
            self.btnDone.setTitle("SAVED", for: .normal)
        }else{
            
            signPreview.image = nil
            signPreview.isHidden = true
            self.btnDone.setTitle("DONE", for: .normal)
        }
        
        signView.layoutIfNeeded()
    }
  
    @IBAction func btnDone_TouchDown(_ sender: Any) {
        if(self.hasSignature){
            // upload signature
            if (self.signView.getSignature() != nil) {
               
                self.indicator.startAnimating()
                // show initializing dialog
                self.present(self.dialogInitializing, animated: true, completion: {()-> Void in
                    if(self.photoView.isHidden){
                        if let signature = self.signView.getSignature() {
                            self.signatureData = signature.jpegData(compressionQuality: 0.5)!
                        }
                    }
                    self.uploadSignature(imageData: self.signatureData!, fileName: "\(self.jobNo)_signature.jpg")
                })
            }
        }else{
            // show confirmation dialog to user
            var confirmAlert = UIAlertController(title: "Tita Limo", message: "Signature is blank do you want to save this?", preferredStyle: UIAlertController.Style.alert)

            confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                // YES
                    self.present(self.dialogInitializing, animated: true, completion: {()-> Void in
                    if(self.photoView.isHidden){
                        if let signature = self.signView.getSignature() {
                            self.signatureData = signature.jpegData(compressionQuality: 0.5)!
                        }
                    }
                    self.uploadSignature(imageData: self.signatureData!, fileName: "\(self.jobNo)_signature.jpg")
                })
              }))

            confirmAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                 // NO
              }))

             self.present(confirmAlert, animated: true, completion: nil)
        }
        
       
      
    }
    
   
   override func viewWillAppear(_ animated: Bool) {
      // clear sdWebImage cache
//       SDImageCache.shared.clearMemory()
//       SDImageCache.shared.clearDisk()
//       SDImageCache.shared.config.shouldCacheImagesInMemory = false
          
      
       
       remarks.backgroundColor = UIColor(hex: textFieldColor)
       
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
   
//   @objc func outsideViewOnClick(sender : UITapGestureRecognizer){
//     // self.dismiss(animated: true, completion: nil)
//      print("Outside View OnClick")
//   }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
             if touch?.view == self.outsideView {
                 self.dismiss(animated: true, completion: nil)
            }
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
       
       loadSignatureAndPassengerPhoto()
   
   }
    
    
   
   func closeParentView(){
      let parentVC = self.presentingViewController as? ActionDialog
      parentVC?.dismiss(animated: false, completion: nil)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(true)
      // NotificationCenter.default.post(name: Notification.Name("CLOSE_JOB_DETAILS"), object: nil, userInfo: nil)
     //  closeParentView()
   }
  
    
    override func viewDidLayoutSubviews() {
        buttonsReShape()
    }
    
  
   
   @IBAction func SubmitOnClick(_ sender: Any) {
      
       
       if(remarks.text.isEmpty){
          remarks.text = " "
       }
       let cgref = imgPreview.image?.cgImage
       let cim = imgPreview.image?.ciImage
       
       
       // Call Passenger No Show
       if(jobAction == "NS"){
           callPassengerNoShowSave()
       }else{
           if(btnDone.titleLabel?.text == "SAVED"){
               if(cim == nil && cgref == nil){
                   // if no passenger photo, update job directly
                   self.callPassenerOnBoardSave()
               }else{
                   // have passenger photo, upload the photo first
                   self.uploadPassengerPhoto()
               }
    
           }else{
               
               // confirm signature blank saving?
               let confirmAlert = UIAlertController(title: "Tita Limo", message: "Either signature is blank or has not been done.\nDo you want to proceed?", preferredStyle: UIAlertController.Style.alert)
               
                   confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                   
                   if(cim == nil && cgref == nil){
                       // if no passenger photo, update job directly
                       self.callPassenerOnBoardSave()
                   }else{
                       // have passenger photo, upload the photo first
                       self.uploadPassengerPhoto()
                   }
                  
               }))
               
               confirmAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                   print("Handle Cancel Logic here")
               }))
               
               self.present(confirmAlert, animated: true, completion: nil)
           }
          
       }
     
   }
    
    
    func uploadPassengerPhoto(){
        // upload passenger photo
        var subfix = ""
        if(jobAction == "NS"){
           subfix = "_no_show.jpg"
        }else{
           subfix = "_show.jpg"
        }
        
        self.indicator.startAnimating()
        self.present(self.dialogInitializing, animated: true, completion: {()-> Void in
            
            //  uploadFTP()
            if let imagedata = self.imgPreview.image?.jpegData(compressionQuality: 0.5) {
                
                let photoUploaded = self.uploadPhoto(imageData: imagedata, fileName: self.jobNo + subfix)
              
                if(photoUploaded){
                    self.callPassenerOnBoardSave()
                    
                    // update file name to DB after uploading successful
                    if(self.jobAction == "NS"){
                        self.callSaveNoShowPic(jobNo: self.jobNo, filename: self.jobNo + subfix)
                    }else{
                        self.callSaveShowPic(jobNo: self.jobNo, filename: self.jobNo + subfix)
                    }
                }
            }
        })
        
        
    }
   
    
    func callSignatureSave(jobNo: String, filename: String){
        
        Router.sharedInstance().SaveSignature(jobNo: jobNo, fileName: filename) { responseObject in
            //
        } failure: { error in
            self.view.makeToast(error)
        }
    }
    
    func callSaveShowPic(jobNo: String, filename: String){
     
        Router.sharedInstance().SaveShowPic(jobNo: jobNo, fileName: filename) { responseObject in
            //
        } failure: { error in
            self.view.makeToast(error)
        }
    }
    
    func callSaveNoShowPic(jobNo: String, filename: String){
      
        Router.sharedInstance().SaveNoShowPic(jobNo: jobNo, fileName: filename) { responseObject in
            //
        } failure: { error in
            self.view.makeToast(error)
        }
    }
    
    
    func callPassengerNoShowSave(){
        closeParentView()
        Router.sharedInstance().UpdateJobNoShowConfirm(jobNo: jobNo, address: App.fullAddress, remarks: remarks.text.replaceEscapeChr, status: "Passenger No Show") { [self] (successObj) in
           self.view.makeToast("Update job successfully")
           updateJobDetail()
           self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: Notification.Name("CLOSE_ACTION_DIALOG"), object: nil, userInfo: nil)
        
        } failure: { (failureObj) in
           self.view.makeToast(failureObj)
        }
    }
    
    func callPassenerOnBoardSave(){
        // Call Passenger On Board
        closeParentView()
        Router.sharedInstance().UpdateJobShowConfirm(jobNo: jobNo, address: App.fullAddress, remarks: remarks.text.replaceEscapeChr, status: "Passenger On Board") { (successObj) in
            self.view.makeToast("Update job successfully")
            self.updateJobDetail()
            self.dismiss(animated: true, completion: nil)
           
            NotificationCenter.default.post(name: Notification.Name("CLOSE_ACTION_DIALOG"), object: nil, userInfo: nil)
           
        } failure: { (failureObj) in
            self.view.makeToast(failureObj)
        }
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
   
   
   func uploadPhoto(imageData: Data, fileName: String) -> Bool{
     //  var dialogMessage = UIAlertController(title: "", message: "Initializing ...", preferredStyle: .alert)
     
      let ftpup = FTPUpload()
       var result: Bool = false
       
      ftpup.send(data: imageData, with: fileName, success: {(success) -> Void in
         if !success {
             print("Upload failured!")
             self.dialogInitializing.dismiss(animated: true, completion:  {()-> Void in
                 self.showPassengerPhotoUploadError()
                 
             })
             result = false
         }
         else {
             print("Image uploaded!")
             self.dialogInitializing.dismiss(animated: true)
             result = true
         }
      })
       
      return result
   }
   
   // SignatureUpload
    func uploadSignature(imageData: Data, fileName: String){
       
        let ftpup = FTPUpload()
       
        ftpup.send(data: imageData, with: fileName, success: {(success) -> Void in
          if !success {
             print("Upload failured!")
              self.dialogInitializing.dismiss(animated: true, completion:  {()-> Void in
                  self.showSignatureUploadError()
              })
             
          }
          else {
             print("Image uploaded!")
             self.dialogInitializing.dismiss(animated: true)
             self.btnDone.setTitle("SAVED", for: .normal)
              // update file name to DB after ftp upload successful
              self.callSignatureSave(jobNo: self.jobNo, filename: "\(self.jobNo)_signature.jpg")
          }
       })
    }
    
//   func uploadFTP2(imageData: Data, fileName: String){
//
//       let ftpup = FTPUpload()
//
//       ftpup.send(data: imageData, with: fileName, success: {(success) -> Void in
//         if !success {
//            print("Upload failured!")
//             self.dialogInitializing.dismiss(animated: true, completion:  {()-> Void in
//                 self.showSignatureUploadError()
//             })
//
//         }
//         else {
//            print("Image uploaded!")
//            self.dialogInitializing.dismiss(animated: true)
//            self.btnDone.setTitle("SAVED", for: .normal)
//         }
//
//      })
//   }
    
    func showSignatureUploadError(){
        let infoAlert = UIAlertController(title: "Tita Limo", message: "Error in signature uploading.", preferredStyle: UIAlertController.Style.alert)
        
        infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            infoAlert.dismiss(animated: true)
        }))
        
      
        self.present(infoAlert, animated: true, completion: nil)
    }
    
    func showPassengerPhotoUploadError(){
        let infoAlert = UIAlertController(title: "Tita Limo", message: "Error in photo uploading.", preferredStyle: UIAlertController.Style.alert)
        
        infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            infoAlert.dismiss(animated: true)
        }))
        
      
        self.present(infoAlert, animated: true, completion: nil)
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
       
//       SDImageCache.shared.clearMemory()
//       SDImageCache.shared.clearDisk()
       
      imgPreview.image = nil
      imgPreview.image = image
      
      picker.dismiss(animated: true, completion: nil)
      imgPreview.bringSubviewToFront(btnCamera)
      
       
       
   }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


