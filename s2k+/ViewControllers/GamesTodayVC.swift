//
//  GamesTodayVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-28.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class GamesTodayVC: UIViewController {
    @IBOutlet weak var gamesToday: UILabel!
    @IBOutlet weak var datePicked: UIDatePicker!
    @IBAction func datePickerSelected(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        gamesToday.text = dateFormatter.string(from: datePicked.date)
    }
    
    override func viewDidLoad() {
        
    }
}
