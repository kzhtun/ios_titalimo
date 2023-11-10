//
//  PatientTableViewCell.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 11/9/23.
//

import UIKit



class PatientTableViewCell: UITableViewCell {
    static let indentifier = "PatientTableViewCell"
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var translator: UILabel!
    @IBOutlet weak var jobDate: UILabel!
    @IBOutlet weak var jobTime: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var dropoff: UILabel!
    @IBOutlet weak var updates: UILabel!
    
    static func nib()-> UINib{
       return UINib(nibName: "PatientTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(patient: Patient){
        jobType.text = patient.JobType
        translator.text = patient.Translator
        jobDate.text = patient.JobDate
        jobTime.text = patient.JobTime
        pickup.text = patient.PickupPoint
        dropoff.text = patient.AlightPoint
        updates.text = patient.Updates
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
