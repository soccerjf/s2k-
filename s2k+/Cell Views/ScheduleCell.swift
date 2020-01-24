//
//  ScheduleCell.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-20.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var gameOpponent: UILabel!
    @IBOutlet weak var gameField: UILabel!
    @IBOutlet weak var addToCalendar: UIButton!
    var addToCalendarAction: (() -> ())?
    
    override func awakeFromNib() {
      super.awakeFromNib()
      self.addToCalendar.addTarget(self, action: #selector(addToCalendarTapped(_:)), for: .touchUpInside)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    }
      
    @IBAction func addToCalendarTapped(_ sender: UIButton){
      addToCalendarAction?()
    }
    
}
