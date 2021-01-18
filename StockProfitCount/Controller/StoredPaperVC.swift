//
//  StoredPaperViewController.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 10.12.2020.
//

import UIKit
import CoreData

class StoredPaperVC: UITableViewController {

    private lazy var stocks = [Stock]()
    private var paperManager = PaperManager()
    
    var indexNumber = 0
    var currentUSDPrice = 0.0
    var currentPaperPrice:Double?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AfterBuyDealDescription", bundle: nil), forCellReuseIdentifier:"AfterBuyReusableCell")
        tableView.register(UINib(nibName: "DealDescription", bundle: nil), forCellReuseIdentifier:"SearchReusableCell")
        
        paperManager.delegate3 = self
        loadStock()
     
        
    }
    
    func loadStock() {
        let request : NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do{
            stocks = try context.fetch(request)
        } catch {
            print("Error loading stokcs \(error)")
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2 // Добавляем тут еще  +1 чтобы отобразить  ячейку с покупкой
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //иницилиазируем еще одну кастомную ячейку
        if indexPath.row > 0
        
        {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AfterBuyReusableCell", for: indexPath) as! AfterByuDescriptionCell
                paperManager.requestForCurrentPrice(with: stocks[indexNumber].symbol!) { (paper) in
                    DispatchQueue.main.async {
                        cell.currentPaperStockPrice.text = String(format: "%.2f", paper.paperPrice)
                        cell.currentRUBUSDPrice.text = String(format:"%.2f",self.currentUSDPrice)
                        cell.currentSumm.text = "\(Double(cell.currentPaperStockPrice.text!)! * self.stocks[self.indexNumber].quantity)"
                    }
                }
                cell.afterBuyPaperCompanyName.text = stocks[indexNumber].name
                cell.storedQuantityLabelText.text = String(format:"%.0f", stocks[indexNumber].quantity)
            
                return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchReusableCell", for: indexPath) as! DealDescriptionCell
        cell.paperCompanyNameLabel.text = stocks[indexNumber].name
        cell.paperStockPrice.text = String(format: "%.2f", stocks[indexNumber].buyMomentPrice)
        cell.dollarPriceinBuyMoment.text =  String(format: "%.2f",stocks[indexNumber].usdRubRate)
        cell.quantityLabelText.text = String(format: "%.0f", stocks[indexNumber].quantity)
        cell.summLabel.text = "\(Double(cell.paperStockPrice.text!)! * Double(cell.quantityLabelText.text!)!)" // тут проверить что с нилами
        
        return cell
    }
}
