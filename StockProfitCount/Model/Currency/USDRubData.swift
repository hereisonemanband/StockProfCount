//
//  USDRubData.swift
//  StockProfitCount
//
//  Created by Balakirev, Denis on 02.12.2020.
//

import Foundation


// MARK: - Data for USD/Rub JSON
struct USDRubData: Codable {
    let rates: Rates
}


struct Rates: Codable {
    let RUB: Double
}
