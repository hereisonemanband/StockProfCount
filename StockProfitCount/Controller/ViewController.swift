//
//  ViewController.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 03.10.2020.
//

import UIKit
import CoreData
import SwipeCellKit


class ViewController: UIViewController {

    @IBOutlet weak var initialStockTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    private lazy var stocks = [Stock]()
    private lazy var paperManager = PaperManager()
    private lazy var currencyManager = USDRubManager()
    private lazy var networkCheck = Reachability()
    
    private lazy var tempStockUsd = [Double]()
    private lazy var tempStockInt = [Double]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let buttonsLayout = ButtonsLayout()

    override func viewWillAppear(_ animated: Bool) {
        loadStock()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        currencyManager.delegate = self
        currencyManager.getUsdrubPrice()
        
        initialStockTableView.dataSource = self
        buttonsLayout.addButtonLayout(button: addButton)
        loadStock()
        
        initialStockTableView.rowHeight = 80
        
    }

    
    //CoreData - сохраняем добавленную акцию.
    func saveStock() {
        do {
            try context.save()
        } catch {
            print("Error saving stock \(error)")
        }
        initialStockTableView.reloadData()
    }
    
    
    func loadStock() {
        let request : NSFetchRequest<Stock> = Stock.fetchRequest()
        
        do{
            stocks = try context.fetch(request)
        } catch {
            print("Error loading stokcs \(error)")
        }
        initialStockTableView.reloadData()
    }
    
    
   // Конец CoreData
    

    
    @IBAction func addButtonPressed(_ sender: UIButton) {

        if Reachability.isConnectedToNetwork() {
            performSegue(withIdentifier: "FromViewControllerToSearchPaperVC", sender: sender)
        } else {
            let alert = UIAlertController(title: nil, message: "Проверьте подключение к интернету", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in //dismmiss action buttomn
            self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource,SwipeTableViewCellDelegate, USDRubManagerDelegate  {
    
    // MARK: - Table Init
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = stocks[indexPath.row].name
        cell.delegate = self
        return cell
    }
    
    // MARK: - Segue preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FromViewControllerToStored":
            let storedPaperVC = segue.destination as! StoredPaperVC
            if let indexPath = initialStockTableView.indexPathForSelectedRow {
                storedPaperVC.indexNumber = indexPath.row
                storedPaperVC.currentUSDPrice = tempStockUsd[0]
            }
        case "FromViewControllerToProfitCountVC":
            let profitCountVC = segue.destination as! ProfitCountVC
            profitCountVC.currentUSDPrice = tempStockUsd[0]
            
        case "FromViewControllerToSearchPaperVC":
            let searchPaperVC = segue.destination as! SearchPaperVC
            searchPaperVC.currentUSDRubPrice = tempStockUsd[0]
        default:
            break
        }
    }
    
    //MARK: -  Swipe deletion
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in

            self.context.delete(self.stocks[indexPath.row])
            self.loadStock()

        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    //MARK: -  Recieve RUB/USD price
    
    func didRecieveInfoUsdRub(currencyManager: USDRubManager, currencyData: USDRubModel) {
        tempStockUsd.append(currencyData.value)
    }
}
