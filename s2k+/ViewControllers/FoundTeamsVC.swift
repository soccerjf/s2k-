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
    private var request: AnyObject?
    override func viewDidLoad() {
        print(searchParams)
        fetchData(source: DataSource.source, dataType: "3", dataTypeDetail: searchParams)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : 1
    }
    override func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Tap on a Team Name to see their schedule"
            label.textAlignment = .center
            label.textColor = UIColor.orange
            label.font = UIFont(name: "chalkduster", size: 14)
            headerView.addSubview(label)
            return headerView
        } else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 10))
            return headerView
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : fetchedTeams.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foundTeamCell", for: indexPath) as! FoundTeamsCell
        switch indexPath.section {
        case 1:
            cell.foundTeamName.text = fetchedTeams[indexPath.row].teamName
            cell.foundTeamGender.text = teamGender
            cell.foundTeamAgeGroup.text = teamAgeGroup
            cell.foundTeamDivision.text = fetchedTeams[indexPath.row].teamDivision
            cell.foundTeamLeague.text = fetchedTeams[indexPath.row].teamLeague
        default: ()
        }
        return cell
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
                    #warning ("proper reporting")
                    print("Error in fetchData - Found Teams")
                    return
            }
            self?.tableView.reloadData()
        }
    }
}
