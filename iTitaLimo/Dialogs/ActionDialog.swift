//
//  ActionDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 08/11/2020.
//

import UIKit

class ActionDialog: UIViewController {
   var jobNo = ""
  

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }


   @IBAction func pobOnClick(_ sender: Any) {
      //dialog.dismiss(animated: false, completion: nil)
      
      let vc = PassengerOnBoardDialog()
      vc.jobAction = "POB"
      vc.jobNo = jobNo
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overCurrentContext
   
      self.present(vc, animated:  true, completion: nil)
   }
   
   
   @IBAction func nsOnClick(_ sender: Any) {
      let vc = PassengerOnBoardDialog()
      vc.jobAction = "NS"
      vc.jobNo = jobNo
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overCurrentContext
   
      self.present(vc, animated:  true, completion: nil)
   }
   
   
   @IBAction func backOnClick(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
   
   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
