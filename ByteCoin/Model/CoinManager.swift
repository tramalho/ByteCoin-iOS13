//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func success(model: CoinModel)
    func error(message: String)
}

public struct CoinManager {
    
    var delegate: CoinManagerDelegate? = nil
    
    private let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

 
    func getCoinPrice(currencyIndex: Int) {
        let currencySelected = currencyArray[currencyIndex]
        performeRequest(currency: currencySelected)
    }
    
    private func performeRequest(currency: String) {
        
        if let url = createURL(suffix: currency) {
            print(url)
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, _, error in
                
                if data != nil, let safeData = data {
                    
                    if let model = parse(data: safeData) {
                        delegate?.success(model: model)
                    } else {
                        delegate?.error(message: "parse error")
                    }
                } else if error != nil {
                    delegate?.error(message: error?.localizedDescription ?? "response error")
                } else {
                    delegate?.error(message: "unknow Error")
                }
            }
            
            task.resume()
        }
    }
    
    private func createURL(suffix: String) -> URL? {
                
        var urlComponent = URLComponents(string: "\(baseURL)/\(suffix)")
        urlComponent?.queryItems = [URLQueryItem(name: "apikey", value: apiKey)]
        
        return urlComponent?.url
    }
    
    private func parse(data: Data) ->  CoinModel? {
        
        var model: CoinModel? = nil
        
        let decoder = JSONDecoder()
        
        do {
            print(data)
            let r = try decoder.decode(CoinResponse.self, from: data)
            model = CoinModel(rate: r.rate, currency: r.asset_id_quote)
        } catch  {
            print("Error: \(error)")
        }
        
        return model
    }
}
