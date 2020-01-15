//
//  TeamsVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-14.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class TeamsVC: UIViewController {
 // MARK: kick-off
    let networkActivity = NetworkActivity(text: "Fetching Teams")
    
    @IBOutlet weak var standingsLayout: TeamStandingsGrid! {
        didSet {
            standingsLayout.stickyRowsCount = 1
            standingsLayout.stickyColumnsCount = 1
        }
    }
    @IBOutlet weak var teamView: UICollectionView! {
        didSet {
            teamView.bounces = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(networkActivity)

    }
}
// MARK: - Collection view data source and delegate methods

extension TeamsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeamCell
        cell.titleLabel.text = "\(indexPath)"
        print("\(indexPath)")
        cell.backgroundColor = standingsLayout.isItemSticky(at: indexPath) ? .systemGroupedBackground : .white

        return cell
    }
}

extension TeamsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
