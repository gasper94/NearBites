//
//  MapViewController.swift
//  NearBites
//
//  Created by Simon on 12/8/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//


import UIKit
import YelpAPI
import Alamofire
import CDYelpFusionKit
import CoreLocation
import MapKit

class MapViewController: UIViewController
{
    @IBOutlet weak var map: MKMapView!
    var businessesReturned: Businesses!
    var annotation: [MKPointAnnotation] = []
    var tempAnnotation : MKPointAnnotation!
    lazy var annotationLauncher : AnnotationLauncher = {
        let launcher = AnnotationLauncher()
        launcher.mapViewController = self
        return launcher
    }()
    var currLatitude : CLLocationDegrees!
    var currLongitude : CLLocationDegrees!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBusniessLocations()
        self.map.showAnnotations(self.map.annotations, animated: true)
    }

    func addBusniessLocations()
    {
        if(businessesReturned.businesses.count == 0)
        {
            return
        }
        else
        {
            for business in businessesReturned.businesses
            {
                tempAnnotation = MKPointAnnotation()
                tempAnnotation.coordinate = CLLocationCoordinate2DMake((business.coordinates?.latitude)!, (business.coordinates?.longitude)!)
                tempAnnotation.title = business.name
                annotation.append(tempAnnotation)
            }
            map.addAnnotations(annotation)
        }
    }
    
    func showControllerForDirections(currBusiness: CDYelpBusiness) {
        let directionsViewController : DirectionsViewController = {
            let directionVC = DirectionsViewController()
            directionVC.restaurantInfo = currBusiness
            directionVC.currLatitude = currLatitude
            directionVC.currLongitude = currLongitude
            return directionVC
        }()
        navigationController?.pushViewController(directionsViewController, animated: true)
    }

}

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        annotationLauncher.businessesReturned = self.businessesReturned
        annotationLauncher.annotationView = view
        annotationLauncher.showInfo()
        for annotation in annotation
        {
            map.deselectAnnotation(annotation, animated: true)
        }
    }
}

