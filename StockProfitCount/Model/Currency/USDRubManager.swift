//
//  PaperManager.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 17.10.2020.
//

import Foundation


protocol USDRubManagerDelegate {
    func didRecieveInfoUsdRub(currencyManager: USDRubManager, currencyData: USDRubModel )
}

struct  USDRubManager {
    
    var delegate: ViewController?
     
    func getUsdrubPrice() {
        performRequest(with: "https://api.exchangeratesapi.io/latest?base=USD")
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
                        self.delegate?.didRecieveInfoUsdRub(currencyManager: self, currencyData: price)
                    }
                }
            }
            task.resume()
        }
    }

    
    
    func parseJSON(_ data: Data) ->  USDRubModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(USDRubData.self, from: data)
            let value = decodedData.rates.RUB
            let usdRubValue = USDRubModel(value: value)
            return usdRubValue

        } catch {
             print(error)
            return nil
        }
    }

    
}
