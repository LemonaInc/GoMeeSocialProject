//
//  ViewController.swift
//  GoMee
//
//  Created by Jaxon Stevens on 2/10/17.
//  Copyright © 2017 Jaxon Stevens. All rights reserved.
//



import UIKit
import AccountKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}



class ViewController: UIViewController, UISearchBarDelegate {
    
  
    
    
    // Facebook account kit 
    // Do not remove or it may break the app
    
    var accountKit: AKFAccountKit!
    
    @IBOutlet weak var accountID: UILabel!
    @IBOutlet weak var labeltype: UILabel!
    @IBOutlet weak var phoneornumber: UILabel!
    @IBOutlet weak var BookLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialization
        
        // Initiate Audio
    
        if accountKit == nil {
            
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                self.accountID.text = account?.accountID
                if account?.emailAddress?.characters.count > 0 {
                    //if the user is logged with email
                    self.labeltype.text = "Email Address"
                    self.phoneornumber.text = account!.emailAddress
                }
                else if account?.phoneNumber?.phoneNumber != nil {
                    //if the user is logged with phone
                    self.labeltype.text = "Phone Number"
                    self.phoneornumber.text = account!.phoneNumber?.stringRepresentation()
                }
                
            }
            
        }
        
    }
    
    
}







