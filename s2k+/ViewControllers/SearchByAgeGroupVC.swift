//
//  SearchByAgeGroupVC.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-26.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

enum genderList: Int, CaseIterable {
case Female
case Male
case Mixed

    var description: String {
        switch self {
        case .Female: return "Female"
        case .Male: return "Male"
        case .Mixed: return "Mixed"
        }
    }
}
enum ageGroupList: Int, CaseIterable {
    case U08
    case U09
    case U10
    case U11
    case U12
    case U13
    case U14
    case U15
    case U16
    case U17
    case U18
    case OPN
    var agDesc: String {
        switch self {
        case .U08:
            return "Under 8 (" + birthYear(birthyear: 8) + ")"
        case .U09:
            return "Under 9 (" + birthYear(birthyear: 9) + ")"
        case .U10:
            return "Under 10 (" + birthYear(birthyear: 10) + ")"
        case .U11:
            return "Under 11 (" + birthYear(birthyear: 11) + ")"
        case .U12:
            return "Under 12 (" + birthYear(birthyear: 12) + ")"
        case .U13:
            return "Under 13 (" + birthYear(birthyear: 13) + ")"
        case .U14:
            return "Under 14 (" + birthYear(birthyear: 14) + ")"
        case .U15:
            return "Under 15 (" + birthYear(birthyear: 15) + ")"
        case .U16:
            return "Under 16 (" + birthYear(birthyear: 16) + ")"
        case .U17:
            return "Under 17 (" + birthYear(birthyear: 17) + ")"
        case .U18:
            return "Under 18 (" + birthYear(birthyear: 18) + ")"
        case .OPN:
            return "Open (" + birthYear(birthyear: 19) + " ++)"
        }
    }
    func birthYear (birthyear: Int) -> String{
        String(Calendar.current.component(.year, from: Date()) - birthyear)
    }
}
class SearchByAgeGroupVC: UIViewController {

    var fetchedClubs = [Club]()
    private var request: AnyObject?
    var genderSelected = ""
    var ageGroupSelected = ""
    var clubSelected = ""
    var clubIDSelected = ""
    let helpVC: HelpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "helpvc") as! HelpVC
    @IBOutlet weak var pickerList: UIPickerView!
    @IBOutlet weak var selectedValues: UITextField!
    @IBAction func alternateSearchHelp(_ sender: Any) {
        helpVC.sourceID = "AlternateSearch"
        self.present(helpVC, animated: false, completion: nil)
    }
    
    @IBAction func findTeamsButton(_ sender: Any) {
        var errorMsg = ""
        if genderSelected == "" {errorMsg = "Your need to select a Team Gender."}
        if ageGroupSelected == "" {errorMsg += " You need to select an Age Group."}
        if clubSelected == "" {errorMsg += " You need to select a Club."}
        if errorMsg != "" {
            let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var styledButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styledButton.layer.cornerRadius = 10
        selectedValues.placeholder = "Select the Team Gender and Age Group"
        fetchData(source: DataSource.source, dataType: "2", dataTypeDetail: "0")
    }
}
extension SearchByAgeGroupVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let width = pickerView.frame.size.width
        var colWidth: CGFloat!
        if component == 0 {colWidth = width / 8}
        if component == 1 {colWidth = width / 3}
        if component == 2 {colWidth = width / 2}
        return colWidth
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = 0
        if component == 0 {rows = genderList.allCases.count}
        if component == 1 {rows = ageGroupList.allCases.count}
        if component == 2 {rows = fetchedClubs.count}
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerTitle = UILabel()
        if let v = view {
            pickerTitle = v as! UILabel
        }
        pickerTitle.font =  UIFont(name: "Helvetica Neue", size: 14)
        pickerTitle.textAlignment = .center
        if component == 0 {
            pickerTitle.text = genderList(rawValue: row)?.description
        }
        if component == 1 {
            pickerTitle.text = ageGroupList(rawValue: row)?.agDesc
        }
        if component == 2 {
            pickerTitle.textAlignment = .left
            pickerTitle.text = fetchedClubs[row].clubName
        }
        return pickerTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderSelected = genderList(rawValue: pickerView.selectedRow(inComponent: 0))!.description
        ageGroupSelected = ageGroupList(rawValue: pickerView.selectedRow(inComponent: 1))!.agDesc
        clubSelected = fetchedClubs[row].clubName
        clubIDSelected = fetchedClubs[row].clubID
        selectedValues.text = genderSelected + " - " + ageGroupSelected + " Club: " + clubSelected
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFoundTeamsVCSegue" {
            let dest = segue.destination as? FoundTeamsVC
            dest?.searchParams = genderSelected + ":" + ageGroupSelected + ":" + clubIDSelected
        }
    }
}

private extension SearchByAgeGroupVC {
    func fetchData(source: String,dataType: String, dataTypeDetail: String) {
        let queryItems = [
                URLQueryItem(name: "source", value: source), // 0=production, 1=sandbox
                URLQueryItem(name: "dataType", value: dataType),
                URLQueryItem(name: "dataTypeDetail", value: dataTypeDetail)]
        let clubRequest = APIRequest(resource: ClubResource(queryItems: queryItems))
        request = clubRequest
        clubRequest.load { [weak self] (clubs: [Club]?) in
            guard ((self?.fetchedClubs = clubs!) != nil)
                 else {
                    #warning ("proper reporting")
                    print("Error in fetchData - Clubs")
                    return
            }
            self?.pickerList.reloadAllComponents()
        }
    }
}
