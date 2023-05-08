//
//  PhoneTableViewCell.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 05/11/2020.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {

   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   static let indentifier = "PhoneTableViewCell"
   
   @IBOutlet weak var lblLabel: UILabel!
   @IBOutlet weak var lblMobile: UILabel!
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   public func configure(label: String, mobile: String){
      self.lblLabel.text = label
      self.lblMobile.text = mobile
   }
   
   @IBAction func btnCall(_ sender: Any) {
      if let url = URL(string: "tel://\(self.lblMobile.text!)"),
      UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
   }
   
   @IBAction func btnSms(_ sender: Any) {
      if let url = URL(string: "sms://\(self.lblMobile.text!)"),
      UIApplication.shared.canOpenURL(url) {
         UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
   }
    
    
    @IBAction func btnWhatsApp(_ sender: Any) {
        var phoneNo: String = self.lblMobile.text!
        var urlString = ""
        var urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
      //  var url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
       
        
        if(phoneNo.count > 8){
            phoneNo = "+" + phoneNo;
        }else{
            phoneNo = "+65" + phoneNo;
        }

        var url  = NSURL(string: "https://api.whatsapp.com/send?phone=\(phoneNo)&text=\(urlStringEncoded!)")
        
        
        if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.open(url! as URL, options: [:]) { (success) in
                        if success {
                            print("WhatsApp accessed successfully")
                        } else {
                            print("Error accessing WhatsApp")
                        }
                    }
            }
        
    }
    
}
