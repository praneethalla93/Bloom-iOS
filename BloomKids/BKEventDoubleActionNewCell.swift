//
//  BKKidCellAction.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 7/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKEventDoubleActionNewCell: UITableViewCell {
    
    //@IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var imgSportIcon: UIImageView!
    @IBOutlet weak var lblEventDay: UILabel!
    @IBOutlet weak var lblEventMonth: UILabel!
    @IBOutlet weak var lblCreatedBy: UILabel!
    @IBOutlet weak var lblEventAddress: UILabel!
    @IBOutlet weak var lblDisplayAction: UILabel!
    @IBOutlet weak var btnPlayerAction1: UIButton!
    @IBOutlet weak var btnPlayerAction2: UIButton!
    
    @IBOutlet weak var lblActionStatus: UILabel!
    
    var tapAction1: ((UITableViewCell) -> Void)?
    var tapAction2: ((UITableViewCell) -> Void)?
    
    var eventStatus: String? {
        
        didSet {
            
            if (eventStatus == "Pending") {
                activitySchedule?.actionLabelHidden = true
                //self.lblActionStatus.isHidden = true
                self.lblActionStatus.text = "Pending"
                
                activitySchedule?.btn1Hidden = false
                self.btnPlayerAction1.isHidden = false
                
                activitySchedule?.btn2Hidden = false
                self.btnPlayerAction2.isHidden = false
            } else if (eventStatus == "Upcoming") {
                //activitySchedule?.actionLabelHidden = true
                self.lblActionStatus.isHidden = true
                self.lblActionStatus.text = "Accepted"
                
                activitySchedule?.btn1Hidden = false
                self.btnPlayerAction1.isHidden = false
                
                activitySchedule?.btn2Hidden = false
                self.btnPlayerAction2.isHidden = false
                
            } else if (eventStatus == "Past") {
                self.lblActionStatus.isHidden = false
                self.lblActionStatus.text = "Completed"
                
                activitySchedule?.btn1Hidden = true
                self.btnPlayerAction1.isHidden = true
                
                activitySchedule?.btn2Hidden = true
                self.btnPlayerAction2.isHidden = true
            }
            
        }
   
    }

    var activitySchedule: BKKidActivitySchedule? {
        
        didSet {
            
            if let activity = activitySchedule {                
                //self.lblPlayerName.text = "\(activity.kidName) ID: \(String(describing: activity.id))"
                self.lblPlayerName.text = activity.kidName
                self.lblEventAddress.text = "On \(activity.date) \(activity.time) | \(activity.location)"
                self.lblCreatedBy.text = "Invited by \(activity.createdBy!)"
                self.imgSportIcon.image = BKSportImageDict[activity.sportName]
                
                //set event date views
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = NSTimeZone.local
                
                self.lblEventMonth.text = dateFormatter.string(from: activity.convertedDate)
                dateFormatter.dateFormat = "d"
                self.lblEventDay.text = dateFormatter.string(from: activity.convertedDate)
                
                if (activity.eventDecisionStatus == "U") {
                    setButton(button: btnPlayerAction1, selected: false)
                    setButton(button: btnPlayerAction2, selected: false)
                } else if (activity.eventDecisionStatus == "A") {
                    setButton(button: btnPlayerAction1, selected: true)
                    setButton(button: btnPlayerAction2, selected: false)
                } else if (activity.eventDecisionStatus == "D") {
                    setButton(button: btnPlayerAction1, selected: false)
                    setButton(button: btnPlayerAction2, selected: true)
                }
                
                /*
                self.btnPlayerAction1.isHidden = activity.btn1Hidden
                self.btnPlayerAction2.isHidden = activity.btn2Hidden
                self.lblActionStatus.isHidden = activity.actionLabelHidden
                self.lblActionStatus.text = activity.connectionStateDescription
                 */
                
                
                /*
                if activity.connectionState == BKEventConnectionSate.accepted.rawValue {
                    self.lblActionStatus.text = "Accepted"
                }
                else if activity.connectionState == BKEventConnectionSate.requestPending.rawValue {
                    self.lblActionStatus.text = "Pending"
                }
                else if activity.connectionState == BKEventConnectionSate.requestSent.rawValue {
                    
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date
                    formatter.dateFormat = "MM/dd/yy'T'HH:mm"
                    
                    if let eventDate = formatter.date(from: activity.date) {
                        
                        print( "event date \(eventDate)")
                      
                        if ( eventDate > Date() ) {
                            self.lblActionStatus.isHidden = true
                            self.btnPlayerAction1.isHidden = false
                            self.btnPlayerAction2.isHidden = false
                        } else {
                            self.lblActionStatus.text = "Expired"
                        }

                        
                    } else {
                        
                        formatter.dateFormat = "E, d MMM yyyy'T'h:mm a"
                        
                        if let newEventDate = formatter.date(from: activity.date) {
                            
                            print( "new event date \(newEventDate)")
                            
                            if ( newEventDate > Date() ) {
                                self.lblActionStatus.isHidden = true
                                self.btnPlayerAction1.isHidden = false
                                self.btnPlayerAction2.isHidden = false
                            } else {
                                self.lblActionStatus.text = "Expired"
                            }
                        }
                        
                    }
                 
                }
                else if activity.connectionState == BKEventConnectionSate.declined.rawValue {
                    self.lblActionStatus.text = "Declined"
                
                }
                */

            }
    
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnPlayerAction1.backgroundColor = .clear
        btnPlayerAction1.layer.cornerRadius = 10
        btnPlayerAction1.layer.borderWidth = 3
        btnPlayerAction1.layer.borderColor = BKGlobalTintColor.cgColor
        
        btnPlayerAction2.backgroundColor = .clear
        btnPlayerAction2.layer.cornerRadius = 10
        btnPlayerAction2.layer.borderWidth = 3
        btnPlayerAction2.layer.borderColor = BKGlobalTintColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btnPlayerctionButton1Tapped(_ sender: Any) {
        tapAction1?(self)
    }
    
    @IBAction func btnPlayerctionButton2Tapped(_ sender: Any) {
        tapAction2?(self)
        
    }
    
    func setButton(button: UIButton, selected: Bool) {
        
        if (selected ) {
            button.backgroundColor = BKGlobalTintColor
            button.layer.borderColor = BKGlobalTintColor.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
        } else {
            button.backgroundColor = .clear
            button.layer.borderColor = BKGlobalTintColor.cgColor
            button.setTitleColor(BKGlobalTintColor, for: .normal)
        }
    }

    
}

