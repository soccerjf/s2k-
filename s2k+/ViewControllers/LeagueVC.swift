//
//  LeagueVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-10.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit
import Kingfisher
import Network

class LeagueVC: UITableViewController  {

// MARK: kick-off
    let monitor = NWPathMonitor()
    var fetchedLeagues = [League]()
    private var request: AnyObject?
    let networkActivity = NetworkActivity(text: "Fetching Leagues")
    
    @IBAction func leagueHelp(_ sender: Any) {
        performSegue(withIdentifier: "LeagueHelpSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NetStatus.shared.startMonitoring()
        NetStatus.shared.netStatusChangeHandler = {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        checkNetwork()
    }
// MARK: set the section info
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : 1
    }
    override func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Tap on League Logo to see its divisions"
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
    
// MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : fetchedLeagues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! LeagueCell
        switch indexPath.section {
        case 0:
            if NetStatus.shared.isConnected {
                cell.leagueName.text = "Internet Status: Connected"
                cell.leagueEndDateLabel.text = "Using: "
                if NetStatus.shared.isExpensive {
                   cell.leagueEndDate.text = "Cellular"
                } else {
                    cell.leagueEndDate.text = "WiFi"
                }
            } else {
                cell.leagueName.text = "Internet Status: Not Connected"
                cell.leagueEndDateLabel.text = ""
                cell.leagueEndDate.text = ""

            }
            cell.leagueStartDate.text = ""

            cell.leagueStartDateLabel.text = ""
        case 1:
            let leagueData = fetchedLeagues[indexPath.row]
            cell.leagueName.text = leagueData.leagueName
            cell.leagueStartDate.text = leagueData.leagueStart
            cell.leagueEndDate.text = leagueData.leagueEnd

            if let leagueLogo = cell.leagueLogo {
                leagueLogo.kf.setImage(with: self.fetchedLeagues[indexPath.row].leagueLogoURL)
            }
        default: ()
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDivisionVCSegue" {
            guard
              let selectedCell = sender as? UITableViewCell,
              let index = tableView.indexPath(for: selectedCell)?.row, segue.identifier == "showDivisionVCSegue"
              else {
                fatalError("sender is not a UITableViewCell or was not found in the tableView, or segue.identifier is incorrect")
            }
            let dest = segue.destination as? DivisionVC
            dest?.leagueID = fetchedLeagues[index].leagueID
            dest?.leagueName = fetchedLeagues[index].leagueName
            dest?.division = fetchedLeagues[index].divisions as! [Division]
        }
        if segue.identifier == "LeagueHelpSegue" {
            if let dest = segue.destination as? HelpVC {
               dest.sourceID = "League"
            }
        }
    }
}

private extension LeagueVC {
    
    func checkNetwork() {
        if NetStatus.shared.isMonitoring {
          if NetStatus.shared.isConnected {
              self.view.addSubview(networkActivity)
              fetchData(source: "1", dataType: "0", dataTypeDetail: "0")
          } else {
              let networkActivity = NetworkActivity(text: "Network ISSUE")
              self.view.addSubview(networkActivity)
          }
        } else {
            NetStatus.shared.startMonitoring()
        }
    }
    
    func fetchData(source: String,dataType: String, dataTypeDetail: String) {
        let queryItems = [
                URLQueryItem(name: "source", value: source), // 0=production, 1=sandbox
                URLQueryItem(name: "dataType", value: dataType),
                URLQueryItem(name: "dataTypeDetail", value: dataTypeDetail)]
        let leagueRequest = APIRequest(resource: LeagueResource(queryItems: queryItems))
        request = leagueRequest
        leagueRequest.load { [weak self] (leagues: [League]?) in
            guard ((self?.fetchedLeagues = leagues!) != nil)
                 else {
                    //TODO: proper reporting
                    print("Error in fetchData")
                    return
            }
            self?.networkActivity.hide()
            self?.tableView.reloadData()
        }
    }

}
extension UIViewController
{
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        DispatchQueue.main.async  {
               self.present(alertController, animated: true, completion: nil)
        }
    }
}