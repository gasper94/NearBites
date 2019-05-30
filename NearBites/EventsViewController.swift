//
//  EventsViewController.swift
//  NearBites
//
//  Created by Ulises Martinez on 12/10/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//
import UIKit
import YelpAPI
import Alamofire
import CDYelpFusionKit
import CoreLocation
import MapKit

struct Event {
    var businesses = [CDYelpBusiness]()
}

class EventsViewController: UIViewController {
    
    
    var categories = [CDYelpBusinessCategoryFilter.restaurants]
    
    //Location manager
    let locationManager = CLLocationManager()
    
    //group is similar to a semaphore, Enter, Leave, Wait, Notify (for when completed)
    let group = DispatchGroup()
    
    // Search term been passed from Main View
    var term: String?
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    //holds all returned business from search
//    var businessesReturned = Businesses()
    
    //API client key. Remember to make a Constant.swift containing your own constant apikey this file will be ignored by github
    let yelpAPIClient = CDYelpAPIClient(apiKey: Constant.init().APIKey)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getBusinesses(yelpAPIClient: yelpAPIClient)
        
        //Location Delgate, Request for authorization, Update every 300 meters(around 1 block)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 300
        
    
    }
    
    
    func getBusinesses(yelpAPIClient: CDYelpAPIClient) {
        self.group.enter()
        
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        
        // Coordinates before search!
        print("lat : \(self.latitude) long: \(self.longitude)")
        
        yelpAPIClient.searchEvents(byLocale: nil,
                                   offset: nil,
                                   limit: 5,
                                   sortBy: .descending,
                                   sortOn: .popularity,
                                   categories: [.foodAndDrink],
                                   startDate: nil,
                                   endDate: nil,
                                   isFree: nil,
                                   location: nil,
                                   latitude: self.latitude,
                                   longitude: self.longitude,
                                   radius: 10000,
                                   excludedEvents: nil) { (response) in
            
            if let response = response,
                let events = response.events,
                events.count > 0 {
                //print(events.toJSON())
                
                
                for event in events{
                    print(event.name!)
                    print(event.attendingCount!)
                    print(event.category!)
                    print(event.description!)
                    print(event.interestedCount!)
                
                }
                
            }
        }
    }
}

extension EventsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            self.latitude = latitude
            self.longitude = longitude
            print(self.latitude)
            print(self.longitude)
            
        } else {
            print("No coordinates")
        }
    }
}




