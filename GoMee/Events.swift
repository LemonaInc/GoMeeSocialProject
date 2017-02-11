//
//  Events.swift
//  GoMee
//
//  Created by Jaxon Stevens on 2/10/17.
//  Copyright © 2017 Jaxon Stevens. All rights reserved.
//


import UIKit


// Create Events class that handels all the input to the Collection View Cell
class Events
{
    
    // Define title of cell
    var title = ""
    var book = ""
    
    // Define description of the cell
    var description = ""
    var numberOfMembers = 0
    var numberOfPosts = 0
    // Define main image displayed on the cell
    var mainImage: UIImage!
    
    init(title: String, description: String, book: String, mainImage: UIImage!)
    {
        self.title = title
        self.book = book
        self.description = description
        self.mainImage = mainImage
        numberOfMembers = 1
        numberOfPosts = 1
    }
    
    // This is static Data that is used to populate the cells in the collection view controller. We need to change this from static data to dynamic that is from a JSON file or from a array that is parsed into the cell.
    static func createEvents() -> [Events]
    {
        return [
        
        
        Events(title: "Concert", description: "Chainsmokers Concert", book: "Book Concert", mainImage: UIImage(named: "Concert")!),

            
        Events(title: "LightHouse Park", description: "Outdoors Activity", book: "Book Activity",  mainImage: UIImage(named: "Sky")!),
        
        Events(title: "Hike", description: "Hike in the woods", book: "Book Activity", mainImage:  UIImage(named: "Hike")!),
        
        Events(title: "Party", description: "A party to remember", book: "Attend Party", mainImage: UIImage(named: "Party")!),
        
        Events(title: "Hike", description: "Hike to the beach",book: "RVSP",  mainImage: UIImage(named: "Bridge")!),
        
        
        
        
    ]
}



}

