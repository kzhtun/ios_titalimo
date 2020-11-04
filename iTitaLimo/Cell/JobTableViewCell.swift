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
   
   @IBOutlet weak var JobDateConstraints: NSLayoutConstraint!
   
   static func nib()-> UINib{
      return UINib(nibName: "JobTableViewCell", bundle: nil)
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
   }
   
   
   public func configure(jobDate: String, jobType: String, jobStatus: String, vehicleType: String, jobTime: String,
                         pickup: String, dropoff: String, passenger: String, mobile: String){
      
      //      self.jobDate.isHidden = true
      //      self.jobDate.frame.size.height = 0
      
      self.jobDate.text = jobDate
      self.jobType.text = jobType
      self.jobStatus.text = jobStatus
      self.vehicleType.text = vehicleType
      self.jobTime.text = jobTime
      self.pickup.text = pickup
      self.dropoff.text = dropoff
      self.passenger.text = passenger
      self.mobile.text = mobile
   }
   
//   override func setSelected(_ selected: Bool, animated: Bool) {
//      super.setSelected(selected, animated: animated)
//
//      NotificationCenter.default.post(name: Notification.Name("JOB_SELECTED"), object: nil, userInfo: nil)
//
//   }
   
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      //Set containerView drop shadow
      
      //  containerView.layer.backgroundColor = UIColor.white.cgColor
      containerView.layer.cornerRadius = 10
      containerView.layer.borderWidth = 1.0
      containerView.layer.borderColor = UIColor.init(hex: "#333333FF")?.cgColor
      //       containerView.layer.shadowColor = UIColor.lightGray.cgColor
      //              containerView.layer.shadowRadius = 5.0
      //              containerView.layer.shadowOpacity = 10.0
      //              containerView.layer.shadowOffset = CGSize(width:2, height: 2)
      //              containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
      
   }
   
}
