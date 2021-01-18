//
//  SearchPaperVCTableViewController.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 18.11.2020.
//

import UIKit


class SearchPaperVC: UITableViewController {

    private lazy var stocks = [Stock]()
    private lazy var paperManager = PaperManager()
    
    private lazy var tempStockName = [String]()
    private lazy var tempStockSymbol = [String]()
    private lazy var tempStockInt = [Double]()
    
    lazy var currentUSDRubPrice:Double = 0

   
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    @IBOutlet weak var searchBar: UISearchBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paperManager.delegate = self
        searchBar.delegate = self
        tableView.separatorStyle = .none
    
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStockName.count

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchReusableCell", for: indexPath)
        cell.textLabel?.text = tempStockName[0]
    
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "FromSearchToDealDescription", sender: indexPath.row)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromSearchToDealDescription" {
            let ddVC = segue.destination as! DealDescriptionsVC
            ddVC.name = tempStockName[0]
            ddVC.price = tempStockInt[0]
            ddVC.usd = currentUSDRubPrice
            ddVC.symbol = tempStockSymbol[0]
        }
    }
}


extension SearchPaperVC:UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let ticker = searchBar.text {
            paperManager.getPapreInfo(paperName: ticker)
            
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchText.count == 0 {
            tempStockName.removeAll()
            tempStockSymbol.removeAll()
            tempStockInt.removeAll()
        }
        
        tableView.reloadData()
    }
}

extension SearchPaperVC:PaperManagerDelegate {
    func didRecieveInfo(paperManager: PaperManager, paperData: PaperModel) {
            
        if tempStockName.count == 0 {
            tempStockName.append(paperData.paperName)
            tempStockSymbol.append(paperData.symbol)
            tempStockInt.append(paperData.paperPrice)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
