//
//  UITableViewExtension.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 29/10/2020.
//


import UIKit

extension UITableView {
   func addTopBounceAreaView(color: UIColor = .white) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = color

        self.addSubview(view)
    }
}
