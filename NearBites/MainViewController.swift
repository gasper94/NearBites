//
//  MainViewController.swift
//  NearBites
//
//  Created by Ulises Martinez on 11/28/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit
import CoreLocation

class MainViewController: UIViewController {

    
    @IBOutlet weak var Tittle: UILabel!
    
    @IBOutlet weak var yelpLogo: UIImageView!
    
    @IBAction func SearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchTransition", sender: self)
    }
    
    @IBOutlet weak var searchTerm: UISearchBar!
    
    //Location manager
    let locationManager = CLLocationManager()
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Delgate, Request for authorization, Update every 300 meters(around 1 block)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100

        yelpLogo.image = UIImage(named: "logo")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recieverVc = segue.destination as! ViewController
        //recieverVc.term = searchTerm.text!
        recieverVc.longitude = self.longitude
        recieverVc.latitude = self.latitude
        if let text = searchTerm.text {
            recieverVc.term = text
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            self.latitude = latitude
            self.longitude = longitude
        } else {
            print("No coordinates")
        }
    }
}

extension UIButton{
    override open func didMoveToWindow() {
        self.layer.cornerRadius = 15
    }
}

