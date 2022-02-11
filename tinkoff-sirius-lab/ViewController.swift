//
//  ViewController.swift
//  tinkoff-sirius-lab
//
//  Created by oleg on 10.02.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    // MARK - IBOutlets
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK - Private properties
    
    private let companies: [String: String] = ["Apple": "AAPL",
                                               "Microsoft": "MSFT",
                                               "Google": "GOOG",
                                               "Amazon": "AMZN",
                                               "Facebook": "FB"]
    
    private let apiToken = "pk_30a2dc614a084561b6c3e6d053487def"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyNameLabel.text = "Tinkoff"
        
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        self.requestQuoteUpdate()
    }

    
    // MARK - Private methods
    
    private func requestQuote(for symbol: String) {
        let url = URL(string:"https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(self.apiToken)")!
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                print(" Network error")
                return
            }
            self.parseQuote(data: data)
        }
        dataTask.resume()
    }
    
    private func requestQuoteUpdate () {
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text = "-"
        self.priceLabel.text = "-"
        self.priceChangeLabel.text = "-"
        
        let selecterRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selecterSymbol = Array(self.companies.values)[selecterRow]
        self.requestQuote(for: selecterSymbol)
    }
    
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                print("Invalid JSON format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName,
                                      companySymbol: companySymbol,
                                      price: price,
                                      priceChange: priceChange)
            }
        }
        catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String, companySymbol: String, price: Double, priceChange: Double){
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolLabel.text = companySymbol
        self.priceLabel.text = "\(price)"
        var textColor = UIColor.black
        if priceChange > 0 {
            textColor = UIColor.systemGreen
        }
        else if priceChange < 0 {
            textColor = UIColor.systemRed
        }
        self.priceChangeLabel.textColor = textColor
        self.priceChangeLabel.text = "\(priceChange)"
    }
    
    // MARK - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    //MARK - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicator.startAnimating()
        let selectedSymbol = Array(self.companies.values)[row]
        self.requestQuote(for: selectedSymbol)
    }
}

