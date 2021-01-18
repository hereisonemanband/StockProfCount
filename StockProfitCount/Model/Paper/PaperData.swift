import Foundation


struct PaperData: Codable {
    let quoteSummary:QuoteSummary
}

struct QuoteSummary: Codable {
    let result:[Result]
}

struct Result: Codable {
    let price:Price
}

struct  Price: Codable {
    let longName: String
    let symbol: String
    let regularMarketPrice:PostMarketChange
}


struct PostMarketChange:Codable {
    let raw:Double
}
