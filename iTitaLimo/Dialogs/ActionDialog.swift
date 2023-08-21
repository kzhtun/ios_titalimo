//
//  ActionDialog.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 08/11/2020.
//

import UIKit


class ActionDialog: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   var jobNo = ""
   var job = JobDetail()
  
   @IBOutlet var outsideView: UIView!
   @IBOutlet weak var btnPOB: UIButton!
   @IBOutlet weak var btnNS: UIButton!
   @IBOutlet weak var btnBack: UIButton!
   
   override func viewWillAppear(_ animated: Bool) {
//      let gesture = UITapGestureRecognizer(target: self, action: #selector(outsideViewOnClick))
//      outsideView.addGestureRecognizer(gesture)
      
      // set buttons color
      btnPOB.backgroundColor = UIColor(hex: App.ButtonGreen)
      btnNS.backgroundColor = UIColor(hex: App.ButtonGreen)
      btnBack.backgroundColor = UIColor(hex: App.ButtonRed)
       
       NotificationCenter.default.addObserver(self, selector: #selector(closeActionDialog), name: NSNotification.Name(rawValue: "CLOSE_ACTION_DIALOG"), object: nil)
   }
   
  
    @objc func closeActionDialog(){
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
             if touch?.view == self.outsideView {
                 self.dismiss(animated: true, completion: nil)
            }
    }
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }

   
    
   override func viewWillDisappear(_ animated: Bool) {
      
   }
    
    
   
   @IBAction func pobOnClick(_ sender: Any) {
   
      let vc = PassengerOnBoardDialog()
      vc.jobAction = "POB"
      vc.job = self.job
      vc.jobNo = jobNo
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle =  .overCurrentContext
      
      self.present(vc, animated:  true, completion: nil)
       
   }
   
   
   @IBAction func nsOnClick(_ sender: Any) {
      let vc = PassengerOnBoardDialog()
      vc.job = self.job
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
