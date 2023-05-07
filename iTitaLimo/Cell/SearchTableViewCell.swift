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
   
  
    @IBOutlet weak var updates: UITextField!
    @IBOutlet weak var pName: UITextField!
   @IBOutlet weak var sDate: UITextField!
   @IBOutlet weak var eDate: UITextField!
   
   @IBOutlet weak var lblTimeSorting: UILabel!
   @IBOutlet weak var sgSorting: UISegmentedControl!
   @IBOutlet weak var lblJobCount: UILabel!
   
   @IBOutlet weak var headerHeightConstraints: NSLayoutConstraint!
   
   let datePicker = UIDatePicker()
   
   var searchAction: ((_ name: String)-> Void)? = nil
   
   var callBack: ((_ name: String)-> Void)? = nil
   
   
   static func nib()-> UINib{
      return UINib(nibName: "SearchTableViewCell", bundle: nil)
   }
   
   @IBAction func eDateEditingDidEnd(_ sender: Any) {
      syncSearchParamsOnParentList()
   }
   
   @IBAction func sDateEditingDidEnd(_ sender: Any) {
      syncSearchParamsOnParentList()
   }
   
   @IBAction func pNameEditingDidEnd(_ sender: Any) {
      syncSearchParamsOnParentList()
   }
   
   public func configure(searchParam: SearchFilter, sortingShowHide: Bool, jobCount: Int){
 
      let image1 =  UIImageView(image: UIImage(named: "ic_cal"))
      image1.frame = CGRect(x: 8, y: 8, width: 16, height: 16)
      
      let image2 =  UIImageView(image: UIImage(named: "ic_cal"))
      image2.frame = CGRect(x: 8, y: 8, width: 16, height: 16)
      
      sDate.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
      sDate.rightView?.addSubview(image1)
      sDate.rightViewMode = .always
      
      eDate.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
      eDate.rightView?.addSubview(image2)
      eDate.rightViewMode = .always
     
      sgSorting.selectedSegmentIndex = Int(searchParam.sorting)!
     
//      pName.text = searchParam.passenger
//      sDate.text = searchParam.sDate
//      eDate.text = searchParam.eDate
      
      if(sortingShowHide){
         lblTimeSorting.isHidden = true
         sgSorting.isHidden = true
      }
      
      lblJobCount.text = "TOTAL : \(jobCount) Jobs"
      
   }
   
   
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      
    
      
          initSDatePicker()
          initEDatePicker()
      
       
        updates.layer.cornerRadius = 15;
        updates.layer.masksToBounds = true;
        updates.setLeftPaddingPoints(8)

        pName.layer.cornerRadius = 15;
        pName.layer.masksToBounds = true;
        pName.setLeftPaddingPoints(8)

        sDate.layer.cornerRadius = 15;
        sDate.layer.masksToBounds = true;
        sDate.setLeftPaddingPoints(8)

        eDate.layer.cornerRadius = 15;
        eDate.layer.masksToBounds = true;
        eDate.setLeftPaddingPoints(8)

        btnSearch.layer.cornerRadius = 13;
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
      
      criteria["passenger"] = pName.text!.isEmpty ? " " : pName.text
       criteria["updates"] = updates.text!.isEmpty ? " " : updates.text
      criteria["sDate"] = sDate.text!.isEmpty ? " ": sDate.text
      criteria["eDate"] = eDate.text!.isEmpty ? " ": eDate.text
      criteria["sorting"] = "\(sgSorting.selectedSegmentIndex)"
      
      
      print("search clicked")
       
      NotificationCenter.default.post(name: Notification.Name("SEARCH_CLICKED"), object: nil, userInfo: criteria)
   }
   
   @objc func sDoneOnClick(){
      self.sDate.resignFirstResponder()
      self.sDate.endEditing(true)
      
      let format = DateFormatter()
      format.dateFormat = "dd MMM yyyy"
      sDate.text = format.string(from: datePicker.date)
      
      //let dataDict:[String: String] = ["date": "12/12/2020"]
      syncSearchParamsOnParentList()
   }
   
   func syncSearchParamsOnParentList(){
      NotificationCenter.default.post(name: Notification.Name("SYNC_SEARCH_PARAMS"), object: nil, userInfo: nil)
   }
   
   @objc func eDoneOnClick(){
      self.eDate.resignFirstResponder()
      self.eDate.endEditing(true)
      
      let format = DateFormatter()
      format.dateFormat = "dd MMM yyyy"
      eDate.text = format.string(from: datePicker.date)
      
      //let dataDict:[String: String] = ["date": "12/12/2020"]
      syncSearchParamsOnParentList()
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
