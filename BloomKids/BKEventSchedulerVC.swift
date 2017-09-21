//
//  BKEventSchedulerVC
//  BloomKids
//
//  Created by Raj Sathyaseelan on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Foundation

protocol BKEventSchedulerDelegate: class {
    func scheduleEventVC(_ vc: BKEventSchedulerVC, eventReveivingKid kid: BKKidModel)
}

class BKEventSchedulerVC: UITableViewController {
    weak var delegate: BKEventSchedulerDelegate?
    var eventReceivingKid: BKKidModel?
    
    fileprivate lazy var photoHeaderVC: BKPhotoHeaderVC = BKPhotoHeaderVC()
    fileprivate var eventLocation: BKPlaceModel?
    fileprivate var eventSport: String?
    fileprivate var eventDate: String?
    
    fileprivate var newKid: BKKidModel?
    fileprivate var locationTextField: UITextField?
    fileprivate var sportTextField: UITextField?
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSport: UILabel!
    
    fileprivate var scheduleBtn: UIButton?
    //fileprivate var eventDatePicker: UIDatePicker?
    fileprivate var eventScheduleStatus = false
    
    var dpShowDateVisible = false
    
    let myGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PlayDate"
        self.tableView.backgroundColor = UIColor.lightGray
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("Cancel", for: .normal)
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.sizeToFit()
        leftBtn.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.scheduleBtn = UIButton(type: .custom)
        scheduleBtn?.setTitle("Schedule", for: .normal)
        scheduleBtn?.setTitleColor(UIColor.white, for: .normal)
        scheduleBtn?.sizeToFit()
        scheduleBtn?.addTarget(self, action: #selector(schedule(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scheduleBtn!)
        myGroup.enter()
        scheduleBtn?.setTitleColor(UIColor.gray, for: .disabled)
        scheduleBtn?.isEnabled = false
        
        //TODO: after successfull scheduling event
        myGroup.notify(queue: .main) {
            
            if self.eventScheduleStatus {
                print("\(String(describing: self.newKid?.kidName)) added successfully")
                SVProgressHUD.showSuccess(withStatus: "Playdate successfully scheduled with \(String(describing: self.newKid?.kidName))")
                //cancel to return to playdate screen
                self.cancel(self)
                
            } else{
                SVProgressHUD.showError(withStatus: "Event Schedule failed. Try again.")
                
            }

        }

    }
    
    func editingChanged() {
        
        guard
            let location = lblLocation?.text, !location.isEmpty, !(location == "Add Location"),
            let sport = self.eventSport, !sport.isEmpty, !(sport == "Add Sport")
        else {
                scheduleBtn?.isEnabled = false
                return
        }
        
        scheduleBtn?.isEnabled = true
    }
    
    @objc func cancel(_ sender: Any) {
        
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func schedule(_ sender: UIBarButtonItem) {
        
        print ("schedule button clicked")
        SVProgressHUD.show()
        
        let currentKid = BKNetowrkTool.shared.myCurrentKid
        var location = ""
        
        if let eventLoc = self.eventLocation {
            location = "\( eventLoc.placeName) \r\n \(eventLoc.secondary!)"
        }
        
        //let eventDate = self.eventDatePicker?.date
        let eventDate = Date()
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "MM/dd/yy"
        let eventDateStr = formatter.string(from: eventDate)
        
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "HH:mm"
        // again convert your date to string
        let eventTimeStr = formatter.string(from: eventDate)
        
        BKNetowrkTool.shared.scheduleEvent(kidName: (currentKid?.kidName)!, kidId: (currentKid?.id)!, sportName: self.eventSport!, location: location, responderKidId: (eventReceivingKid?.id)!, eventDate: eventDateStr, eventTime: eventTimeStr) { (success) in
            
            SVProgressHUD.dismiss()
            self.myGroup.leave()
            self.eventScheduleStatus = success
            
            if success {
                print ("success scheduling event")
                
            }
            else {
                print ("failure scheduling event")
            }

        }
        
    }
    


}

extension BKEventSchedulerVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section : \(section) : row = 1.")
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return handleStartDate(tableView, indexPath)
        case 1:
            return handleLocation(tableView, indexPath)
        case 2:
            return handleEventSports(tableView, indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
            cell.backgroundColor = UIColor.random()
            print("Default row created")
            return cell
        }
    
    }
    
   

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var width: CGFloat
        
        if indexPath.section == 0 {
            width = 70.0
        }
        else if indexPath.section == 1 {
            width = 220.0
        }
        else if (indexPath.section == 2 || indexPath.section == 3) {
            width = 50.00
        } else{
            width = 50.00
        }

        return width
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for school search
        if indexPath.section == 0 {
            toggleShowDateDatepicker()
        }
        else if indexPath.section == 2 {
            let searchVC = BKPlaceAutocompleteVC()
            searchVC.delegate = self
            searchVC.placeholder = "Enter event location"
            navigationController?.pushViewController(searchVC, animated: true)
        }
        else if indexPath.section == 3 {
            let eventSportVC = BKEventSportSelectVC()
            eventSportVC.delegate = self
            navigationController?.pushViewController(eventSportVC, animated: true)
        }
        else {
            print("section row selecte :: \(indexPath.section) \(indexPath.row)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        if section == 0 {
            
            if eventReceivingKid != nil {
                sectionTitle = "Schedule play date with \(eventReceivingKid!.kidName)"
            } else {
                sectionTitle = "Schedule play date"
            }
            
        }
        return sectionTitle
    }

}

extension BKEventSchedulerVC {
    
    func handleStartDate(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKStartDateCellID, for: indexPath) as! BKEventStartDateCell
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
        //cell.startDatePicker.minimumDate = tomorrow
        
        print ("date :: \(Date())")
        
        //cell.startDatePicker.maximumDate = cell.startDatePicker.maximumDate! + 180
        //self.eventDatePicker =  cell.startDatePicker
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func handleLocation(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKLocationCellID, for: indexPath) as! BKEventLocationCell
     
        //cell.txtEventLocation.text = (self.eventLocation == nil) ? "" : self.eventLocation?.placeName
        cell.lblLocation.text = (self.eventLocation == nil) ? "" : self.eventLocation?.placeName
        
        // Assign the tap action which will be executed when the user taps the UIButton
        
        cell.tapAction = { [weak self] (cell) in
            self?.showAlertForRow(section: 1, row: tableView.indexPath(for: cell)!.row)
        }
        
        //locationTextField = cell.txtEventLocation
        //cell.accessoryType = .disclosureIndicator
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func handleEventSports(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BKEventSportCellID, for: indexPath) as!
            BKEventSportCell
        
        //cell.textSport.text = (self.eventSport == nil) ? "" : self.eventSport
        cell.lblSport.text = (self.eventSport == nil) ? "" : self.eventSport
        
        // Assign the tap action which will be executed when the user taps the UIButton
        cell.tapAction = { [weak self] (cell) in
            self?.showAlertForRow(section: 2, row: tableView.indexPath(for: cell)!.row)
        }
        
        //sportTextField = cell.textSport
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    func showAlertForRow(section: Int, row: Int, decision: String="") {
        
        if ( section == 1 ) {
            let searchVC = BKPlaceAutocompleteVC()
            searchVC.delegate = self
            searchVC.placeholder = "Enter event location"
            navigationController?.pushViewController(searchVC, animated: true)
        }
        else if ( section == 2 ) {
            let eventSportVC = BKEventSportSelectVC()
            eventSportVC.delegate = self
            navigationController?.pushViewController(eventSportVC, animated: true)
        }
        
    }
    
    func toggleShowDateDatepicker () {
        self.dpShowDateVisible = !dpShowDateVisible
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }



}

extension BKEventSchedulerVC: BKPlaceAutocompleteDelegate {
    
    func placeAutocompleteDidCancel(_ vc: BKPlaceAutocompleteVC) {
        editingChanged()
        locationTextField?.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    func placeAutocomplete(_ vc: BKPlaceAutocompleteVC, didSelectPlace place: BKPlaceModel) {
        self.eventLocation = place
        self.tableView.reloadData()
        locationTextField?.resignFirstResponder()
        editingChanged()
        navigationController?.popViewController(animated: true)
    }

}

extension BKEventSchedulerVC: BKEventSportSelectDelegate {
    
    func sportDidCancel(_ vc: BKEventSportSelectVC) {
        editingChanged()
        sportTextField?.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    func sportSelect(_ vc: BKEventSportSelectVC, didChooseSport sportName: String?) {
        self.eventSport = sportName
        print("Event Sport selected")
        //sportTextField?.resignFirstResponder()
        self.tableView.reloadData()
        editingChanged()
        navigationController?.popViewController(animated: true)
    }

}
