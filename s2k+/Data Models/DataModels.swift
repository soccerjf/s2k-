//
//  DataModels.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-10.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import Foundation

struct DataSource {
    static let source = "0"  // 0 is for production database, 1 is for sandbox database
}

struct League {
    let leagueID: String
    let leagueName: String
    let leagueStart: String
    let leagueEnd: String
    let leagueLogoURL: URL
    let leagueSeeDate: String
    let divisions: [Division?]
}

extension League: Decodable {
    enum CodingKeys: String, CodingKey {
        case leagueID
        case leagueName
        case leagueStart
        case leagueEnd
        case leagueLogoURL
        case leagueSeeDate
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
    let divGameNite: String
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
        case divGameNite
    }
}

struct Team {
    let teamID: String
    let teamName: String
    let teamWins: String
    let teamLosses: String
    let teamTies: String
    let teamTotalGames: String
    let teamPoints: String
    let teamGoalsFor: String
    let teamGoalsAgainst: String
    let teamGoalDiff: String
    let teamLastGameA: String
    let teamLastGameB: String
    let teamLastGameC: String
    let teamLastGameD: String
    let teamLastGameE: String
    let teamLogo: URL?
    let teamLeague: String
    let teamDivision: String
    let teamClubName: String
    let teamSchedule: [Schedule?]
}

extension Team: Decodable {
    enum CodingKeys: String, CodingKey {
        case teamID
        case teamName
        case teamWins
        case teamLosses
        case teamTies
        case teamTotalGames
        case teamPoints
        case teamGoalsFor
        case teamGoalsAgainst
        case teamGoalDiff
        case teamLastGameA
        case teamLastGameB
        case teamLastGameC
        case teamLastGameD
        case teamLastGameE
        case teamLogo
        case teamLeague
        case teamDivision
        case teamClubName
        case teamSchedule
    }
}

struct Schedule {
    let gameID: String
    let gameNo: String
    let gameHomeTeamID: String
    let gameAwayTeamID: String
    let gameDate: String
    let gameTime: String
    let gameLocation: String
    let gameHomeTeam: String
    let gameAwayTeam: String
    let gameHomeTeamScore: String
    let gameAwayTeamScore: String
    let gameStatus: String
    let gameReported: String
    let gameActualStartTime: String
    let gameLat: String
    let gameLong: String
    let gameCup: String
    let gameOrgDate: String
    let gameTier: String
    let gameCity: String
    let gameAgeGroup: String
    let gameGender: String
    let gameLeague: String
}

extension Schedule: Decodable {
    enum CodingKeys: String, CodingKey {
        case gameID
        case gameNo
        case gameHomeTeamID
        case gameAwayTeamID
        case gameDate
        case gameTime
        case gameLocation
        case gameHomeTeam
        case gameAwayTeam
        case gameHomeTeamScore
        case gameAwayTeamScore
        case gameStatus
        case gameReported
        case gameActualStartTime
        case gameLat
        case gameLong
        case gameCup
        case gameOrgDate
        case gameTier
        case gameCity
        case gameAgeGroup
        case gameGender
        case gameLeague
    }
}
struct Club {
    let clubID: String
    let clubName: String
}
extension Club: Decodable {
    enum CodingKeys: String, CodingKey {
        case clubID
        case clubName
    }
}

struct Wrapper<T: Decodable>: Decodable {
    let items: [T]
}
