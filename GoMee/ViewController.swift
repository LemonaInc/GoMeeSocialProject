//
//  ViewController.swift
//  JSWWDC16
//
//  Created by Jaxon Stevens on 4/19/16.
//  Copyright © 2016 Jaxon Stevens. All rights reserved.
//

import UIKit
import AccountKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
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
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}



class ViewController: UIViewController, UISearchBarDelegate {
    
  
    
    // Outlets & Controls
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // entries and parser
    
    
    var accountKit: AKFAccountKit!
    
    @IBOutlet weak var accountID: UILabel!
    @IBOutlet weak var labeltype: UILabel!
    @IBOutlet weak var phoneornumber: UILabel!
    
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







