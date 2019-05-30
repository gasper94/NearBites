//
//  BusinessCell.swift
//  NearBites
//
//  Created by Paul Ancajima on 11/22/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit


class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessRating: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    
    func setBusinessDescription(business: CDYelpBusiness){
        guard let image = business.imageUrl else { return }
        guard let rating = business.rating else { return }
        guard let distance = business.distance else { return }
        
        
        
        var url = URL(string: image.absoluteString)
        var data = try? Data(contentsOf: url!)
        businessImage.image = UIImage(data: data!)
        businessName.text = business.name
        businessRating.text = String(rating)
        businessDistance.text = String(distance * 0.0006)
    }
    
}


