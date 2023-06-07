//
//  JobListViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 26/10/2020.
//

import UIKit

class JobListViewController: UIViewController {
   let notificationCenter = UNUserNotificationCenter.current()
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   var jobList = [JobDetail]()
   var todayJobs = [JobDetail]()
   var tomorrowJobs = [JobDetail]()
   
   var userInfo: [AnyHashable : Any]?
   var searchFilter = SearchFilter.init(passenger: "", updates: "", sDate: "", eDate: "", sorting: "0")
   
   var active = 0
   
   @IBOutlet weak var welcomeMsg: UILabel!
   @IBOutlet weak var btnToday: UIButton!
   @IBOutlet weak var btnTomorrow: UIButton!
   @IBOutlet weak var btnFuture: UIButton!
   @IBOutlet weak var btnHistory: UIButton!
   @IBOutlet weak var JobTableView: UITableView!
   
   @IBAction func btnExitOnClick(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
   
   @IBAction func btnBackOnClick(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
   
    @IBAction func btnAddOnClick(_ sender: UIButton) {
        let vc = UpdatesDialog()
        let index: Int = sender.tag
        
        vc.jobNo = jobList[index].JobNo
        vc.updates = jobList[index].Updates
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated:  true, completion: nil)
       
        //self.view.makeToast( vc.jobNo )
    }
   
    @IBAction func TodayOnClick(_ sender: Any) {
      active = 0
      
      buttonSelection()
      btnToday.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callJobsCount()
      callGetTodayJobs()
   }
   
   @IBAction func TomorrowOnClick(_ sender: Any) {
      active = 1
      buttonSelection()
      btnTomorrow.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callJobsCount()
      callGetTomorrowJobs()
   }
   
   @IBAction func FutureOnClick(_ sender: Any) {
      active = 2
      buttonSelection()
      btnFuture.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callJobsCount()
      callGetFutureJobs(from: " ", to: " ", passenger: " ", sort: "0")
   }
   
   @IBAction func HistoryOnClick(_ sender: Any) {
      active = 3
      buttonSelection()
      btnHistory.backgroundColor = UIColor.init(hex: "#333333FF")
      showSpinner()
      callGetHistoryJobs(from: " ", to: " ", passenger: " ", updates: " ", sort: "0")
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
      
      registerObservers()
      
      JobTableView.delegate = self
      JobTableView.dataSource = self
       
      //tableView.estimatedRowHeight = UITableView.automaticDimension
      
      // callGetTodayJobs()
      btnToday.sendActions(for: .touchDown)
      
      // call job count
      callJobsCount()
      
      
      // select recent state
      switch App.recentTab {
      case 0:
         btnToday.sendActions(for: .touchDown)
         break
      case 1:
         btnTomorrow.sendActions(for: .touchDown)
         break
      case 2:
         btnFuture.sendActions(for: .touchDown)
         break
      case 3:
         btnHistory.sendActions(for: .touchDown)
         break
      default:
         btnToday.sendActions(for: .touchDown)
      }
      
    
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      buttonSelection()
      
       
       
//       searchFilter.sDate = sDate
//       searchFilter.eDate = eDate
//       searchFilter.passenger = passenger
//       searchFilter.updates = updates
//       searchFilter.sorting = sorting
//
       
      
      self.JobTableView.estimatedSectionHeaderHeight = 1000
      self.JobTableView.sectionHeaderHeight = UITableView.automaticDimension
   }
  
   @objc func searchClicked(notification: NSNotification){
       userInfo = notification.userInfo
       
   //    RefreshJobList()
     
       guard   let sDate = userInfo?["sDate"] as? String,
             let eDate = userInfo?["eDate"] as? String,
             let passenger = userInfo?["passenger"] as? String,
             let updates = userInfo?["updates"] as? String,
             let sorting = userInfo?["sorting"] as? String
       else{
           return
       }


       searchFilter.sDate = sDate
       searchFilter.eDate = eDate
       searchFilter.passenger = passenger
       searchFilter.updates = updates
       searchFilter.sorting = sorting
       
       
      // future
      if(active == 2){
         callGetFutureJobs(from: sDate, to: eDate, passenger: passenger, sort: sorting)
      }

      // history
      if(active == 3){
          callGetHistoryJobs(from: sDate, to: eDate, passenger: passenger, updates: updates, sort: sorting)
      }

   }
   
   @objc func dateSelected(notification: NSNotification){
       userInfo = notification.userInfo
  
       guard   let sDate = userInfo?["sDate"] as? String,
             let eDate = userInfo?["eDate"] as? String,
             let passenger = userInfo?["passenger"] as? String,
             let updates = userInfo?["updates"] as? String,
             let sorting = userInfo?["sorting"] as? String
       else{
           return
       }

       searchFilter.sDate = sDate
       searchFilter.eDate = eDate
       searchFilter.passenger = passenger
       searchFilter.updates = updates
       searchFilter.sorting = sorting
       
      self.JobTableView.reloadData()
   }
   
   
   func callJobsCount(){
      Router.sharedInstance().GetJobsCount(success: { [self](successObj) in
         if(successObj.responsemessage.uppercased() == "SUCCESS"){
            let todayCount: String! = successObj.jobcountlist[0].todayjobcount
            let tmrCount: String! = successObj.jobcountlist[0].tomorrowjobcount
            let futureCount: String! = successObj.jobcountlist[0].futurejobcount
            
            let todayTitle: String! = "TODAY [ \(todayCount!) ]"
            let tmrTitle: String! = "TMR [ \(tmrCount!) ]"
            let futureTitle: String! = "FUTURE [ \(futureCount!) ]"
            
            var index = todayTitle.indexDistance(of: "[")
            var length = todayTitle.count - index!
            var att = NSMutableAttributedString(string: todayTitle);
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: index!, length: length))
            btnToday.setAttributedTitle(att, for: .normal)
            
            index = tmrTitle.indexDistance(of: "[")
            length = tmrTitle.count - index!
            att = NSMutableAttributedString(string: tmrTitle);
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: index!, length: length))
            btnTomorrow.setAttributedTitle(att, for: .normal)
            
            index = futureTitle.indexDistance(of: "[")
            length = futureTitle.count - index!
            att = NSMutableAttributedString(string: futureTitle);
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: index!, length: length))
            btnFuture.setAttributedTitle(att, for: .normal)
            
            //            let att = NSMutableAttributedString(string: "Hello!");
            //            att.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 0, length: 2))
            //            att.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 2, length: 2))
            //            button.setAttributedTitle(att, forState: .Normal)
            
            
          
            
         }
      }, failure: { (failureObj) in
         self.view.makeToast(failureObj)
      })
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
            App.recentJobList = jobList
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
                                                App.recentJobList = jobList
                                                 
                                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                     // your code here
                                                     self.JobTableView.reloadData()
                                                 }
                                             }
                                            }, failure: { (failureObj) in
                                             self.view.makeToast(failureObj)
                                            })
   }
   
   
   func callGetHistoryJobs(from: String, to: String, passenger: String, updates: String, sort: String){
      jobList.removeAll()
      
       Router.sharedInstance().GetHistoryJobs(from: from, to: to, passenger: passenger, updates: updates, sort: sort,
                                             success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   self.jobList = successObj.jobs
                                                   App.recentJobList = jobList
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                        // your code here
                                                        self.JobTableView.reloadData()
                                                    }
                                                    
                                                   
                                                }else{
                                                    print("error")
                                                }
                                             }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                             })
       
       
   }
   
   
   func showSpinner(){
      jobList.removeAll()
      JobTableView.reloadData()
      
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width:  self.JobTableView.bounds.width, height: CGFloat(44))
      
      self.JobTableView.backgroundView = spinner
      
   }
    
//    func initSearchFilter(userInfo: [AnyHashable : Any]){
//        if(userInfo["sDate"] == nil){
//           searchFilter.sDate = ""
//        }else{
//            searchFilter.sDate = userInfo["sDate"] as! String
//        }
//
//        if(userInfo["eDate"] == nil){
//           searchFilter.eDate = ""
//        }else{
//            searchFilter.eDate = userInfo["eDate"] as! String
//        }
//
//          if(userInfo["updates"] == nil){
//            searchFilter.updates = ""
//          }else{
//              searchFilter.updates = userInfo["updates"] as! String
//          }
//
//        if(userInfo["passenger"] == nil){
//           searchFilter.passenger = ""
//        }else{
//            searchFilter.passenger = userInfo["passenger"] as! String
//        }
//
//        if(userInfo["sorting"] == nil){
//           searchFilter.sorting = "0"
//        }else{
//            searchFilter.sorting = userInfo["sorting"] as! String
//        }
//    }
}


extension JobListViewController: UITableViewDelegate, UITableViewDataSource{
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
     
      
    //   initSearchFilter()
     
      cell.configure(searchParam: searchFilter, sortingShowHide: (active==2), jobCount: jobList.count)
     
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       // check the selected tab is Future or History
       if (active == 0 || active == 1){
           return 0.0
       }else{
           return 290
       }
   }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
      
       
     //  self.view.makeToast(jobList[i].JobNo);
       
       cell.configure(tab: active,
                     jobDate : jobList[i].UsageDate,
                     jobType : jobList[i].JobType,
                     jobStatus : jobList[i].JobStatus,
                     vehicleType : jobList[i].VehicleType,
                     jobTime : jobList[i].PickUpTime,
                     pickup : jobList[i].PickUp,
                     dropoff : jobList[i].Destination,
                     passenger : jobList[i].Customer,
                     mobile : jobList[i].Customer_Tel,
                     updates: jobList[i].Updates,
                     staff: jobList[i].Staff,
                     index: i
      )
       
       tableView.estimatedRowHeight = UITableView.automaticDimension
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print(indexPath.row)
      
      let vc = self.storyBoard.instantiateViewController(withIdentifier: "JobDetailViewController") as! JobDetailViewController
      
      App.recentTab = active
      vc.modalPresentationStyle = .fullScreen
      vc.jobIndex = indexPath.row
      
      self.present(vc, animated: true, completion: nil)
   }
   
   
//   //Mark: location notification events
//   func urgentJobConfirm(msg: String) {
//
//      let content = UNMutableNotificationContent()
//      let categoryIdentifire = "Delete Notification Type"
//
//      content.title = "Urgent"
//      content.body = msg
//      content.sound = UNNotificationSound.default
//      content.badge = 1
//      content.categoryIdentifier = categoryIdentifire
//
//      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//      let identifier = "CONFIRM"
//      let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//      notificationCenter.add(request) { (error) in
//         if let error = error {
//            print("Error \(error.localizedDescription)")
//         }
//      }
//
//      // notificationCenter.setNotificationCategories([category])
//   }
   
   //
   //   @objc func confirmClicked(notification: NSNotification){
   //      guard let jobNo = notification.userInfo!["jobNo"] as? String,
   //            let  name = notification.userInfo!["Name"] as? String,
   //            let  phone = notification.userInfo!["phone"] as? String,
   //            let  displayMsg = notification.userInfo!["displayMsg"] as? String
   //      else{return}
   //
   //      callConfirmJobReminder(jobNo: jobNo)
   //
   //   }
   
}



extension JobListViewController{
   func registerObservers(){
      
      NotificationCenter.default.addObserver(self, selector: #selector(AcceptSuccessful), name: NSNotification.Name(rawValue: "ACCEPT_SUCCESSFUL"), object: nil)
      
      // refresh job list when noti receive
      NotificationCenter.default.addObserver(self, selector: #selector(RefreshJobList), name: NSNotification.Name(rawValue: "REFRESH_JOBS"), object: nil)
      
      NotificationCenter.default.addObserver(self, selector: #selector(dateSelected), name: NSNotification.Name(rawValue: "SYNC_SEARCH_PARAMS"), object: nil)
      
      NotificationCenter.default.addObserver(self, selector: #selector(searchClicked), name: NSNotification.Name(rawValue: "SEARCH_CLICKED"), object: nil)
       
       print("registerObservers")
      
   }
   
   @objc func RefreshJobList(){
       
//       guard  let sDate = userInfo?["sDate"] as? String,
//             let  eDate = userInfo?["eDate"] as? String,
//             let  passenger = userInfo?["passenger"] as? String,
//             let   updates = userInfo?["updates"] as? String,
//             let  sorting = userInfo?["sorting"] as? String
//       else{
//           return
//       }
//
//
//
//
////       searchParams.sDate =   sDate
////       searchParams.eDate =   eDate
////       searchParams.passenger =   passenger
////       searchParams.updates =   criteria["updates"]!
////       searchParams.sorting =   criteria["sorting"]!
  
       searchFilter
       
         
      // job count refresh
      callJobsCount()
       
      if(active==0){
         callGetTodayJobs()
      }
      
      if(active==1){
         callGetTomorrowJobs()
      }
       
       // future
       if(active == 2){
          callGetFutureJobs(from:  searchFilter.sDate, to:  searchFilter.eDate, passenger:  searchFilter.passenger, sort:  searchFilter.sorting)
       }
       
       // history
       if(active == 3){
           callGetHistoryJobs(from:  searchFilter.sDate, to:  searchFilter.eDate, passenger:  searchFilter.passenger, updates: searchFilter.updates, sort:  searchFilter.sorting)
       }
    
//       // future
//       if(active == 2){
//          callGetFutureJobs(from: sDate, to: eDate, passenger: passenger, sort: sorting)
//       }
//
//       // history
//       if(active == 3){
//           callGetHistoryJobs(from: sDate, to: eDate, passenger: passenger, updates: updates, sort: sorting)
//       }
     
   }
   
   @objc func AcceptSuccessful(notification: NSNotification){
      guard let jobNo = notification.userInfo!["jobno"] as? String
      else{return}
      
      callUpdateJobStatus(jobNo: jobNo, status: "Confirm")
   }
   
   func callUpdateJobStatus(jobNo: String, status: String){
      Router.sharedInstance().UpdateJobStatus(jobNo: jobNo, address: App.fullAddress, status: status,
                                              success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   RefreshJobList()
                                                }
                                              }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                              })
   }
    
    
   
}
