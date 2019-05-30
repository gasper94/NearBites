//
//  BusinessDescriptionView.swift
//  NearBites
//
//  Created by Ulises Martinez on 11/30/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class BusinessDescriptionViewController: UIViewController {
   
    @IBOutlet weak var businessAdress: UILabel!
    @IBOutlet weak var review: UILabel!

    var reviewFromViewController: String!
    var address: String!
   

    override func viewDidLoad() {
        
        //getBusinesses(yelpAPIClient: yelpAPIClient)
        // Review
        review.sizeToFit()
        review.text = reviewFromViewController

    }
   
}
