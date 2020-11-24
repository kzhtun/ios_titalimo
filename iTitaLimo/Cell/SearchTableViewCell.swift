//
//  SearchTableViewCell.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 28/10/2020.
//

import UIKit


class SearchTableViewCell: UITableViewCell {
   let App = UIApplication.shared.delegate as! AppDelegate
   
   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var btnSearch: UIButton!
   
   @IBOutlet weak var pName: UITextField!
   @IBOutlet weak var sDate: UITextField!
   @IBOutlet weak var eDate: UITextField!
   
   @IBOutlet weak var headerHeightConstraints: NSLayoutConstraint!
   
   let datePicker = UIDatePicker()
   
   var searchAction: ((_ name: String)-> Void)? = nil
   
   var callBack: ((_ name: String)-> Void)? = nil
   
   
   static func nib()-> UINib{
      return UINib(nibName: "SearchTableViewCell", bundle: nil)
   }
   
   
   public func configure(searchParam: SearchFilter){
      self.sDate.text = searchParam.sDate
      self.eDate.text = searchParam.eDate
     
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      
      initSDatePicker()
      initEDatePicker()
      
      pName.layer.cornerRadius = 12;
      pName.layer.masksToBounds = true;
      pName.setLeftPaddingPoints(8)
      
      sDate.layer.cornerRadius = 12;
      sDate.layer.masksToBounds = true;
      sDate.setLeftPaddingPoints(8)
      
      eDate.layer.cornerRadius = 12;
      eDate.layer.masksToBounds = true;
      eDate.setLeftPaddingPoints(8)
      
      btnSearch.layer.cornerRadius = 15;
      btnSearch.layer.masksToBounds = true;
   
      //containerView.isHidden = true
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
 
      // Configure the view for the selected state
   }
   
   
   func initSDatePicker(){
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      
      let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.sDoneOnClick))
      toolbar.setItems([btnDone], animated: true)
      
      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
      
      self.sDate.inputAccessoryView = toolbar
      self.sDate.inputView = datePicker
   }
   
   
   func initEDatePicker(){
      let toolbar = UIToolbar()
      toolbar.sizeToFit()
      
      let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.eDoneOnClick))
      toolbar.setItems([btnDone], animated: true)
      
      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
      
      self.eDate.inputAccessoryView = toolbar
      self.eDate.inputView = datePicker
   }
  
   @IBAction func btnSearchOnClick(){
      
      var criteria = [String: String]()
      
      criteria["passenger"] = pName.text!.isEmpty ? " ".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! : pName.text
      criteria["sDate"] = sDate.text!.isEmpty ? " ".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! : sDate.text
      criteria["eDate"] = eDate.text!.isEmpty ? " ".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! : eDate.text
      criteria["sorting"] = "0"
      
      NotificationCenter.default.post(name: Notification.Name("SEARCH_CLICKED"), object: nil, userInfo: criteria)
   }
   
   @objc func sDoneOnClick(){
      self.sDate.resignFirstResponder()
      self.sDate.endEditing(true)
      
      let format = DateFormatter()
      format.dateFormat = "dd MMM yyyy"
      sDate.text = format.string(from: datePicker.date)
      
      //let dataDict:[String: String] = ["date": "12/12/2020"]
      NotificationCenter.default.post(name: Notification.Name("SELECTED_DATE"), object: nil, userInfo: nil)
  
   }
   
   @objc func eDoneOnClick(){
      self.eDate.resignFirstResponder()
      self.eDate.endEditing(true)
      
      let format = DateFormatter()
      format.dateFormat = "dd MMM yyyy"
      eDate.text = format.string(from: datePicker.date)
      
      //let dataDict:[String: String] = ["date": "12/12/2020"]
      NotificationCenter.default.post(name: Notification.Name("SELECTED_DATE"), object: nil, userInfo: nil)
  
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
