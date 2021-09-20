//
//  CoinResponse.swift
//  ByteCoin
//
//  Created by Thiago Antonio Ramalho on 20/09/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct CoinResponse: Decodable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
