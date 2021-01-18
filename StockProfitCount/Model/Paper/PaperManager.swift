//
//  PaperManager.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 17.10.2020.
//

import Foundation
import UIKit






protocol PaperManagerDelegate {
    func didRecieveInfo(paperManager: PaperManager, paperData: PaperModel )
}

struct  PaperManager {
    
    var delegate: SearchPaperVC?
    var delegate3: StoredPaperVC?
    let view = UIView()

    func getPapreInfo(paperName: String) {
        let simpleURL = "https://query1.finance.yahoo.com/v10/finance/quoteSummary/"
        let price = "?modules=price"
        let urlString = "\(simpleURL)\(paperName)\(price)"
        performRequest(with: urlString)
    }
     
    
    func performRequest(with urlString: String) {

        if let url = URL(string: urlString) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    
                    return
                }
                if let safeData = data {
                    if let price =  self.parseJSON(safeData) {
                        self.delegate?.didRecieveInfo(paperManager: self, paperData: price)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Oh God
    
    func requestForCurrentPrice(with urlString: String, completionHandler: @escaping (PaperModel) -> Void) {
        let simpleURL = "https://query1.finance.yahoo.com/v10/finance/quoteSummary/"
        let price = "?modules=price"
        let readyUrl = "\(simpleURL)\(urlString)\(price)"
        
        if let url = URL(string: readyUrl) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    return
                }
                if let safeData = data {
                    if let price =  self.parseJSON(safeData) {
                        completionHandler(price)
                    }
                }
            }
            task.resume()
        }
        
    }

    func parseJSON(_ data: Data) ->  PaperModel? {
        let decoder = JSONDecoder()
        do {
            let decodedDataYahoo = try decoder.decode(PaperData.self, from: data)
            let name = decodedDataYahoo.quoteSummary.result[0].price.longName
            let price = decodedDataYahoo.quoteSummary.result[0].price.regularMarketPrice.raw
            let symbol = decodedDataYahoo.quoteSummary.result[0].price.symbol
            let stockPaper = PaperModel(paperName: name, paperPrice: price, symbol: symbol)
            return stockPaper
        } catch {
//             print(error)
            DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "Не удалось найти компанию", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in //dismmiss action buttomn
            self.delegate?.dismiss(animated: true, completion: nil)
            }))
                
            self.delegate?.present(alert, animated: true)
            }
            
            return nil
        }
    }
    
}
