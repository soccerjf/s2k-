//
//  DataModels.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-10.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import Foundation

struct League {
    let leagueID: String
    let leagueName: String
    let leagueStart: String
    let leagueEnd: String
    let leagueLogoURL: URL
    let divisions: [Division?]
}

extension League: Decodable {
    enum CodingKeys: String, CodingKey {
        case leagueID
        case leagueName
        case leagueStart
        case leagueEnd
        case leagueLogoURL
        case divisions
    }
}

struct Division {
    let divID: String
    let divName: String
    let divAgeGroup: String
    let divGender: String
    let showStandings: String
    let divStart: String
    let divEnd: String
}

extension Division: Decodable {
    enum CodingKeys: String, CodingKey {
        case divID
        case divName
        case divAgeGroup
        case divGender
        case showStandings
        case divStart
        case divEnd
    }
}

struct Team {
    let teamID: String
    let teamName: String
}

extension Team: Decodable {
    enum CodingKeys: String, CodingKey {
        case teamID
        case teamName
    }
}

struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
}
