//
//  EventsCollectionViewCell.swift
//  GoMee
//
//  Created by Jaxon Stevens on 2/10/17.
//  Copyright © 2017 Jaxon Stevens. All rights reserved.
//

import UIKit

class EventsCollectionViewCell: UICollectionViewCell
{
    
    var event: Events! {
        didSet {
            updateUI()
        }
    }
    
   
    // Outlets for Buttons and Labels
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var BookLabel: UILabel!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
 
    
    
    fileprivate func updateUI()
    {
        TitleLabel?.text! = event.title
        DescriptionLabel?.text! = event.description
        BookLabel?.text! = event.book
        mainImageView?.image! = event.mainImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // Set the corner Radius of the cell
        self.layer.cornerRadius = 25
        
        // Clips to bounds makes the cell and image contained within cell clip the bounds of the height and width
        self.clipsToBounds = true
        
        
        


        
        
    }
    
    
    
}








