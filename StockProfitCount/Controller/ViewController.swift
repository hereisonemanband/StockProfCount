//
//  ViewController.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 03.10.2020.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var initialStockTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    lazy var stocks = [Stock]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var lastKnownOffset:CGFloat? Maybe for disable buttom in the future
    
    private let buttonsLayout = ButtonsLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "Hello There"
//        self.view.backgroundColor = .white
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.initialStockTableView.dataSource = self
        buttonsLayout.addButtonLayout(button: addButton)
        
        loadStock()
        
    }
    
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
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Stock", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newStock = Stock(context: self.context)
            newStock.name = textField.text!
            self.stocks.append(newStock)
            self.saveStock()
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new stock"
        }
        present(alert, animated: true, completion: nil)
        
        }
}




extension ViewController: UITableViewDataSource {
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = stocks[indexPath.row].name
        return cell
    }
    
}
