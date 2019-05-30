//
//  CollectionEventCell.swift
//  NearBites
//
//  Created by Ulises Martinez on 12/10/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//
import Foundation
import UIKit
import CDYelpFusionKit
import MapKit

class CollectionEventCell: UICollectionViewCell {


    
    
    func setBusinessDescription(Event: CDYelpBusiness){
        
        guard let name = Event.name else { return }
        
        print("hey")
        print(name)
        
    }



}
