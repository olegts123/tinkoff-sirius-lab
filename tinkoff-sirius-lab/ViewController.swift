//
//  ViewController.swift
//  tinkoff-sirius-lab
//
//  Created by oleg on 10.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNameLabel.text = "Tinkoff"
    }


}

