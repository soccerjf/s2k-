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
    var gameDateFormatted = ""
    var fetchedGames = [Schedule]()
    private var request: AnyObject?
    let helpVC: HelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpvc") as! HelpVC
    let mapVC: MapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapvc") as! MapVC

    override func viewDidLoad(){
        navigationItem.title = gameDateFormatted
        fetchData(source: DataSource.source, dataType: "4", dataTypeDetail: gameDate)
    }
    override func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-50)
            label.text = "Tap on a Field Name to see the map"
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
        return fetchedGames.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showScheduleCell", for: indexPath) as! ShowScheduleCell
        cell.ageGroupGender.text = fetchedGames[indexPath.row].gameAgeGroup + fetchedGames[indexPath.row].gameGender
        cell.homeTeam.text = fetchedGames[indexPath.row].gameHomeTeam
        cell.awayTeam.text = fetchedGames[indexPath.row].gameAwayTeam
        cell.field.text = fetchedGames[indexPath.row].gameLocation
        cell.division.text = fetchedGames[indexPath.row].gameTier
        cell.league.text = fetchedGames[indexPath.row].gameLeague
        cell.gameTime.text = fetchedGames[indexPath.row].gameTime
        cell.city.text = fetchedGames[indexPath.row].gameCity
        return cell
    }
}
private extension ShowScheduleVC {
    func fetchData(source: String,dataType: String, dataTypeDetail: String) {
        let queryItems = [
                URLQueryItem(name: "source", value: source), // 0=production, 1=sandbox
                URLQueryItem(name: "dataType", value: dataType),
                URLQueryItem(name: "dataTypeDetail", value: dataTypeDetail)]
        let gameRequest = APIRequest(resource: GameResource(queryItems: queryItems))
        request = gameRequest
        gameRequest.load { [weak self] (games: [Schedule]?) in
            guard ((self?.fetchedGames = games!) != nil)
                 else {
                    let alert = UIAlertController(title: "Error", message: "Fetching Search Game Data from S2K failed, pleae try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                        (alertAction: UIAlertAction!) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self!.present(alert, animated: true, completion: nil)
                    return
            }
            self?.tableView.reloadData()
        }
    }
}
