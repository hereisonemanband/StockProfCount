//
//  ProfitCountVC.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 20.12.2020.
//

import UIKit
import CoreData

class ProfitCountVC: UIViewController {

    @IBOutlet weak var summRubProfitCountLabel: UILabel!
    @IBOutlet weak var summProfitCountUSDLabel: UILabel!
    @IBOutlet weak var summInRubForMomentBuy: UILabel!
    
    private lazy var stocks = [Stock]()
    private let currencyManager = USDRubManager()
    lazy var currentUSDPrice = 0.0
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()

        loadStock()
        summProfitCountUSDLabel.text = "Общая сумма в USD \(String(format: "%0.2f", calculateUSDSumm()))"
        summRubProfitCountLabel.text = "Общая сумма в RUB \(String(format: "%0.2f", calculateRUBSUM()))"
        summInRubForMomentBuy.text = "В момент покупки \(String(format: "%0.2f", calculateRUBBuyMoment()))"
    }
    
    
    func loadStock() {
        let request : NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do{
            stocks = try context.fetch(request)
        } catch {
            print("Error loading stokcs \(error)")
        }
    }
    
    
    func calculateUSDSumm() -> Double {
        var summ = 0.0
        for i in stocks {
            summ += i.buyMomentPrice * i.quantity
        }
        return summ
    }
    
    func calculateRUBSUM() -> Double {
        var summ = 0.0
        for i in stocks {
            summ += i.buyMomentPrice * i.quantity
        }
        return summ * currentUSDPrice
    }
    
    // MARK: - Avarage Summ in RUB with avarage RUB Price
    func calculateRUBBuyMoment() -> Double {
        var summ = 0.0
        var aveRub = 0.0
        var array = [Double]()

        for i in stocks {
            aveRub = i.quantity * i.usdRubRate / i.quantity // Finding Average RUB price for each stock
            array.append(Double(aveRub)) // adding to array
            summ += i.buyMomentPrice * i.quantity // summ in USD for all stocks
        }
        
        let average = array.reduce(0.0) {   // Avaragte USD price from all stocks
            return $0 + $1 / Double(array.count)
        }
        return summ * average
    }
}
