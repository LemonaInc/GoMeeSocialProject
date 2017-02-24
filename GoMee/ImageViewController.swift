//
//  ImageViewController.swift
//  GoMee
//
//  Created by Jaxon Stevens on 2/10/17.
//  Copyright © 2017 Jaxon Stevens. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageView :UIImageView!
    @IBOutlet weak var imageView2 : UIImageView!

    
    override func viewDidLoad() {
        
        // Image 1 View
        self.view.addSubview(imageView)
        imageView.setImageFromUrl("https://s3-us-west-2.amazonaws.com/youtubeassets/taylor_swift_i_knew_you_were_trouble.jpg")
        
        // Image 2 View
        
        self.view.addSubview(imageView2)
        imageView2.setImageFromUrl("https://s3-us-west-2.amazonaws.com/youtubeassets/rebecca_black_profile.jpeg")
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

