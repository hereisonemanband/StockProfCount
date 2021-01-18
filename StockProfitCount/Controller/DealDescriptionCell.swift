//
//  DealDescriptionCell.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 23.11.2020.
//

import UIKit


protocol getTextFieldValueDelegate {
    func textFieldChanged(cell: DealDescriptionCell, string: String)
}

class DealDescriptionCell: UITableViewCell {

    @IBOutlet weak var paperCompanyNameLabel: UILabel!
    @IBOutlet weak var dollarPriceinBuyMoment: UILabel!
    @IBOutlet weak var summLabel: UILabel!
    @IBOutlet weak var paperStockPrice: UILabel!
    @IBOutlet weak var paperStockCount: UITextField!
    @IBOutlet weak var quantityLabelText: UITextField!

    var delegate: DealDescriptionsVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    

    @IBAction func quantityDidChanged(_ sender: UITextField) {
        
        
        if sender.text!.count > 0 {
            summLabel.text = String(format: "%.2f",(Double(paperStockPrice.text!)!) * Double(sender.text!)!)
            let quantityValue = sender.text!
            self.delegate?.textFieldChanged(cell: self, string: quantityValue )
        }
    }
    
}


