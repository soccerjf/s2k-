//
//  HelpVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-11.
//  Copyright © 2020 8th Line Software. All rights reserved.
//


import UIKit

class HelpVC: UIViewController {
    
    var sourceID = ""
    var htmlText: String!
    var leagueName: String!
    var teamName: String!

    @IBOutlet weak var helpText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if sourceID == "League" {
            htmlText = "LEAGUE VIEW Help<br /><br />S2K+ can provide you with game dates and results* for teams playing within the Peel Halton Soccer Association (PHSA).<br /> *Not applicable to development level teams that do not record game results.<br /><br />Tap on the League Logo to see the league's Divisions/Age Groups<br /><br />Not sure which league the team you're looking for is in? Then tap on the Alternate Lookup option on the bottom of the screen to search for your team another way.<br /><br />Just looking for a game to go see today?  Then tap on the Games Today option on the bottom of the screen.<br /><br />Tap anywhere on this screen to close it."
            helpText.text = htmlText.htmlToString
        }
        if sourceID == "Division" {
            htmlText = "DIVISION VIEW Help<br /><br />These are the Divisions/Age Groups in the " + leagueName + " League you chose<br />Tap on a Division Name or Logo to see the standings (if applicable) and schedule for the Division.<br /><br />Tap anywhere on this screen to close it."
            helpText.text = htmlText.htmlToString
        }
        if sourceID == "Team" {
            htmlText = "TEAM VIEW Help<br /><br />Teams within this division do not track game results.<br /><br />Tap on a Team Name to see the the Icon to select Upcoming Games<br /><br />Tap anywhere on this screen to close it."
             helpText.text = htmlText.htmlToString
        }
        if sourceID == "Standings" {
            htmlText = "STANDINGS VIEW Help<br /><br />Tap on a Team Name to see the Icons to select Upcoming Games or Past Game Results<br /><br />Expanded Titles<br /><br />Pts - Points<br />G - games played<br />W - Wins<br />T - Ties<br />L - Losses<br />GF - Goals For<br />GA - Goals Againsts<br />GD - Goal Difference<br /><br />Tap anywhere on this screen to close it."
             helpText.text = htmlText.htmlToString
        }
        if sourceID == "Schedule" {
            htmlText = "SCHEDULE VIEW Help<br /><br />These are the remaining games to be played for the " + teamName + "<br />team you chose<br />Tap on a game box and if the field for that game has the location co-ordinates set, a map icon will appear.  You can then tap on the icon to see a map of the field location.<br /><br />You can add the game to your calendar by tapping on the calendar icon, located by the game time.<br /><br />Tap anywhere on this screen to close it."
            helpText.text = htmlText.htmlToString
        }
        if sourceID == "Map" {
            htmlText = "MAP VIEW Help<br />Tap on the red marker to see more details about the game.<br />You can then tap on the blue circled i to get driving instructions from your current location to the field."
            helpText.text = htmlText.htmlToString
        }
        if sourceID == "AlternateSearch" {
            htmlText = "ALTERNATE SEARCH Help<br />If you don't know the league your team is in, you can search for the team provided you know the team's gender, date of birth of its players and the club the team is assoicated with. <br />Spin the controllers to select the correct values, then tap on the Find Team(s) button to search for your team."
            helpText.text = htmlText.htmlToString
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
