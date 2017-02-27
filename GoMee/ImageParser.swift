//
//  ImageParser.swift
//  GoMee
//
//  Created by Jaxon Stevens on 2/10/17.
//  Copyright © 2017 Jaxon Stevens. All rights reserved.
//
import UIKit
import AVFoundation
import AccountKit


//optionals were removed from the Swift Standard Libary so this fixes that issue for now.
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


fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}



class ImageParser: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
 {

    @IBOutlet var collectionview: UICollectionView!
    
    // MARK: - IBOutlets
    
   
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // Account Kit
    
    
    
    var accountKit: AKFAccountKit!
    
    // Facebook account kit outlets
    @IBOutlet weak var accountID: UILabel!
    @IBOutlet weak var labeltype: UILabel!
    @IBOutlet weak var phoneornumber: UILabel!
    
    
    
    // Vars
    
    
    
    
    // MARK: - UICollectionViewDataSource
    fileprivate var events = Events.createEvents()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
        
        
        
    }

    
    var images_cache = [String:UIImage]()
    var images = [String]()
    
    // This is the URL we parse the images from. The file is php file that contains an array of images to load into the view
    let link = "http://www.jsdev.info/images_php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Account Kit
        
        if accountKit == nil {
            
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                self.accountID.text = account?.accountID
                if account?.emailAddress?.characters.count > 0 {
                    
                    
                }
                
                
            }
        }
    
        
        get_json()
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        
        
    }
    
    // Set the name of the Collection View Cell in order to parse data from arrays in the cell
    fileprivate struct Storyboard {
        static let CellIdentifier = "Events Cell"
    }
    
    


    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! EventsCollectionViewCell
        
    
        if (images_cache[images[indexPath.row]] != nil)
        {
            cell.Image.image = images_cache[images[indexPath.row]]

        }
        else
        {
            load_image(images[indexPath.row], imageview:cell.Image)
        }
        
        cell.event = self.events[indexPath.item]
        
        

        return cell
    }
    
    
    // 
    


    

   internal func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        // Number of sections
        return 1
    }
    
    
    
    func load_image(_ link:String, imageview:UIImageView)
    {
        
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 10

        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                
                return
            }
            
 
            var image = UIImage(data: data!)
            
            if (image != nil)
            {
                
                
                func set_image()
                {
                    self.images_cache[link] = image
                    imageview.image = image
                }
  
                
                DispatchQueue.main.async(execute: set_image)
                
            }
            
        }) 
        
        task.resume()
        
    }

    


    func extract_json_data(_ data:Data)
    {
        let json: Any?
        
        do
        {
            json = try JSONSerialization.jsonObject(with: data, options: [])
            
        }
        catch
        {
            print("error")
            return
        }
        
        guard let images_array = json! as? NSArray else
        {
            print("error")
            return
        }
        
        for j in 0 ..< images_array.count
        {
            images.append(images_array[j] as! String)
        }
        
        DispatchQueue.main.async(execute: refresh)
    }
    
    
    
    func refresh()
    {
        self.collectionview.reloadData()
    }
    

    func get_json()
    {
     
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.timeoutInterval = 10
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response, error == nil else {
                
                return
            }
           

            self.extract_json_data(data!)
            
        }) 
        
        task.resume()
        
    }
    
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        // Return in order to prevent a crash
        return self.images.count & self.events.count

    }

}










