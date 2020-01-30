//
//  FoundTeamsVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-27.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class FoundTeamsVC: UITableViewController {

    var searchParams = ""
    var fetchedTeams = [Team]()
    var teamGender = ""
    var teamAgeGroup = ""

    @IBAction func FoundTeamHelp(_ sender: Any) {
        helpVC.sourceID = "FoundTeam"
        self.present(helpVC, animated: false, completion: nil)
    }
    private var request: AnyObject?
    let helpVC: HelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpvc") as! HelpVC
    let scheduleVC: ScheduleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulevc") as! ScheduleVC
    override func viewDidLoad() {
        fetchData(source: DataSource.source, dataType: "3", dataTypeDetail: searchParams)
    }
    override func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-20)
            label.text = "Tap on a Team Name to see their schedule"
            label.textAlignment = .center
            label.textColor = UIColor.orange
            label.font = UIFont(name: "chalkduster", size: 14)
            headerView.addSubview(label)
            return headerView
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedTeams.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fetchedTeams[indexPath.row].teamID == "-1" {
            self.showAlert(title: "Note", message: "\(fetchedTeams[indexPath.row].teamName)")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "foundTeamCell", for: indexPath) as! FoundTeamsCell
        cell.foundTeamName.text = fetchedTeams[indexPath.row].teamName
        cell.foundTeamGender.text = teamGender
        cell.foundTeamAgeGroup.text = teamAgeGroup
        cell.foundTeamDivision.text = fetchedTeams[indexPath.row].teamDivision
        cell.foundTeamLeague.text = fetchedTeams[indexPath.row].teamLeague

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleVC.teamName = fetchedTeams[indexPath.row].teamName
        scheduleVC.teamID = fetchedTeams[indexPath.row].teamID
        scheduleVC.games = self.fetchedTeams[indexPath.row].teamSchedule as! [Schedule]
        self.navigationController?.pushViewController(scheduleVC, animated: true)
    }
}
private extension FoundTeamsVC {
    func fetchData(source: String,dataType: String, dataTypeDetail: String) {
        let queryItems = [
                URLQueryItem(name: "source", value: source), // 0=production, 1=sandbox
                URLQueryItem(name: "dataType", value: dataType),
                URLQueryItem(name: "dataTypeDetail", value: dataTypeDetail)]
        let teamRequest = APIRequest(resource: TeamResource(queryItems: queryItems))
        request = teamRequest
        teamRequest.load { [weak self] (teams: [Team]?) in
            guard ((self?.fetchedTeams = teams!) != nil)
                 else {
                    self!.showAlert(title: "Error", message: "Fetching Search Team Data from S2K failed, pleae try again later.")
                    return
            }
            self?.tableView.reloadData()
        }
    }
}
