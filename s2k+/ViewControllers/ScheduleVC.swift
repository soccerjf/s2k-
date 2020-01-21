//
//  ScheduleVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-19.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class ScheduleVC: UITableViewController {
 // MARK: kick-off
    var teamName = ""
    var teamID = ""
    var games = [Schedule]()
    var cupGame = ""
    var homeOrAway = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: set the section info
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    override func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Tap on Map Icon to see directions to the field"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        label.font = UIFont(name: "chalkduster", size: 14)
        headerView.addSubview(label)
        return headerView
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleHelpSegue" {
            if let dest = segue.destination as? HelpVC {
                dest.sourceID = "Schedule"
            }
        }
    }
    // MARK: - Table view data source and delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        cell.gameDate.text = games[indexPath.row].gameDate
        cell.gameTime.text = games[indexPath.row].gameTime
        if teamID == games[indexPath.row].gameHomeTeamID {
            cell.gameOpponent.text = games[indexPath.row].gameAwayTeam
        } else {
            cell.gameOpponent.text = games[indexPath.row].gameHomeTeam
        }
        cell.gameField.text = games[indexPath.row].gameLocation
        return cell
    }
}
