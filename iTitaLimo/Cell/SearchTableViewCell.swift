//
//  SearchTableViewCell.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 28/10/2020.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
   let App = UIApplication.shared.delegate as! AppDelegate
   
    var searchFilter = SearchFilter.init(passenger: "", updates: "", sDate: "", eDate: "", sorting: "0")
    
    var activeTAB = 0
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBAction func PNameEditingDidEnd(_ sender: Any) {
            syncSearchParamsOnParentList()
    }
    
    @IBOutlet weak var searchUpdateViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchUpdateViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchUpdateView: UIStackView!
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
   
    @IBAction func btnSorting_ValueChanged(_ sender: Any) {
        var sortingInfo = [String: String]()
      
        sortingInfo["SortOrder"] = "\(sgSorting.selectedSegmentIndex)"
        
        NotificationCenter.default.post(name: Notification.Name("SORTING_CHANGED"), object: nil, userInfo: sortingInfo)
    }
    

    
//    func textFieldDidEndEditing(_ pName: UITextField) {
//        print("pName Lost Focus :" + (pName.text ?? "nil"))
//    }
//
//    func textFieldDidEndEditing(updates: UITextField) {
//        print("Updates Lost Focus :" + (pName.text ?? "nil"))
//    }
    
    
   @IBAction func eDateEditingDidEnd(_ sender: Any) {
      syncSearchParamsOnParentList()
   }
   
   @IBAction func sDateEditingDidEnd(_ sender: Any) {
      syncSearchParamsOnParentList()
   }
   
   @IBAction func pNameEditingDidEnd(_ sender: Any) {
      syncSearchParamsOnParentList()
   }
   
   public func configure(searchParam: SearchFilter, updateShow: Bool, jobCount: Int){
 
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
   
     
   
        sDate.text = searchParam.sDate
        eDate.text = searchParam.eDate
        pName.text = searchParam.passenger
        updates.text = searchParam.updates
        sgSorting.selectedSegmentIndex = Int(searchParam.sorting)!
    
       
       
//       // show in all tabs
//       self.searchUpdateView.isHidden = false
//       searchUpdateViewHeightConstraint.constant = 46
//       self.searchUpdateView.layoutIfNeeded()

       
       activeTAB = (updateShow) ? 3 : 2
       
       if(updateShow){
           // show update layout // Future Tab
           self.searchUpdateView.isHidden = false
           searchUpdateViewHeightConstraint.constant = 45
           searchUpdateViewTopConstraint.constant = 12
       }else{
           // hide update layout // History Tab
           self.searchUpdateView.isHidden = true
           searchUpdateViewHeightConstraint.constant = 0
           searchUpdateViewTopConstraint.constant = 0
           
          
       }
       
       layoutIfNeeded()
       lblJobCount.text = "TOTAL : \(jobCount) JOBS"
       
       
       initSDatePicker()
       initEDatePicker()
 
      
   }
   
   
   
   override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
      
       
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

        btnSearch.layer.cornerRadius = 14;
        btnSearch.layer.masksToBounds = true;
       
       btnClear.layer.cornerRadius = 14;
       btnClear.layer.masksToBounds = true;
      
      // self.btnSearch.backgroundColor = UIColor.init(hex: "#F69000AA")

      //containerView.isHidden = true
       
//       pName.delegate = self
//       updates.delegate = self
      
      
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
      
       // define max and min date
       let calendar = Calendar(identifier: .gregorian)
       var comps = DateComponents()
    
       if(activeTAB==2){
           comps.day = 2
           let minDate = calendar.date(byAdding: comps, to: Date())
           datePicker.minimumDate = minDate
       }
       
       if(activeTAB==3){
           comps.day = 0
           let maxDate = calendar.date(byAdding: comps, to: Date())
           datePicker.maximumDate = maxDate
       }
      
       
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
      
       // define max and min date
       let calendar = Calendar(identifier: .gregorian)
       var comps = DateComponents()
    
       if(activeTAB==2){
           comps.day = 2
           let minDate = calendar.date(byAdding: comps, to: Date())
           datePicker.minimumDate = minDate
       }
       
       if(activeTAB==3){
           comps.day = 0
           let maxDate = calendar.date(byAdding: comps, to: Date())
           datePicker.maximumDate = maxDate
       }
       
      datePicker.datePickerMode = .date
      datePicker.preferredDatePickerStyle = .wheels
      
      self.eDate.inputAccessoryView = toolbar
      self.eDate.inputView = datePicker
       
   }
   
    
    @IBAction func btnClearTouchDown(_ sender: Any) {
        var criteria = [String: String]()
        
        criteria["passenger"] = " "
        criteria["updates"] =  " "
        criteria["sDate"] = " "
        criteria["eDate"] = " "
        criteria["sorting"] = "0"
     
        NotificationCenter.default.post(name: Notification.Name("SEARCH_CLICKED"), object: nil, userInfo: criteria)
    }
    
   @IBAction func btnSearchOnClick(){
      
      var criteria = [String: String]()
      
      criteria["passenger"] = pName.text!.isEmpty ? " " : pName.text
      criteria["updates"] = updates.text!.isEmpty ? " " : updates.text
      criteria["sDate"] = sDate.text!.isEmpty ? " ": sDate.text
      criteria["eDate"] = eDate.text!.isEmpty ? " ": eDate.text
      criteria["sorting"] = "\(sgSorting.selectedSegmentIndex)"
   
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
       var criteria = [String: String]()
       
       criteria["passenger"] = pName.text!.isEmpty ? " " : pName.text
       criteria["updates"] = updates.text!.isEmpty ? " " : updates.text
       criteria["sDate"] = sDate.text!.isEmpty ? " ": sDate.text
       criteria["eDate"] = eDate.text!.isEmpty ? " ": eDate.text
       criteria["sorting"] = "\(sgSorting.selectedSegmentIndex)"
       
       NotificationCenter.default.post(name: Notification.Name("SYNC_SEARCH_PARAMS"), object: nil, userInfo: criteria)
       
       
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
