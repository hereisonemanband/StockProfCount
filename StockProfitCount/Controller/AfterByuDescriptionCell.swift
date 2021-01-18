//
//  DealDescriptionCell.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 23.11.2020.
//

import UIKit


class AfterByuDescriptionCell: UITableViewCell {

    
    @IBOutlet weak var currentRUBUSDPrice: UILabel!
    @IBOutlet weak var currentSumm: UILabel!
    @IBOutlet weak var afterBuyPaperCompanyName: UILabel!
    @IBOutlet weak var storedQuantityLabelText: UITextField!
    @IBOutlet weak var currentPaperStockPrice: UILabel!
    
    var delegate: StoredPaperVC?
    var paperManager = PaperManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    @IBAction func quantityDidChanged(_ sender: UITextField) {
        
        
//        if sender.text!.count > 0 {
//            summLabel.text = "\(Double(paperStockPrice.text!)! * Double(sender.text!)!)"
//        }

    }
    
    
}

