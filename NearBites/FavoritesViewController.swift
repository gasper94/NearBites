//
//  FavoritesViewController.swift
//  NearBites
//
//  Created by Paul Ancajima on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation
import CDYelpFusionKit


class FavoritesViewController: UIViewController {
    
    var favoritesList = [Business]()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        
        favoritesTableView.tableFooterView = UIView()
        //Fetech objects from core data
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        do {
            let favList = try PersistenceService.context.fetch(fetchRequest)
            self.favoritesList = favList
            self.favoritesTableView.reloadData()
        } catch { }
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoritesViewCell
        
        cell.restaurantName.text = favoritesList[indexPath.row].name
        cell.restaurantAddress.text = favoritesList[indexPath.row].address
        cell.phone.text = favoritesList[indexPath.row].phoneNumber
        cell.restaurantImage.image = UIImage(data: favoritesList[indexPath.row].image as! Data)
        cell.starRating.image = UIImage(data: favoritesList[indexPath.row].starRating as! Data)
        cell.long = favoritesList[indexPath.row].long
        cell.lat = favoritesList[indexPath.row].lat
        
        return cell
    }
    
    //Delete favorites
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //Must delete from coredata
            PersistenceService.context.delete(favoritesList[indexPath.row])
            favoritesList.remove(at: indexPath.row)
        }
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    func convertImageToNSdata(image: UIImageView) -> NSData {
        let returnData = image.image?.pngData()! as! NSData
        return returnData
    }
}

