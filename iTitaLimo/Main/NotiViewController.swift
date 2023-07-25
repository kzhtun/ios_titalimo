//
//  NotiViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 29/11/2020.
//

import UIKit

class NotiViewController: UIViewController {
   let App = UIApplication.shared.delegate as! AppDelegate
   let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("NotiViewController DidLoad")
    }
    

}
