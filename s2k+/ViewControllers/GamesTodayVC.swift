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
        dateToString()
    }
    
    @IBAction func findGamesButton(_ sender: Any) {
    }
    @IBOutlet weak var styledButton: UIButton!
    let helpVC: HelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpvc") as! HelpVC
    
    @IBAction func showScheduleHelp(_ sender: Any) {
        helpVC.sourceID = "ShowSchedule"
        self.present(helpVC, animated: false, completion: nil)
    }
    override func viewDidLoad() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 1
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        datePicked.minimumDate = minDate
        datePicked.maximumDate = maxDate
        styledButton.layer.cornerRadius = 10
        dateToString()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowScheduleVCSegue" {
            let dest = segue.destination as? ShowScheduleVC
            dest?.gameDate = gamesToday.text!
        }
    }
    func dateToString(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.full
        gamesToday.text = dateFormatter.string(from: datePicked.date)
    }
}
