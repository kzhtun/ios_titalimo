//
//  JobListViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 26/10/2020.
//

import UIKit

class JobListViewController: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   var jobList = [JobDetail]()
   var todayJobs = [JobDetail]()
   var tomorrowJobs = [JobDetail]()
   
   var active = 0
   
   @IBOutlet weak var welcomeMsg: UILabel!
   
   @IBOutlet weak var btnToday: UIButton!
   @IBOutlet weak var btnTomorrow: UIButton!
   @IBOutlet weak var btnFuture: UIButton!
   @IBOutlet weak var btnHistory: UIButton!
   
   
   @IBOutlet weak var JobTableView: UITableView!
   
   
   @IBAction func TodayOnClick(_ sender: Any) {
      active = 0
      buttonSelection()
      btnToday.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callGetTodayJobs()
   }
   
   @IBAction func TomorrowOnClick(_ sender: Any) {
      active = 1
      buttonSelection()
      btnTomorrow.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callGetTomorrowJobs()
      
   }
   
   @IBAction func FutureOnClick(_ sender: Any) {
      active = 2
      buttonSelection()
      btnFuture.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callGetFutureJobs(from: " ", to: " ", passenger: " ", sort: "0")
   }
   
   @IBAction func HistoryOnClick(_ sender: Any) {
      active = 3
      buttonSelection()
      btnHistory.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callGetHistoryJobs(from: " ", to: " ", passenger: " ", sort: "0")
   }
   
   
   func buttonSelection(){
      btnToday.backgroundColor = UIColor.init(hex: "#000000FF")
      btnTomorrow.backgroundColor = UIColor.init(hex: "#000000FF")
      btnFuture.backgroundColor = UIColor.init(hex: "#000000FF")
      btnHistory.backgroundColor = UIColor.init(hex: "#000000FF")
      
      btnToday.setTitleColor(UIColor(hex: active==0 ? "#1996FCFF" : "#AAAAAAFF"), for: .normal)
      btnTomorrow.setTitleColor(UIColor(hex: active==1 ? "#1996FCFF" : "#AAAAAAFF"), for: .normal)
      btnFuture.setTitleColor(UIColor(hex: active==2 ? "#1996FCFF" : "#AAAAAAFF"), for: .normal)
      btnHistory.setTitleColor(UIColor(hex: active==3 ? "#1996FCFF" : "#AAAAAAFF"), for: .normal)
   }
   
   
   
   override func viewWillAppear(_ animated: Bool) {
      welcomeMsg.text = "Welcome \(App.DRIVER_NAME)"
      
      JobTableView.delegate = self
      JobTableView.dataSource = self
      
      // callGetTodayJobs()
      
      btnToday.sendActions(for: .touchDown)
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      buttonSelection()
      
      self.JobTableView.sectionHeaderHeight = UITableView.automaticDimension
      self.JobTableView.estimatedSectionHeaderHeight = 25
      
      NotificationCenter.default.addObserver(self, selector: #selector(dateSelected), name: NSNotification.Name(rawValue: "SELECTED_DATE"), object: nil)
      
      NotificationCenter.default.addObserver(self, selector: #selector(searchClicked), name: NSNotification.Name(rawValue: "SEARCH_CLICKED"), object: nil)
      
//      NotificationCenter.default.addObserver(self, selector: #selector(jobSelected), name: NSNotification.Name(rawValue: "JOB_SELECTED"), object: nil)
      
   }
   
   @objc func jobSelected(){
      
   }
   
   @objc func searchClicked(notification: NSNotification){
      let userInfo: [String:String] = notification.userInfo as! [String:String]
      
      
      
      // future
      if(active == 2){
         callGetFutureJobs(from: userInfo["sDate"]!, to: userInfo["eDate"]!, passenger: userInfo["passenger"]!, sort: userInfo["sorting"]!)
      }
      
      // history
      if(active == 3){
         callGetHistoryJobs(from: userInfo["sDate"]!, to: userInfo["eDate"]!, passenger: userInfo["passenger"]!, sort: userInfo["sorting"]!)
      }
      
   }
   
   @objc func dateSelected(){
      print("Date is selected")
      self.JobTableView.reloadData()
   }
   
   
   func callGetTodayJobs(){
      jobList.removeAll()
      
      Router.sharedInstance().GetTodayJobs(success: { [self](successObj) in
         if(successObj.responsemessage.uppercased() == "SUCCESS"){
            self.jobList = successObj.jobs
            JobTableView.reloadData()
            App.recentJobList = jobList
         }
      }, failure: { (failureObj) in
         self.view.makeToast(failureObj)
      })
   }
   
   func callGetTomorrowJobs(){
      jobList.removeAll()
      
      Router.sharedInstance().GetTomorrowJobs(success: { [self](successObj) in
         if(successObj.responsemessage.uppercased() == "SUCCESS"){
            self.jobList = successObj.jobs
            JobTableView.reloadData()
         }
      }, failure: { (failureObj) in
         self.view.makeToast(failureObj)
      })
   }
   
   func callGetFutureJobs(from: String, to: String, passenger: String, sort: String){
      jobList.removeAll()
      
      Router.sharedInstance().GetFutureJobs(from: from, to: to, passenger: passenger, sort: sort,
                                             success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   self.jobList = successObj.jobs
                                                 
                                                   DispatchQueue.main.async { self.JobTableView.reloadData() }
                                                }
                                             }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                             })
   }
   
   
   func callGetHistoryJobs(from: String, to: String, passenger: String, sort: String){
      jobList.removeAll()
      
      Router.sharedInstance().GetHistoryJobs(from: from, to: to, passenger: passenger, sort: sort,
                                             success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   self.jobList = successObj.jobs
                                                
                                                   DispatchQueue.main.async { self.JobTableView.reloadData() }
                                                }
                                             }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                             })
   }
   
   
   func showSpinner(){
      jobList.removeAll()
      JobTableView.reloadData()
      
      let spinner = UIActivityIndicatorView(style: .white)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width:  self.JobTableView.bounds.width, height: CGFloat(44))
      
      self.JobTableView.backgroundView = spinner
      
   }
}


extension JobListViewController: UITableViewDelegate, UITableViewDataSource{
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      if (active == 0 || active == 1) {
         return 0.0
      }
      return UITableView.automaticDimension
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      if(jobList.count == 0){
         // no data
         let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.JobTableView.bounds.size.width, height: self.JobTableView.bounds.size.height))
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
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return jobList.count;
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell") as! JobTableViewCell
      
      let i = indexPath.row
      
      
      cell.configure(jobDate : jobList[i].UsageDate,
                     jobType : jobList[i].JobType,
                     jobStatus : jobList[i].JobStatus,
                     vehicleType : jobList[i].VehicleType,
                     jobTime : jobList[i].PickUpTime,
                     pickup : jobList[i].PickUp,
                     dropoff : jobList[i].Destination,
                     passenger : jobList[i].Customer,
                     mobile : jobList[i].Customer_Tel
      )
      
      return cell
   }
   
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath.row)
      
      let vc = self.storyBoard.instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
      
      vc.modalPresentationStyle = .fullScreen
      vc.jobIndex = indexPath.row
      
      self.present(vc, animated: true, completion: nil)
   }
   
}
