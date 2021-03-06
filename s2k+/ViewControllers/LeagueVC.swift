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
import GoogleMobileAds

class LeagueVC: UITableViewController {

    let monitor = NWPathMonitor()
    var fetchedLeagues = [League]()
    private var request: AnyObject?
    let networkActivity = NetworkActivity(text: "Fetching Leagues")

    lazy var googleAdMobBanner: GoogleAds = {
        return GoogleAds(sourceTableViewController: self)
    }()
    
    @IBAction func leagueHelp(_ sender: Any) {
        performSegue(withIdentifier: "LeagueHelpSegue", sender: nil)
    }
    @IBAction func todayGamesButton(_ sender: Any) {
    }
    @IBAction func alternateSearchButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkStatus.shared.startMonitoring()
        NetworkStatus.shared.netStatusChangeHandler = {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
        googleAdMobBanner.loadAdMob()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkNetwork()
    }

 
// MARK: set the section info

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
    
// MARK: - Table view data source and delegate methods
    
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
            if NetworkStatus.shared.isConnected {
                cell.leagueName.text = "Internet Status: Connected"
                cell.leagueEndDateLabel.text = "Using: "
                cell.leagueStartDate = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                cell.leagueStartDateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                //label.numberOfLines = 0
               // cell.leagueStartDateLabel.numberOfLines = 0
                if NetworkStatus.shared.isExpensive {
                   cell.leagueEndDate.text = "Cellular"
                } else {
                    cell.leagueEndDate.text = "WiFi"
                }
            } else {
                cell.leagueName.text = "Internet Status: Not Connected"
                cell.leagueEndDateLabel.text = ""
                cell.leagueEndDate.text = ""
            }
  //          cell.leagueStartDate.text = ""
  //          cell.leagueStartDateLabel.text = ""
        case 1:
            cell.leagueName.text = fetchedLeagues[indexPath.row].leagueName
            cell.leagueStartDate.text = fetchedLeagues[indexPath.row].leagueStart
            cell.leagueEndDate.text = fetchedLeagues[indexPath.row].leagueEnd
            if let leagueLogo = cell.leagueLogo {
                leagueLogo.kf.setImage(with: self.fetchedLeagues[indexPath.row].leagueLogoURL)
            }
        default: ()
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDivisionVCSegue" {
            let selectedCell = sender as? UITableViewCell
            let index = tableView.indexPath(for: selectedCell!)?.row
            let dest = segue.destination as? DivisionVC
            dest?.leagueID = fetchedLeagues[index!].leagueID
            dest?.leagueName = fetchedLeagues[index!].leagueName
            dest?.division = fetchedLeagues[index!].divisions as! [Division]
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
        if NetworkStatus.shared.isMonitoring {
          if NetworkStatus.shared.isConnected {
              self.view.addSubview(networkActivity)
            fetchData(source: DataSource.source, dataType: "0", dataTypeDetail: "0")
          } else {
              let networkActivity = NetworkActivity(text: "Network ISSUE")
              self.view.addSubview(networkActivity)
          }
        } else {
            NetworkStatus.shared.startMonitoring()
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
                    let alert = UIAlertController(title: "Error", message: "Could not retrieve the League Data from S2K, please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                        (alertAction: UIAlertAction!) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self!.present(alert, animated: true, completion: nil)
                    return
            }
            self?.networkActivity.hide()
            self?.tableView.reloadData()
        }
    }
}
