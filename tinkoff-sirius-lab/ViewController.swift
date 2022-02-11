//
//  ViewController.swift
//  tinkoff-sirius-lab
//
//  Created by oleg on 10.02.2022.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    

    @IBOutlet weak var companyNameLabel: UILabel!
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
        
        self.activityIndicator.startAnimating()
        self.requestQuote(for: "AAPL")
    }

    
    // MARK - Private methods
    
    private func requestQuote(for symbol: String) {
        let url = URL(string:"https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=\(self.apiToken)")!
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            print(data!)
        }
        
        dataTask.resume()
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
}

