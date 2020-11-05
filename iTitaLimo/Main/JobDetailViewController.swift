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
   
   
   
   
   @IBAction func btnBack(_ sender: Any) {
      
      self.dismiss(animated: true)
   }
   
   override func viewWillAppear(_ animated: Bool) {
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
