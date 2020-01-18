//
//  TeamsVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-14.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class TeamsVC: UIViewController {
//MARK: read data from division selection
    var divID = ""
    var divName = ""
    var showStandings = "Yes"
    var fetchedTeams = [Team]()
    var currentRow = 0
    var previousPoints = ""
    var previousRank = ""
    var teamRank = ""
    var lastSelectedTeam = IndexPath(row: 0, section: 0)
    var teamID = 0
    var teamName = ""
    private var request: AnyObject?
    let networkActivity = NetworkActivity(text: "Fetching Teams")
    
    @IBAction func teamHelp(_ sender: Any) {
        performSegue(withIdentifier: "TeamHelpSegue", sender: nil)
    }
    @IBOutlet weak var gridLayout: StandingsLayout! {
        didSet {
            gridLayout.stickyRowsCount = 1
            gridLayout.stickyColumnsCount = 1
        }
    }

    @IBOutlet weak var showPastGamesItem: UIBarButtonItem!
    @IBOutlet weak var showScheduleItem: UIBarButtonItem!
    @IBOutlet weak var teamsView: UICollectionView!{
        didSet {
            teamsView.bounces = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibLastGames = UINib(nibName: "LastFiveGamesCell", bundle: nil)
        teamsView.register(nibLastGames, forCellWithReuseIdentifier: "LastFiveGamesCell")
        if showStandings != "Yes" {
            navigationItem.title = "Teams In The Division"
        } else {
            navigationItem.title = "Team Standings"
        }
        self.view.addSubview(networkActivity)
        fetchData(source: DataSource.source, dataType: "1", dataTypeDetail: divID)
    }
    override func viewWillAppear(_ animated: Bool) {
        showScheduleItem.isEnabled = false
        showPastGamesItem.isEnabled = false
    }
    
}
// MARK: - Collection view data source and delegate methods

extension TeamsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /* + 1 to allow for a header */
        let trueRows = fetchedTeams.count + 1
        return trueRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeamCell
        if indexPath.section == 0 {
            cell.backgroundColor = UIColor(red:0.23, green:0.42, blue:0.36, alpha:1.0)
            cell.anyLabel.textColor = UIColor.white
            switch indexPath.row {
            case 0:
                cell.anyLabel.text = "Team Name"
            case 1:
                cell.anyLabel.text = "Rank"
            case 2:
                cell.anyLabel.text = "Pts"
            case 3:
                cell.anyLabel.text = "G"
            case 4:
                cell.anyLabel.text = "W"
            case 5:
                cell.anyLabel.text = "T"
            case 6:
                cell.anyLabel.text = "L"
            case 7:
                cell.anyLabel.text = "GF"
            case 8:
                cell.anyLabel.text = "GA"
            case 9:
                cell.anyLabel.text = "GF"
            case 10:
                cell.anyLabel.text = "Last 5 Games"
            default:
                cell.anyLabel.text = ""
            }
            if indexPath.item > 0 {
                if showStandings != "Yes" {
                    cell.anyLabel.text = ""
                }
            }
        } else {
            currentRow = indexPath.section - 1
            if indexPath.section == 1 && indexPath.item == 1 {
                teamRank = ""
                previousRank = ""
                previousPoints = ""
            }
            if indexPath.item == 1 {
                if previousRank == "15th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "16th"
                    previousRank = "16th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "14th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "15th"
                    previousRank = "15th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "13th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "14th"
                    previousRank = "14th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "12th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "13th"
                    previousRank = "13th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "11th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "12th"
                    previousRank = "12th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "10th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "11th"
                    previousRank = "11th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "9th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "10th"
                    previousRank = "10th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "8th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "9th"
                    previousRank = "9th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "7th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "8th"
                    previousRank = "8th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "6th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "7th"
                    previousRank = "7th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "5th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "6th"
                    previousRank = "6th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "4th" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "5th"
                    previousRank = "5th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "3rd" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "4th"
                    previousRank = "4th"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "2nd" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "3rd"
                    previousRank = "3rd"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousRank == "1st" && fetchedTeams[currentRow].teamPoints != previousPoints {
                    teamRank = "2nd"
                    previousRank = "2nd"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
                if previousPoints == "" {
                    teamRank = " 1st"
                    previousRank = "1st"
                    previousPoints = fetchedTeams[currentRow].teamPoints
                }
            }

            switch indexPath.item {
            case 0:
                cell.anyLabel.text = fetchedTeams[currentRow].teamName
            case 1:
                cell.anyLabel.text = teamRank
            case 2:
                cell.anyLabel.text = fetchedTeams[currentRow].teamPoints
            case 3:
                cell.anyLabel.text = fetchedTeams[currentRow].teamTotalGames
            case 4:
                cell.anyLabel.text = fetchedTeams[currentRow].teamWins
            case 5:
                cell.anyLabel.text = fetchedTeams[currentRow].teamTies
            case 6:
                cell.anyLabel.text = fetchedTeams[currentRow].teamLosses
            case 7:
                cell.anyLabel.text = fetchedTeams[currentRow].teamGoalsFor
            case 8:
                cell.anyLabel.text = fetchedTeams[currentRow].teamGoalsAgainst
            case 9:
                cell.anyLabel.text = fetchedTeams[currentRow].teamGoalDiff
            default:
                cell.anyLabel.text = ""
            }
            if indexPath.section > 0 && indexPath.item == 10  && showStandings == "Yes" {
                let lastFiveCell:LastFiveGamesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastFiveGamesCell", for: indexPath) as! LastFiveGamesCell
                currentRow = indexPath.section - 1
                lastFiveCell.lastGameA.text = fetchedTeams[currentRow].teamLastGameA
                if lastFiveCell.lastGameA.text == "W" {
                    lastFiveCell.lastGameA.backgroundColor = UIColor.green
                } else if lastFiveCell.lastGameA.text == "L"{
                    lastFiveCell.lastGameA.backgroundColor = UIColor.red
                } else {
                    lastFiveCell.lastGameA.backgroundColor = UIColor.orange
                }
                lastFiveCell.lastGameB.text = fetchedTeams[currentRow].teamLastGameB
                if lastFiveCell.lastGameB.text == "W" {
                    lastFiveCell.lastGameB.backgroundColor = UIColor.green
                } else if lastFiveCell.lastGameB.text == "L"{
                    lastFiveCell.lastGameB.backgroundColor = UIColor.red
                } else {
                    lastFiveCell.lastGameB.backgroundColor = UIColor.orange
                }
                lastFiveCell.lastGameC.text = fetchedTeams[currentRow].teamLastGameC
                if lastFiveCell.lastGameC.text == "W" {
                    lastFiveCell.lastGameC.backgroundColor = UIColor.green
                } else if lastFiveCell.lastGameC.text == "L"{
                    lastFiveCell.lastGameC.backgroundColor = UIColor.red
                } else {
                    lastFiveCell.lastGameC.backgroundColor = UIColor.orange
                }
                lastFiveCell.lastGameD.text = fetchedTeams[currentRow].teamLastGameD
                if lastFiveCell.lastGameD.text == "W" {
                    lastFiveCell.lastGameD.backgroundColor = UIColor.green
                } else if lastFiveCell.lastGameD.text == "L"{
                    lastFiveCell.lastGameD.backgroundColor = UIColor.red
                } else {
                    lastFiveCell.lastGameD.backgroundColor = UIColor.orange
                }
                lastFiveCell.lastGameE.text = fetchedTeams[currentRow].teamLastGameE
                if lastFiveCell.lastGameE.text == "W" {
                    lastFiveCell.lastGameE.backgroundColor = UIColor.green
                } else if lastFiveCell.lastGameE.text == "L"{
                    lastFiveCell.lastGameE.backgroundColor = UIColor.red
                } else {
                    lastFiveCell.lastGameE.backgroundColor = UIColor.orange
                }
                return lastFiveCell
            }
            if indexPath.item > 1 {
                cell.anyLabel.textAlignment = .right
                cell.backgroundColor = UIColor.white
                cell.anyLabel.textColor = UIColor.black
                if showStandings != "Yes" {
                    cell.anyLabel.text = ""
                }
            } else if indexPath.item == 1 {     //rank column
                cell.backgroundColor = UIColor(red:0.95, green:0.93, blue:0.93, alpha:1.0)
                cell.anyLabel.textColor = UIColor.darkGray
                cell.anyLabel.font = UIFont.italicSystemFont(ofSize: 12)
                cell.anyLabel.textAlignment = .center
                if showStandings != "Yes" {
                    cell.anyLabel.text = ""
                    cell.backgroundColor = UIColor.white
                    cell.anyLabel.textColor = UIColor.black
                }
            } else if indexPath.item == 0 {
                cell.backgroundColor = UIColor.white
                cell.anyLabel.textColor = UIColor.black
                cell.anyLabel.textAlignment = .left
            }
        }

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "TeamHelpSegue" && self.showStandings == "Yes" {
            if let dest = segue.destination as? HelpVC {
                dest.sourceID = "Standings"
            }
        }
        if segue.identifier == "TeamHelpSegue" && self.showStandings != "Yes" {
            if let dest = segue.destination as? HelpVC {
                dest.sourceID = "Team"
            }
        }
        if segue.identifier == "PastGamesSegue" {
            let backButton = UIBarButtonItem()
            backButton.title = "Teams"
            navigationItem.backBarButtonItem = backButton
            let cell = teamsView.cellForItem(at: lastSelectedTeam)
            cell?.layer.borderWidth = 0.0
            cell?.layer.borderColor = UIColor.white.cgColor
            let dest = segue.destination as? PastGamesVC
            let tempGames = self.fetchedTeams[lastSelectedTeam.row].teamSchedule
            let playedGames = tempGames.filter{ ($0?.gameStatus.contains("1"))! }
            dest?.games = playedGames as! [Schedule] //self.fetchedTeams[lastSelectedTeam.row].teamSchedule as! [Schedule]
            dest?.teamName = self.fetchedTeams[lastSelectedTeam.row].teamName
            dest?.teamID = self.fetchedTeams[lastSelectedTeam.row].teamID
                        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Teams", style: .plain, target: nil, action: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if lastSelectedTeam.section != 0 {
            let lastCell = collectionView.cellForItem(at: lastSelectedTeam)
            lastCell?.layer.borderWidth = 0.1
            lastCell?.layer.borderColor = UIColor.lightGray.cgColor
        }
        teamID = Int(fetchedTeams[indexPath[0]-1].teamID)!
        teamName = fetchedTeams[indexPath[0]-1].teamName
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.green.cgColor
        lastSelectedTeam = indexPath
        showScheduleItem.isEnabled = true
        if showStandings == "Yes" {
            showPastGamesItem.isEnabled = true
        }
    }
}

private extension TeamsVC {
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
                print("Error in fetchData - Teams")
                return
        }
        self?.networkActivity.hide()
        self?.teamsView.reloadData()
        }
    }
}
