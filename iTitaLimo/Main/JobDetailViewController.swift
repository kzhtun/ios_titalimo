//
//  JobDetailViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 04/11/2020.
//

import UIKit
import MapKit
import CoreLocation

class JobDetailViewController: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   let locationManager = CLLocationManager()
   
   var jobIndex: Int = -1
   var jobDetail = JobDetail()
   var phoneList = [String]()
   var jobNo: String = ""
   
   
   @IBOutlet weak var welcomeMsg: UILabel!
   
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
   
   func setActionButtonByStatus(){
      btnNegative.isEnabled = true
      btnPositive.isEnabled = true
      
      btnNegative.backgroundColor = UIColor(hex: App.ButtonRed)
      btnPositive.backgroundColor = UIColor(hex: App.ButtonGreen)
      
      switch jobDetail.JobStatus.uppercased(){
         case "JOB ASSIGNED":
            btnNegative.setTitle("REJECT", for: .normal)
            btnPositive.setTitle("ACCEPT", for: .normal)
            break
            
         case "CONFIRM":
            btnNegative.isEnabled = false
            btnNegative.setTitle("", for: .normal)
            btnNegative.backgroundColor = UIColor(hex: "#00000000")
            btnPositive.setTitle("ON THE WAY", for: .normal)
            break
            
         case "ON THE WAY":
            btnNegative.setTitle("BACK", for: .normal)
            btnPositive.setTitle("ON SITE", for: .normal)
            break
            
         case "ON SITE":
            btnNegative.setTitle("BACK", for: .normal)
            btnPositive.setTitle("POB", for: .normal)
            break
            
         case "PASSENGER ON BOARD", "PASSENGER NO SHOW":
            btnNegative.setTitle("BACK", for: .normal)
            btnPositive.setTitle("COMPLETE", for: .normal)
            break
           
         case "COMPLETED":
            btnNegative.isEnabled = false
            btnNegative.setTitle("", for: .normal)
            btnNegative.backgroundColor = UIColor(hex: "#00000000")
            btnPositive.setTitle("DISMISS", for: .normal)
            break
         default:
            print("Default")
      }
   }
   
   
   
   @IBAction func negativeOnClick(_ sender: Any) {
      switch jobDetail.JobStatus.uppercased(){
         
         case "JOB ASSIGNED":
            callUpdateJobStatus(jobNo: jobNo, status: "Rejected")
            callUpdateDriverLocation()
            break
            
         case "ON THE WAY":
            callUpdateJobStatus(jobNo: jobNo, status: "Confirm")
            break
            
         case "ON SITE":
            callUpdateJobStatus(jobNo: jobNo, status: "On The Way")
            break
            
         case "PASSENGER ON BOARD", "PASSENGER NO SHOW":
            callUpdateJobStatus(jobNo: jobNo, status: "On Site")
            break
            
         default:
            print("Default")
      }
   }
   
   @IBAction func positiveOnClick(_ sender: Any) {
      switch jobDetail.JobStatus.uppercased(){
         
         case "JOB ASSIGNED", "JOB NEW":
            callUpdateJobStatus(jobNo: jobNo, status: "Confirm")
            callUpdateDriverLocation()
            break
            
         case "CONFIRM":
            callUpdateJobStatus(jobNo: jobNo, status: "On The Way")
            break
            
         case "ON THE WAY":
            callUpdateJobStatus(jobNo: jobNo, status: "On Site")
            break
            
         case "ON SITE":
            let vc = ActionDialog()
            vc.jobNo = jobNo
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated:  true, completion: nil)
            break
            
         case "PASSENGER ON BOARD", "PASSENGER NO SHOW":
            let vc = CompleteDialog()
            vc.jobNo = jobNo
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated:  true, completion: nil)
            break
            
         case "COMPLETED":
            self.dismiss(animated: true, completion: nil)
            break
         default:
            print("Default")
      }
      
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      welcomeMsg.text = "Welcome \(App.DRIVER_NAME)"
      
      // UI Designer
      detailView.layer.cornerRadius = 10;
      detailView.layer.masksToBounds = true;
      detailView.layer.borderWidth = 1;
      detailView.layer.borderColor =  UIColor.init(hex: "#333333FF")?.cgColor
      
      btnNegative.layer.cornerRadius = 20;
      btnNegative.layer.masksToBounds = false;
      
      btnPositive.layer.cornerRadius = 20;
      btnPositive.layer.masksToBounds = false;
      
      jobNo =  App.recentJobList[jobIndex].JobNo
      
//      if(App.recentTab == 2 || App.recentTab == 3){
//         jobIndex = jobIndex - 1
//      }
      
      jobDetail = App.recentJobList[jobIndex]
      displayJobDetail(job: jobDetail)
      
      registerObservers()
      
      
      let pickUpGesture = UITapGestureRecognizer(target: self, action: #selector(pickUpOnClick))
      let dropOffGesture = UITapGestureRecognizer(target: self, action: #selector(dropOffOnClick))
     
      lblPickUp.isUserInteractionEnabled = true
      lblPickUp.addGestureRecognizer(pickUpGesture)
      
      lblDropOff.isUserInteractionEnabled = true
      lblDropOff.addGestureRecognizer(dropOffGesture)
   }
   
   @objc func pickUpOnClick() {
      locationOnClick(address: lblPickUp.text!)
   }
   
   @objc func dropOffOnClick() {
      locationOnClick(address: lblDropOff.text!)
   }
   
   func locationOnClick(address: String) {
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
      alert.view.superview?.backgroundColor = UIColor.init(hex: "#33333355")
         
      alert.addAction(UIAlertAction(title: "Google Map", style: .default) { _ in
         var routeString = "comgooglemaps-x-callback://?"
         routeString += "&saddr=" //\(self.App.lat), \(self.App.lng)
         routeString += "&daddr=\(address)"
         routeString += "&directionsmode=driving"
     
         if(UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)){
            
            if let encoded = routeString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let myURL = URL(string: encoded) {
               UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
                }
         }else{
            self.view.makeToast("Google map app not found.")
         }
      })

      alert.addAction(UIAlertAction(title: "Waze", style: .default) { _ in
         var routeString = "waze://?"
       //  routeString += "&ll=\(self.App.lat), \(self.App.lng)"
         routeString += "&q=\(address)"
         routeString += "&navigate=yes"
     
         if(UIApplication.shared.canOpenURL(URL(string: "waze://")!)){
            if let encoded = routeString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                    let myURL = URL(string: encoded) {
               UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
                }
         }else{
            self.view.makeToast("Waze app not found.")
         }
      })
      
      alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
         print("Action 2")
      })

      present(alert, animated: true)
   }
   
   
   
   @objc
   public func newMessageArrived(){
      self.view.makeToast("You have new message")
   }
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      print("jobIndex \(jobIndex)")
      
      phoneTableView.delegate = self
      phoneTableView.dataSource = self
      
      initLocationManager()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      tableViewHeightConstraint.constant = phoneTableView.contentSize.height
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
      
      setActionButtonByStatus()
   }
   
   
   //MARK: API Calls
   func callUpdateDriverLocation(){
      Router.sharedInstance().UpdateDriverLocation(latitude: "\(App.lat)" , longitude: "\(App.lng)", gpsStatus: "nil", address: App.fullAddress, success: { [self](successObj) in
         if(successObj.responsemessage.uppercased() == "SUCCESS"){
            self.view.makeToast("Update driver location success.")
//            DispatchQueue.main.async{
//               callGetJobDetail(jobNo: jobNo)
//            }
         }
       }, failure: { (failureObj) in
         self.view.makeToast(failureObj)
       })
   }
   
   func callUpdateJobStatus(jobNo: String, status: String){
      Router.sharedInstance().UpdateJobStatus(jobNo: jobNo, address: App.fullAddress, status: status,
                                              success: { [self](successObj) in
                                                if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                   DispatchQueue.main.async{
                                                      callGetJobDetail(jobNo: jobNo)
                                                   }
                                                }
                                              }, failure: { (failureObj) in
                                                self.view.makeToast(failureObj)
                                              })
   }
   
   func callGetJobDetail(jobNo: String){
      Router.sharedInstance().GetJobDetail(jobNo: jobNo ,
                                           success: { [self](successObj) in
                                             if(successObj.responsemessage.uppercased() == "SUCCESS"){
                                                self.jobDetail = successObj.jobdetails
                                                displayJobDetail(job:  self.jobDetail)
                                             }
                                           }, failure: { (failureObj) in
                                             self.view.makeToast(failureObj)
                                           })
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


extension JobDetailViewController: CLLocationManagerDelegate{
   
   func initLocationManager(){
      locationManager.requestAlwaysAuthorization()
      locationManager.requestWhenInUseAuthorization()
      if CLLocationManager.locationServicesEnabled() {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
         locationManager.startUpdatingLocation()
      }
   }
   
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
      print("locations = \(locValue.latitude) \(locValue.longitude)")
      
      App.lat = locValue.latitude
      App.lng = locValue.longitude
      
      getAddressFromLatLon(pdblLatitude: String(locValue.latitude), pdblLongitude:  String(locValue.longitude))
   }
   
   
   func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) {
      var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
      let lat: Double = Double("\(pdblLatitude)")!
      //21.228124
      let lon: Double = Double("\(pdblLongitude)")!
      //72.833770
      let ceo: CLGeocoder = CLGeocoder()
      center.latitude = lat
      center.longitude = lon
      
      let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
      
    
      
      ceo.reverseGeocodeLocation(loc, completionHandler:
                                    { [self](placemarks, error) in
                                       if (error != nil)
                                       {
                                          print("reverse geodcode fail: \(error!.localizedDescription)")
                                       }
                                       
                                       let pm = placemarks! as [CLPlacemark]
                                       
                                       if pm.count > 0 {
                                          let pm = placemarks![0]
                                          //                       print(pm.country)
                                          //                       print(pm.locality)
                                          //                       print(pm.subLocality)
                                          //                       print(pm.thoroughfare)
                                          //                       print(pm.postalCode)
                                          //                       print(pm.subThoroughfare)
                                          
                                          var addressString : String = ""
                                          if pm.subLocality != nil {
                                             addressString = addressString + pm.subLocality! + ", "
                                          }
                                          if pm.thoroughfare != nil {
                                             addressString = addressString + pm.thoroughfare! + ", "
                                          }
                                          if pm.locality != nil {
                                             addressString = addressString + pm.locality! + ", "
                                          }
                                          if pm.country != nil {
                                             addressString = addressString + pm.country! + ", "
                                          }
                                          if pm.postalCode != nil {
                                             addressString = addressString + pm.postalCode! + " "
                                          }
                                          
                                          print(addressString)
                                          
                                          //App.fullAddress = "Union Square#.# Stockton St#.# San Francisco"
                                         App.fullAddress = addressString.replaceEscapeChr
                                             
//                                             addressString.replacingOccurrences(of: ",", with: "#.#")
                                       }
                                    })
      
   }
}

extension JobDetailViewController{
   func registerObservers(){
      // update job detail info when noti receive
      NotificationCenter.default.addObserver(self, selector: #selector(updateJobDetail), name: NSNotification.Name(rawValue: "REFRESH_JOBS"), object: nil)
      
      NotificationCenter.default.addObserver(self, selector: #selector(updateJobDetailSilent), name: NSNotification.Name(rawValue: "SILENT_REFRESH_JOBS"), object: nil)
   }
   
   
   @objc func updateJobDetailSilent(notification: NSNotification){
      let userInfo: [AnyHashable: Any]? = notification.userInfo
      
      guard let jobNo = userInfo!["jobno"] as? String
      else{return}
      callGetJobDetail(jobNo: jobNo)
   }
   
   @objc func updateJobDetail(notification: NSNotification){
      let userInfo: [AnyHashable: Any]? = notification.userInfo
      
      guard let jobNo = userInfo!["jobno"] as? String
      else{return}
      
      let refreshAlert = UIAlertController(title: "Refresh", message: "Details for this job may have changed.\nClick OK to refresh.", preferredStyle: UIAlertController.Style.alert)
      
      refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
         self.callGetJobDetail(jobNo: jobNo)
         
      }))
      
      refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
         
      }))
      
      present(refreshAlert, animated: true, completion: nil)
      
   }
}
