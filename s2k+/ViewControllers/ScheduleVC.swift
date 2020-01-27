//
//  ScheduleVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-19.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit
import EventKit

class ScheduleVC: UITableViewController {
 // MARK: kick-off
    var teamName = ""
    var teamID = ""
    var games = [Schedule]()
    var cupGame = ""
    var homeOrAway = ""
    var latitude = 0.000
    var longitude = 0.000
    @IBAction func scheduleHelp(_ sender: Any) {
        performSegue(withIdentifier: "ScheduleHelpSegue", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = teamName
    }
    // MARK: set the section info
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    override func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Tap on the Field Name to see its location"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        label.font = UIFont(name: "chalkduster", size: 14)
        headerView.addSubview(label)
        return headerView
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleHelpSegue" {
            if let dest = segue.destination as? HelpVC {
                dest.teamName = teamName
                dest.sourceID = "Schedule"
            }
        }
        if segue.identifier == "showMapVCSegue" {
            let selectedCell = (sender as? UITableViewCell)!
            let index = tableView.indexPath(for: selectedCell)?.row
            self.longitude = Double(games[index!].gameLong) ?? 0.000
            self.latitude = Double(games[index!].gameLat) ?? 0.000
            if longitude == 0.00 || latitude == 0.00 {
                let alert = UIAlertController(title: "Error", message: "The co-ordinates for this field have not been set, cannot display a Map", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                    (alertAction: UIAlertAction!) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                let dest = segue.destination as? MapVC
                dest?.latitude = self.latitude
                dest?.longitude = self.longitude
                dest?.fieldName = games[index!].gameLocation
                dest?.gameDetails = games[index!].gameDate + " @ " + games[index!].gameTime
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
        cell.addToCalendarAction = { [unowned self] in
            let eventStore: EKEventStore = EKEventStore()
            eventStore.requestAccess(to: .event) {(granted,error) in
                if(granted) && (error == nil) {
                    let event:EKEvent = EKEvent(eventStore: eventStore)
                    event.title = self.teamName
                    let convertedDate = DateFormatter()
                    convertedDate.dateFormat = "yyyy-MM-dd HH:mm"
                    event.startDate = convertedDate.date(from: self.games[indexPath.row].gameOrgDate)
                    event.endDate = convertedDate.date(from: self.games[indexPath.row].gameOrgDate)?.addingTimeInterval(1.5 * 60 * 60)
                    if self.teamID == self.games[indexPath.row].gameHomeTeamID {
                        event.notes = "Home Game. Opponent is \(self.games[indexPath.row].gameAwayTeam)"
                    } else {
                        event.notes = "Away Game. Opponent is \(self.games[indexPath.row].gameHomeTeam)"
                    }
                    event.location = self.games[indexPath.row].gameLocation
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        print("failed to save event with error : \(error)")
                    }
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Game Added", message: "To be played on  \(self.games[indexPath.row].gameDate)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
                }
            }
        }
        cell.gameDate.text = games[indexPath.row].gameDate
        cell.gameTime.text = games[indexPath.row].gameTime
        if teamID == games[indexPath.row].gameHomeTeamID {
            cell.gameOpponent.text = games[indexPath.row].gameAwayTeam
            cell.gameDate.text! += " (Home)"
        } else {
            cell.gameOpponent.text = games[indexPath.row].gameHomeTeam
            cell.gameDate.text! += " (Away)"
        }
        cell.gameField.text = games[indexPath.row].gameLocation
        return cell
    }
}
