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
    private var request: AnyObject?
    override func viewDidLoad() {
        print(searchParams)
        fetchData(source: DataSource.source, dataType: "3", dataTypeDetail: searchParams)
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
            
        }
    }
}
