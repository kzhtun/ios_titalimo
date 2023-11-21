//
//  PatientHistoryViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 11/9/23.
//

import UIKit

class PatientHistoryViewController: UIViewController {
  
    let App = UIApplication.shared.delegate as! AppDelegate
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var patientList = [Patient]()

    var custCode : String = ""
    
   
    @IBOutlet weak var PatientTableView: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var sDate: UITextField!
    
    @IBOutlet weak var eDate: UITextField!
    
    @IBOutlet weak var sgSorting: UISegmentedControl!
    
    var patientSearchFilter = PatientSearchFilter.init(sDate: "", eDate: "", sorting: "1")
    
    @IBAction func sgSorting_ValueChanged(_ sender: Any) {
        patientSearchFilter.sorting = "\(sgSorting.selectedSegmentIndex)"
        
        callGetPatientHistory(custoCode: custCode,
                              from: patientSearchFilter.sDate,
                              to: patientSearchFilter.eDate,
                              sort: patientSearchFilter.sorting)
    }
    
    
    
    @IBAction func btnClear(_ sender: Any) {
        sDate.text = "";
        eDate.text = "";
        sgSorting.selectedSegmentIndex = 1
        
        patientSearchFilter.sDate = ""
        patientSearchFilter.eDate = ""
        patientSearchFilter.sorting = "1"
      
        callGetPatientHistory(custoCode: custCode,
                              from: patientSearchFilter.sDate,
                              to: patientSearchFilter.eDate,
                              sort: patientSearchFilter.sorting)
    }
    
    @IBAction func btnSearch_OnClick(_ sender: Any) {
        callGetPatientHistory(custoCode: custCode,
                              from: patientSearchFilter.sDate,
                              to: patientSearchFilter.eDate,
                              sort: patientSearchFilter.sorting)
    }
    
    func callGetPatientHistory(custoCode: String, from: String, to: String, sort: String){
       //jobList.removeAll()
        
        let from = (from.isEmpty) ? " " : from
        let to = (to.isEmpty) ? " " : to
       
        Router.sharedInstance().GetPatientHistory(custoCode: custoCode, from: from, to: to, sort: sort,
                                             success: { [self](successObj) in
                                              if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                  self.patientList = successObj.patients
                                                  self.PatientTableView.reloadData()
                                              }
                                             }, failure: { (failureObj) in
                                              self.view.makeToast(failureObj)
                                             })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //title.text = "Patient History"
        
        initSDatePicker()
        initEDatePicker()
        sgSorting.selectedSegmentIndex = 1
        
        btnSearch.layer.cornerRadius = 14;
        btnSearch.layer.masksToBounds = true;
        
        btnClear.layer.cornerRadius = 14;
        btnClear.layer.masksToBounds = true;
        
        searchView.layer.cornerRadius = 10
        searchView.layer.borderWidth = 1.0
        searchView.layer.borderColor = UIColor.init(hex: "#333333FF")?.cgColor
       
        
        PatientTableView.delegate = self
        PatientTableView.dataSource = self
        
        sDate.layer.cornerRadius = 15;
        sDate.layer.masksToBounds = true;
        sDate.setLeftPaddingPoints(8)

        eDate.layer.cornerRadius = 15;
        eDate.layer.masksToBounds = true;
        eDate.setLeftPaddingPoints(8)
      
        
        callGetPatientHistory(custoCode: custCode,
                              from: patientSearchFilter.sDate,
                              to: patientSearchFilter.eDate,
                              sort: patientSearchFilter.sorting)
   }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        App.recentlyClosedScreen = "PATIENT_HISTORY"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack_OnTouchInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        // clear recent screen
      
    }
    
    
    func initSDatePicker(){
       let toolbar = UIToolbar()
       toolbar.sizeToFit()
       
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.sDoneOnClick))
        toolbar.setItems([btnDone], animated: true)
       
        // define max and min date
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.day = 0
        let maxDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = maxDate
     
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
     
        comps.day = 0
        let maxDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = maxDate
        
       datePicker.datePickerMode = .date
       datePicker.preferredDatePickerStyle = .wheels
       
       self.eDate.inputAccessoryView = toolbar
       self.eDate.inputView = datePicker
        
    }
    
    
    @objc func sDoneOnClick(){
       self.sDate.resignFirstResponder()
       self.sDate.endEditing(true)
       
       let format = DateFormatter()
       format.dateFormat = "dd MMM yyyy"
       sDate.text = format.string(from: datePicker.date)
    
        patientSearchFilter.sDate = format.string(from: datePicker.date)
    }
    
  
    
    @objc func eDoneOnClick(){
       self.eDate.resignFirstResponder()
       self.eDate.endEditing(true)
       
       let format = DateFormatter()
       format.dateFormat = "dd MMM yyyy"
       eDate.text = format.string(from: datePicker.date)
        
        patientSearchFilter.eDate = format.string(from: datePicker.date)
       
    }
    
    
}


extension PatientHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
//           // print("this is the last cell")
//            let spinner = UIActivityIndicatorView(style: .medium)
//            spinner.startAnimating()
//            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//
//            self.PatientTableView.tableFooterView = spinner
//            self.PatientTableView.tableFooterView?.isHidden = false
//        }
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientTableViewCell") as! PatientTableViewCell
        
        let i = indexPath.row
        
        
        cell.configure(patient: patientList[indexPath.row])
        
        
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       if(patientList.count == 0){
          // no data
          let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.PatientTableView.bounds.size.width, height: self.PatientTableView.bounds.size.height))
          noDataLabel.text = "No Data Available"
          noDataLabel.textColor = UIColor(hex: "#555555FF")
          noDataLabel.textAlignment = NSTextAlignment.center
          tableView.backgroundView = noDataLabel
          
          return 1
          
       }else {
          tableView.backgroundView = nil
          return 1
       }
       
    }
    
    
}

