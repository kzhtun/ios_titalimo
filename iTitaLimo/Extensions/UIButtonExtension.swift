//
//  UIButtonExtension.swift
//  iTitaLimo
//
//  Created by Kyaw Zin Htun on 29/10/2020.
//


import UIKit

extension UIButton{
   func setTopCornerRounded(value: Int){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: value, height: value))
      
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
