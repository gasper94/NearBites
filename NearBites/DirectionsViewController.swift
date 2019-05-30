//
//  DirectionsViewController.swift
//  NearBites
//
//  Created by Simon on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import MapKit
import CDYelpFusionKit
import CoreLocation
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class DirectionsViewController: UIViewController, MGLMapViewDelegate
{
    var mapView: NavigationMapView!
    var directionsRoute: Route?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        
        view.addSubview(mapView)
        
        // Set the map view's delegate
        mapView.delegate = self
        
        // Allow the map to display the user's location
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        // Add a gesture recognizer to the map view
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
        
        restaurantLongitude = restaurantInfo.coordinates!.longitude
        restaurantLatitude = restaurantInfo.coordinates!.latitude
    }
    
    
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        //let point = sender.location(in: mapView)
        let coordinate = CLLocationCoordinate2D(latitude: restaurantLatitude, longitude: restaurantLongitude)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        
        // Calculate the route from the user's location to the set destination
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
    }
    
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    // Calculate route to be used for navigation
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }
    }
    
    // Implement the delegate method that allows annotations to show callouts when tapped
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: directionsRoute!)
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    
    //    let blue = UIColor(displayP3Red: 0.26309, green: 0.359486, blue: 0.445889, alpha: 1)
    var restaurantInfo : CDYelpBusiness!
    var currLatitude : CLLocationDegrees!
    var currLongitude : CLLocationDegrees!
    var restaurantLongitude : CLLocationDegrees!
    var restaurantLatitude : CLLocationDegrees!
    //    let mapView = MKMapView()
    //
    //
    //    override func viewDidLoad()
    //    {
    //        super.viewDidLoad()
    //
    //        restaurantLongitude = restaurantInfo.coordinates!.longitude
    //        restaurantLatitude = restaurantInfo.coordinates!.latitude
    //        var restaurantAnnotation : MKPointAnnotation{
    //            let annotation = MKPointAnnotation()
    //            annotation.coordinate = CLLocationCoordinate2DMake(restaurantLatitude!, restaurantLongitude!)
    //            annotation.title = restaurantInfo.name
    //            return annotation
    //        }
    //
    //        mapView.addAnnotations([restaurantAnnotation])
    //        mapView.showAnnotations(mapView.annotations, animated: true)
    //
    //        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(currLatitude, currLongitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    //        mapView.delegate = self
    //        showDirections()
    //    }
    //
    //    func showDirections()
    //    {
    //        let request = MKDirections.Request()
    //        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(currLatitude!, currLongitude!)))
    //        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(restaurantLatitude!, restaurantLongitude!)))
    //        request.requestsAlternateRoutes = false
    //        request.transportType = .automobile
    //
    //        let directions = MKDirections(request: request)
    //
    //        directions.calculate { [unowned self] response, error in
    //            guard let unwrappedResponse = response else { return }
    //
    //            for route in unwrappedResponse.routes {
    //                self.mapView.addOverlay(route.polyline)
    //                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    //            }
    //        }
    //    }
    //
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        self.view.backgroundColor = blue
    //        self.navigationItem.title = restaurantInfo.name
    //        let button1 = UIBarButtonItem(title: "Center", style: .plain, target: self, action: #selector(handleCenter))
    //        self.navigationItem.rightBarButtonItem  = button1
    //
    //
    //        super.viewWillAppear(animated)
    //
    //        let leftMargin:CGFloat = 0
    //        let topMargin:CGFloat = 88
    //        let mapWidth:CGFloat = view.frame.size.width
    //        let mapHeight:CGFloat = view.frame.size.height
    //
    //        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
    //
    //        mapView.mapType = MKMapType.standard
    //        mapView.isZoomEnabled = true
    //        mapView.isScrollEnabled = true
    //        mapView.showsUserLocation = true
    //
    //        // Or, if needed, we can position map in the center of the view
    //       // mapView.center = view.center
    //
    //        view.addSubview(mapView)
    //    }
    //
    //    @objc func handleCenter()
    //    {
    //        mapView.userTrackingMode = .follow
    //    }
    //
}

//extension DirectionsViewController : MKMapViewDelegate
//{
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = view.tintColor
//        renderer.lineWidth = 1.5
//        return renderer
//    }
//}
