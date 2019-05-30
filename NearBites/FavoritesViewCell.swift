//
//  FavoritesViewCell.swift
//  NearBites
//
//  Created by Paul Ancajima on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CDYelpFusionKit
import CoreLocation

class FavoritesViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var starRating: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var phone: UILabel!
    
    
    @IBAction func goButton(_ sender: UIButton) {
        let latitude:CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapitem.name = restaurantName.text
        mapitem.openInMaps(launchOptions: options)
    }
    var lat = 0.0
    var long = 0.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Image style!
        restaurantImage.layer.cornerRadius = 10
        restaurantImage.clipsToBounds = true
        restaurantImage.layer.borderColor = UIColor.black.cgColor
        restaurantImage.layer.borderWidth = 1
    }
}

