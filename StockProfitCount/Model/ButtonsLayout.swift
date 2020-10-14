//
//  ButtonsLayout.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 14.10.2020.
//

import Foundation
import UIKit

class ButtonsLayout {
    
    
    func addButtonLayout(button: UIButton) {
      
        //shadow part start
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0,height: 4.0)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 5
        button.layer.cornerRadius = 10
        //shadow part end
        //**
        //button style start
        button.layer.backgroundColor = UIColor.systemBlue.cgColor
        button.tintColor = .white
        
    }
}



