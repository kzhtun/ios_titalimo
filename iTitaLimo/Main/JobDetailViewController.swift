//
//  JobDetailViewController.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 04/11/2020.
//

import UIKit
import ScrollingContentViewController


class JobDetailViewController: ScrollingContentViewController {
    var jobIndex: Int = -1

   
   override func viewWillAppear(_ animated: Bool) {
     // contentView.layer.backgroundColor = UIColor.init(hex: "#ffcb10ff")?.cgColor
      // edge Color
//      view.backgroundColor = UIColor.init(hex: "#000000ff")
//      // scrollable color
//      contentView.backgroundColor = UIColor.init(hex: "#ffcb10ff")
   }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        print("jobIndex \(jobIndex)")
    }
  
}
