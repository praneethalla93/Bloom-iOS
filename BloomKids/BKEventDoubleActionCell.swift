//
//  BKKidCellAction.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 7/2/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit

class BKEventDoubleActionCell: UITableViewCell {


    @IBOutlet weak var imgPlayer: UIImageView!
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var imgSportIcon: UIImageView!
    
    @IBOutlet weak var lblEventDateTime: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    
    @IBOutlet weak var btnPlayerAction1: UIButton!
    @IBOutlet weak var btnPlayerAction2: UIButton!
    @IBOutlet weak var lblActionStatus: UILabel!
    
    
    var tapAction1: ((UITableViewCell) -> Void)?
    var tapAction2: ((UITableViewCell) -> Void)?
    
    var activitySchedule: BKKidActivitySchedule? {
        
        didSet {
            
            if let activity = activitySchedule {
                
                //self.lblPlayerName.text = "\(activity.kidName) ID: \(String(describing: activity.id))"
                self.lblPlayerName.text = activity.kidName
                self.lblEventDateTime.text = "\(activity.date) \(activity.time)"
                
                self.lblEventLocation.text = activity.location
                
                self.btnPlayerAction1.isHidden = activity.btn1Hidden
                self.btnPlayerAction2.isHidden = activity.btn2Hidden
                self.lblActionStatus.isHidden = activity.actionLabelHidden
                self.lblActionStatus.text = activity.connectionStateDescription
                
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

    
}

