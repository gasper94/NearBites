//
//  AnnotationInfo.swift
//  NearBites
//
//  Created by Simon on 12/9/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import MapKit
import CDYelpFusionKit

class Info: NSObject {
    let name: String
    let imageName: String?
    
    init(name: String) {
        self.name = name
        self.imageName = nil
    }
    
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class AnnotationLauncher : NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    var businessesReturned : Businesses!
    var currBusiness : CDYelpBusiness!
    var annotationView: MKAnnotationView!
    var currBusinessInfo : [Info]!
    let TextCellId = "TextCellId"
    let ImageCellId = "ImageCellId"
    let RatingCellId = "RatingCellId"
    let cellHeight : CGFloat = 30
    let blackView = UIView()
    var mapViewController : MapViewController?
    let collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    func showInfo()
    {
        setCurrBusiness()
        let name : String = currBusiness.name!
        let address : String = (currBusiness.location?.addressOne)!
        let city : String = (currBusiness.location?.city)!
        let state : String = (currBusiness.location?.state)!
        let zip : String = (currBusiness.location?.zipCode)!
        let fulladdress : String = address + ", " + city + " " + state + ", " + zip
        let phone : String = currBusiness.displayPhone!
        currBusinessInfo = [Info.init(name: name), Info.init(name: fulladdress), Info.init(name: "Rating"), Info.init(name: phone, imageName: "phone"), Info.init(name: "Directions", imageName:"direction")]
        
        if let window = UIApplication.shared.keyWindow
        {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(collectionView)
            let height: CGFloat = cellHeight * CGFloat(currBusinessInfo.count) + cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            collectionView.backgroundColor = UIColor(displayP3Red: 0.26309, green: 0.359486, blue: 0.445889, alpha: 1)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:{
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }, completion: nil)
        }
        collectionView.reloadData()
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    
    func handleSelection(info: Info) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }
        }) { (completed: Bool) in
                if info.name == "Directions" {
                    self.mapViewController?.showControllerForDirections(currBusiness: self.currBusiness)
                }
                else if info.imageName == "phone"
                {
                    if let phoneString = self.currBusiness.phone
                    {
                        guard let number = URL(string: "tel://" + phoneString) else { return }
                        UIApplication.shared.open(number)
                    }
                }
            }
    }
    
    
    func setCurrBusiness()
    {
        for businesses in self.businessesReturned!.businesses
        {
            if ((annotationView.annotation?.title)!! == businesses.name)
            {
                self.currBusiness = businesses
                return
            }
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return currBusinessInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let info = currBusinessInfo[indexPath.item]
        if(info.imageName == nil && info.name != "Rating")
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCellId, for: indexPath) as! TextCell
            cell.info = info
            return cell
        }
        else if(info.name == "Rating")
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCellId, for: indexPath) as! RatingCell
            cell.rating = currBusiness.rating
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellId, for: indexPath) as! ImageCell
            cell.info = info
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selection = currBusinessInfo[indexPath.item]
        handleSelection(info: selection)
                
    }
    
    override init()
    {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextCell.self, forCellWithReuseIdentifier: TextCellId)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCellId)
        collectionView.register(RatingCell.self, forCellWithReuseIdentifier: RatingCellId)
    }

}
