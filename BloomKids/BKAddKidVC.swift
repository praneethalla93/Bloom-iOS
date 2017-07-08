//
//  BKAddKidVC.swift
//  BloomKids
//
//  Created by Andy Tong on 6/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol BKAddKidVCDelegate: class {
    func addKidVC(_ vc: BKAddKidVC, didAddkid kid: BKKidModel)
}


class BKAddKidVC: UITableViewController {
    weak var delegate: BKAddKidVCDelegate?
    
    
    fileprivate lazy var photoHeaderVC: BKPhotoHeaderVC = BKPhotoHeaderVC()
    
    fileprivate var genderStr: String?
    fileprivate var name: String?
    fileprivate var age: String?
    fileprivate var schoolPlace: BKPlaceModel?
    fileprivate weak var spotCell: BKSportCell?
    fileprivate var newKid: BKKidModel?
    
    let myGroup = DispatchGroup()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Kid"
        
        
        photoHeaderVC.willMove(toParentViewController: self)
        addChildViewController(photoHeaderVC)
        photoHeaderVC.didMove(toParentViewController: self)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("Cancel", for: .normal)
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.sizeToFit()
        leftBtn.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        myGroup.enter()
        
        //after successfull addking kid
        myGroup.notify(queue: .main) {
            
            
             if self.newKid != nil {
                print("\(String(describing: self.newKid?.kidName)) added successfully")
                SVProgressHUD.showSuccess(withStatus: "\(String(describing: self.newKid?.kidName)) added successfully")
                BKAuthTool.shared.finishedOnboarding()
                
                //cancel to returnt to your kids screen.
                self.cancel(self)
                
             } else{
                SVProgressHUD.showError(withStatus: "Failed to add kid")
             }
            
        }
        
    }
    
    func cancel(_ sender: Any) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addKid(_ sender: UIBarButtonItem) {
        
        guard let gender = genderStr,
        let name = name,
        let schoolPlace = schoolPlace,
        let sports = spotCell?.totalSports,
        let ageSr = age else {
            return
        }
        
        guard sports.count > 0 else {
            SVProgressHUD.showError(withStatus: "You have to choose a sport")
            return
        }
        
        let kidModel = BKKidModel(kidName: name, gender: gender, school: schoolPlace.placeName, age: ageSr, sports: sports)
    
        
        SVProgressHUD.show()
        
        BKNetowrkTool.shared.addKid(kidModel: kidModel) { (success, kidid) in
            
            SVProgressHUD.dismiss()
            self.myGroup.leave()
            
            if success {
                self.newKid = kidModel
                print ("success addking kid")
            }
            else {
                self.newKid = nil
                print ("failed addking kid")
            }
            
            
            /*
            
            if success {
                print("kid added with kidid:\(String(describing: kidid))")
                SVProgressHUD.showSuccess(withStatus: "Kid added")
                BKAuthTool.shared.finishedTutorial()
                //self.delegate?.addKidVC(self, didAddkid: kidModel)
                self.dismiss(animated: true, completion: nil)
            } else{
                SVProgressHUD.showError(withStatus: "Failed to add kid")
            }
            */
            
            
        }
        
        

    }
    


}

extension BKAddKidVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return handlePhotoHeader(tableView, indexPath)
        case 1:
            return handleName(tableView, indexPath)
        case 2:
            return handleGender(tableView, indexPath)
        case 3:
            return handleAge(tableView, indexPath)
        case 4:
            return handleSchool(tableView, indexPath)
        case 5:
            return handleSpots(tableView, indexPath)
        default:
            break
        }
    
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath)
        cell.backgroundColor = UIColor.random()
        return cell

    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200.0
        }else if indexPath.section == 5{
            return 200.0
        }else{
            return 50.0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for school search
        if indexPath.section == 4 {
            let searchVC = BKPlaceAutocompleteVC()
            searchVC.delegate = self
            searchVC.placeholder = "Enter your kid's school name"
            navigationController?.pushViewController(searchVC, animated: true)
        }

    }
    
}


extension BKAddKidVC {
    
    func handlePhotoHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKPhotoHeaderCellID, for: indexPath)
        
        photoHeaderVC.view.willMove(toSuperview: cell.contentView)
        cell.contentView.addSubview(photoHeaderVC.view)
        photoHeaderVC.view.frame = cell.contentView.bounds
        photoHeaderVC.view.didMoveToSuperview()
        return cell
    }
    
    func handleName(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath) as! BKSimpleCell
        
        cell.label.text = "Name"
        cell.textField.placeholder = ""
        
        cell.didChangeText = {[weak self] (text) in
            self?.name = text
        }
        
        return cell
    }
    
    func handleGender(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKGenderCellID, for: indexPath) as! BKGenderCell
        
        cell.didSelectGenderBtn = {[weak self] (genderStr) in
            self?.genderStr = genderStr
        }
        
        return cell
    }
    
    func handleAge(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSimpleCellID, for: indexPath) as! BKSimpleCell
        
        cell.label.text = "Age"
        cell.textField.placeholder = ""
        
        cell.didChangeText = {[weak self] (text) in
            self?.age = text
        }
        
        return cell
    }
    
    func handleSchool(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSchoolSearchCellID, for: indexPath) as! BKSchoolSearchCell
        
        cell.schoolNameField.text = (self.schoolPlace == nil) ? "" : self.schoolPlace!.placeName
        return cell
    }

    func handleSpots(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: BKSportCellID, for: indexPath) as! BKSportCell
        cell.navigationVC = navigationController
        spotCell = cell
        return cell
    }

}


extension BKAddKidVC: BKPlaceAutocompleteDelegate {
    func placeAutocompleteDidCancel(_ vc: BKPlaceAutocompleteVC) {
        navigationController?.popViewController(animated: true)
    }
    
    func placeAutocomplete(_ vc: BKPlaceAutocompleteVC, didSelectPlace place: BKPlaceModel) {
        self.schoolPlace = place
        navigationController?.popViewController(animated: true)
        self.tableView.reloadData()
    }
}




