//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    private lazy var coinManager: CoinManager = {
        var manager = CoinManager()
        manager.delegate = self
       return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.getCoinPrice(currencyIndex: currencyPicker.selectedRow(inComponent: 0))
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(currencyIndex: row)
    }
}

extension ViewController: CoinManagerDelegate {
    func success(model: CoinModel) {
        DispatchQueue.main.async {
            self.currencyLabel.text = model.currency
            self.bitcoinLabel.text = String(format: "%.2f", arguments: [model.rate])
        }
    }
    
    func error(message: String) {
        
    }
}
