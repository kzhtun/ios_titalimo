//
//  JobTableViewCell.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 27/10/2020.
//

import UIKit

class JobTableViewCell: UITableViewCell {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   static let indentifier = "JobTableViewCell"
   
    @IBOutlet weak var btnPatientHistory: UIButton!
   
    @IBOutlet weak var staff: UILabel!
   
    @IBOutlet weak var updateViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var updatesView: UIStackView!
    @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var jobDate: UILabel!
   @IBOutlet weak var jobType: UILabel!
   @IBOutlet weak var jobStatus: UILabel!
   @IBOutlet weak var vehicleType: UILabel!
   @IBOutlet weak var jobTime: UILabel!
   @IBOutlet weak var pickup: UILabel!
   @IBOutlet weak var dropoff: UILabel!
   @IBOutlet weak var passenger: UILabel!
   @IBOutlet weak var mobile: UILabel!
   
    @IBOutlet weak var btnAdd: UIButton!
   
//    @IBAction func btnAddOnClick(_ sender: Any) {
//
//   }
    
    @IBOutlet weak var updates: UILabel!
    
   @IBOutlet weak var JobDateConstraints: NSLayoutConstraint!
   
   static func nib()-> UINib{
      return UINib(nibName: "JobTableViewCell", bundle: nil)
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   
    public func configure(tab: Int, jobDate: String, jobType: String, jobStatus: String, vehicleType: String, jobTime: String,
                          pickup: String, dropoff: String, passenger: String, mobile: String, updates: String, staff: String, index: Int){
        
        
        
        btnAdd.layer.cornerRadius = 13;
        btnAdd.layer.masksToBounds = true;
        
        btnPatientHistory.layer.cornerRadius = 13;
        btnPatientHistory.layer.masksToBounds = true;
        
        
        
        var mobileNoSpace = "";
        
        //   newUpdates = (updates == "##-##") ? "" : updates
        
        var  jobStatus = (jobStatus.uppercased() == "JOB NEW") ? "JOB ASSIGNED" : jobStatus.uppercased()
        
        self.jobDate.text = jobDate
        self.jobType.text = jobType
        self.jobStatus.text = jobStatus
        self.vehicleType.text = vehicleType
        self.jobTime.text = jobTime
        self.pickup.text = pickup
        self.dropoff.text = dropoff
        self.passenger.text = passenger
        mobileNoSpace =  mobile.replacingOccurrences(of: " ", with: "")
        self.mobile.text = mobileNoSpace.replacingOccurrences(of: "/", with: "\n")
        
        
        //  self.updates.text = newUpdates.replacingOccurrences(of: "##-##", with: "\n")
        
        self.staff.text = staff
        self.btnAdd.tag = index
        self.btnPatientHistory.tag = index
        
        if(updates.count == 0 || updates == "##-##"){
            self.btnAdd.setTitle("ADD", for: UIControl.State.normal)
            self.btnAdd.backgroundColor = UIColor.init(red: 0/255, green: 150/255, blue: 255/255, alpha: 1 )
            //self.btnAdd.backgroundColor = UIColor.init(hex: "#0097FFAA")
        }else
        {
            self.btnAdd.setTitle("VIEW", for: UIControl.State.normal)
            self.btnAdd.backgroundColor = UIColor.init(red: 255/255, green: 150/255, blue: 0/255, alpha: 1 )
            //  self.btnAdd.backgroundColor = UIColor.init(hex: "#FF9400AA")
        }
        
    }
   
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      //Set containerView drop shadow
      
      //  containerView.layer.backgroundColor = UIColor.white.cgColor
      containerView.layer.cornerRadius = 10
      containerView.layer.borderWidth = 1.0
      containerView.layer.borderColor = UIColor.init(hex: "#333333FF")?.cgColor
     
      
   }
   
}
