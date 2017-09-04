//
//  BKForgotPasswordVC.swift
//  BloomKids
//
//  Created by Raj Sathyaseelan on 5/18/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

class BKForgotPasswordVC: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!

    @IBOutlet weak var inputTextFieldsHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
     //   inputTextFieldsHeightConstraint.constant = BKInputTextFieldHeight
        // Do any additional setup after loading the view.
        
    }
    
    let myGroup = DispatchGroup()
    
    @IBAction func resetBtnTapped(_ sender: UIButton) {
        
        SVProgressHUD.show()
        myGroup.enter()
    
        BKNetowrkTool.shared.forgotPassword(email: emailField.text!) { (success) in
            SVProgressHUD.dismiss()
            
            if (success) {
                
                SVProgressHUD.showSuccess(withStatus: "Password reset instructions sent to your email")
                //cancel to returnt to your kids screen.
                self.cancel(self)
            } else {
                SVProgressHUD.showSuccess(withStatus: "Error resetting password. Invalid email address")
            }
            
            self.myGroup.leave()
        }
        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.characters.count != 0 else {
            return false
        }
        
    
        return true
    }
    
    func resetPassword(_ email: String, securityCode: String, newPassword: String) {
        print("email:\(email) with new password:\(newPassword)")
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    func cancel(_ sender: Any) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }


}
