//
//  PastGamesVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-17.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class PastGamesVC: UIViewController {
    var teamName = ""
    var teamID = ""
    var games = [Schedule]()
    var cupGame = ""
    var homeOrAway = ""
    
    @IBOutlet weak var pastGamesView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Past Games for: " + teamName
    }
    
}
// MARK: - Colltion view data source and delegate methods

extension PastGamesVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if games[indexPath.row].gameCup != "N/A" {
            cupGame = " (Cup Game)"
        } else {
            cupGame = ""
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pastGamesCell", for: indexPath) as! PastGamesCell
        if games[indexPath.row].gameHomeTeamID == teamID {
            homeOrAway = " (Home)"
            cell.gameOpponent.text = games[indexPath.row].gameAwayTeam
            cell.gameSelectedTeamScore.text = games[indexPath.row].gameHomeTeamScore
            cell.gameOpponentTeamScore.text = games[indexPath.row].gameAwayTeamScore
            if Int(games[indexPath.row].gameHomeTeamScore)! > Int(games[indexPath.row].gameAwayTeamScore)! {
                cell.gameResults.text = "** WIN **"
                cell.gameResults.textColor = UIColor(red:0.18, green:0.44, blue:0.38, alpha:1.0)
            }
            if Int(games[indexPath.row].gameHomeTeamScore)! < Int(games[indexPath.row].gameAwayTeamScore)! {
                cell.gameResults.text = "LOSS"
                cell.gameResults.textColor = UIColor.orange
            }
            if Int(games[indexPath.row].gameHomeTeamScore) == Int(games[indexPath.row].gameAwayTeamScore) {
                cell.gameResults.text = "TIE"
                cell.gameResults.textColor = UIColor.gray
            }
        } else {
            homeOrAway = " (Away)"
            cell.gameOpponent.text = games[indexPath.row].gameHomeTeam
            cell.gameSelectedTeamScore.text = games[indexPath.row].gameAwayTeamScore
            cell.gameOpponentTeamScore.text = games[indexPath.row].gameHomeTeamScore
            if Int(games[indexPath.row].gameHomeTeamScore)! > Int(games[indexPath.row].gameAwayTeamScore)! {
                cell.gameResults.text = "LOSS"
                cell.gameResults.textColor = UIColor.orange
            }
            if Int(games[indexPath.row].gameHomeTeamScore)! < Int(games[indexPath.row].gameAwayTeamScore)! {
                cell.gameResults.text = "** WIN **"
                cell.gameResults.textColor = UIColor(red:0.18, green:0.44, blue:0.38, alpha:1.0)
            }
            if Int(games[indexPath.row].gameHomeTeamScore) == Int(games[indexPath.row].gameAwayTeamScore) {
                cell.gameResults.text = "TIE"
                cell.gameResults.textColor = UIColor.gray
            }
        }
        cell.gameResults.text! += cupGame
        cell.gameDate.text = games[indexPath.row].gameDate + homeOrAway
        
        return cell
    }
    
    
}
