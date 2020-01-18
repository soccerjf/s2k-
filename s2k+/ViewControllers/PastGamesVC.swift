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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pastGamesCell", for: indexPath) as! PastGamesCell
        if games[indexPath.row].gameHomeTeamID == teamID {
            cell.gameOpponent.text = games[indexPath.row].gameAwayTeam
            cell.gameSelectedTeamScore.text = games[indexPath.row].gameHomeTeamScore
            cell.gameOpponentTeamScore.text = games[indexPath.row].gameAwayTeamScore
        } else {
            cell.gameOpponent.text = games[indexPath.row].gameHomeTeam
            cell.gameSelectedTeamScore.text = games[indexPath.row].gameAwayTeamScore
            cell.gameOpponentTeamScore.text = games[indexPath.row].gameHomeTeamScore
        }
        cell.gameDate.text = games[indexPath.row].gameDate
        
        return cell
    }
    
    
}
