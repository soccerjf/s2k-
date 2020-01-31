//
//  DivisionVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-11.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class DivisionVC: UIViewController {
//MARK: read data from league selection
    var leagueName = ""
    var leagueID = ""
    var division = [Division]()
    let networkActivity = NetworkActivity(text: "Fetching Divisions")

    @IBOutlet weak var divisionView: UICollectionView!
    
    @IBAction func divisionHelp(_ sender: Any) {
        performSegue(withIdentifier: "DivisionHelpSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(networkActivity)
        self.divisionView.reloadData()
        self.networkActivity.hide()
    }
}

//MARK: populate the view
extension DivisionVC: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "divisionCell", for: indexPath) as! DivisionCell
        if let logo = cell.divisionLogo {
        if division[indexPath.row].divGender.lowercased().range(of:"f") != nil {
            cell.divisionGender.text = "Female"
            logo.image = UIImage(named:"female")
            cell.backgroundColor = UIColor(red:0.98, green:0.75, blue:0.84, alpha:1.0)
        } else {
            cell.divisionGender.text = "Male"
            logo.image = UIImage(named: "male")
            cell.backgroundColor = UIColor(red:0.75, green:0.86, blue:0.98, alpha:1.0)
        }
        }
        cell.divisionLogo.makeRoundCorners(byRadius: 20)
        cell.divisionName.text = division[indexPath.row].divName
        cell.divisionAgeGroup.text = division[indexPath.row].divAgeGroup
        if division[indexPath.row].showStandings == "Yes" {
            cell.divisionShowStandings.text = ""
        } else {
            cell.divisionShowStandings.text = "Standings N/A"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return division.count
    }

    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
      switch kind {
      case UICollectionView.elementKindSectionHeader:
        guard
          let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "\(DivisionSectionHeaderView.self)",
            for: indexPath) as? DivisionSectionHeaderView
          else {
            if let presented = self.presentedViewController {
                presented.removeFromParent()
              }
            if self.presentedViewController == nil {
                self.showAlert(title: "Error", message: "Invalid view type, please contact 8th Line Software, issues@8thline.org")
            }
            assert(false, "Invalid element type")
        }
        headerView.divisionSectionHeader.text = "Divisions for " + self.leagueName
        headerView.divisionSectionHeaderHelp.text = "Tap on division section to see teams"
        return headerView
      default:
        assert(false, "Invalid element type")
      }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTeamsVCSegue" {
            guard
              let selectedCell = sender as? UICollectionViewCell,
              let index = divisionView.indexPath(for: selectedCell)?.row, segue.identifier == "showTeamsVCSegue"
              else {
                if let presented = self.presentedViewController {
                    presented.removeFromParent()
                  }
                if self.presentedViewController == nil {
                    self.showAlert(title: "Error", message: "Invalid UICollectionViewCell, please contact 8th Line Software, issues@8thline.org")
                }
                return
            }
            let dest = segue.destination as? TeamsVC
            dest?.divID = division[index].divID
            dest?.divName = division[index].divName
            dest?.showStandings = division[index].showStandings
            dest?.divAgeGroup = division[index].divAgeGroup
            dest?.divGender = division[index].divGender
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Divisions", style: .plain, target: nil, action: nil)
        }
        if segue.identifier == "DivisionHelpSegue" {
            if let dest = segue.destination as? HelpVC {
                dest.leagueName = self.leagueName
                dest.sourceID = "Division"
            }
        }
    }
}
extension UIImageView {
   func makeRoundCorners(byRadius rad: CGFloat) {
      self.layer.cornerRadius = rad
      self.clipsToBounds = true
   }
}
