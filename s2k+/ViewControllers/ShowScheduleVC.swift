//
//  ShowScheduleVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-28.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class ShowScheduleVC: UITableViewController {
    
    var gameDate = ""
    
    let helpVC: HelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpvc") as! HelpVC
    override func viewDidLoad(){
print(gameDate)
    }
}
