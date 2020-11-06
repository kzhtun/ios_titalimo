//
//  JobDetailViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 04/11/2020.
//

import UIKit

class JobDetailViewController: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   
   var jobIndex: Int = -1
   var jobDetail = JobDetail()
   var phoneList = [String]()
   var jobNo: String = ""


   @IBOutlet weak var lblJobNo: UILabel!
   @IBOutlet weak var lblJobType: UILabel!
   @IBOutlet weak var lblJobStats: UILabel!
   @IBOutlet weak var lblJobDate: UILabel!
   @IBOutlet weak var lblJobTime: UILabel!
   @IBOutlet weak var lblPassenger: UILabel!
   @IBOutlet weak var lblFileNo: UILabel!
   @IBOutlet weak var lblAdult: UILabel!
   @IBOutlet weak var lblChild: UILabel!
   @IBOutlet weak var lblInfant: UILabel!
   @IBOutlet weak var lblFlightNo: UILabel!
   @IBOutlet weak var lblETA: UILabel!
   @IBOutlet weak var lblPickUp: UILabel!
   @IBOutlet weak var lblDropOff: UILabel!
   @IBOutlet weak var lblVehicleType: UILabel!
   @IBOutlet weak var lblRemark: UILabel!
   
   
   @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var phoneTableView: UITableView!
   
   @IBOutlet weak var detailView: UIView!
   
   @IBOutlet weak var btnNegative: UIButton!
   @IBOutlet weak var btnPositive: UIButton!
   
   @IBAction func btnBack(_ sender: Any) {
      self.dismiss(animated: true)
   }
   
   
   @IBAction func negativeOnClick(_ sender: Any) {
   }
   
   @IBAction func positiveOnClick(_ sender: Any) {
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      // UI Designer
      detailView.layer.cornerRadius = 10;
      detailView.layer.masksToBounds = true;
      detailView.layer.borderWidth = 1;
      detailView.layer.borderColor =  UIColor.init(hex: "#333333FF")?.cgColor
      
      btnNegative.layer.cornerRadius = 15;
      btnNegative.layer.masksToBounds = false;
      
      btnPositive.layer.cornerRadius = 15;
      btnPositive.layer.masksToBounds = false;
      
      
      
     // contentView.layer.backgroundColor = UIColor.init(hex: "#ffcb10ff")?.cgColor
      // edge Color
//      view.backgroundColor = UIColor.init(hex: "#000000ff")
//      // scrollable color
//      contentView.backgroundColor = UIColor.init(hex: "#ffcb10ff")
      
      jobNo =  App.recentJobList[jobIndex].JobNo
      
      displayJobDetail(job: App.recentJobList[jobIndex])
      
      
      
    
      
    //  callGetJobDetail(jobNo: jobNo)
   }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print("jobIndex \(jobIndex)")
      
      phoneTableView.delegate = self
      phoneTableView.dataSource = self
        
    }
   
   override func viewDidAppear(_ animated: Bool) {
      tableViewHeightConstraint.constant = phoneTableView.contentSize.height
   }
   
 
   func callGetJobDetail(jobNo: String){
      
      Router.sharedInstance().GetJobDetail(jobNo: jobNo ,
                                             success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   self.jobDetail = successObj.jobs[0]
                                                   //JobTableView.reloadData()
                                                   
                                                   //DispatchQueue.main.async { self.JobTableView.reloadData() }
                                                }
                                             }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                             })
   }
   
   
   func displayJobDetail(job: JobDetail){
     
      phoneList = job.Customer_Tel.components(separatedBy: "/")
      
      lblJobNo.text = job.JobNo
      lblJobStats.text = job.JobStatus
      lblJobDate.text = job.UsageDate
      lblJobTime.text = job.PickUpTime
      lblPassenger.text = job.Customer
      lblFileNo.text = job.FileNo
      lblAdult.text = job.NoofAdult
      lblChild.text = job.NoofChild
      lblInfant.text = job.NoofInfant
      lblFlightNo.text = job.Flight
      lblETA.text = job.ETA
      lblPickUp.text = job.PickUp
      lblDropOff.text = job.Destination
      lblVehicleType.text = job.VehicleType
      lblRemark.text = job.Remarks
      
   }
  
}


extension JobDetailViewController: UITableViewDelegate, UITableViewDataSource {

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.phoneList.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneTableViewCell") as! PhoneTableViewCell

     
      cell.configure(label: "MOBILE \(indexPath.row + 1)", mobile: phoneList[indexPath.row].trimmingCharacters(in: .whitespacesAndNewlines))
      
      return cell
   }


}
