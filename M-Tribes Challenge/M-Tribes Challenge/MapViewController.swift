//
//  MapViewController.swift
//  M-Tribes Challenge
//
//  Created by Mohga Nabil on 10/13/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

enum CarMode{
	case SINGLE, MULTIPLE
}

class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

	@IBOutlet weak var locationsMap: MKMapView!
	private var locationsInfo : [JSON]?
	var carMode : CarMode = .MULTIPLE
	var locationManager: CLLocationManager!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//Configure Map
		self.locationsMap.delegate = self
		self.locationsMap.setUserTrackingMode(.follow, animated: true)
		//Configure location
		self.locationManager = CLLocationManager()
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		self.renderMapAnnotations()
//		self.authorizeLocation()
    }

	/// cascade changes in model data
	///
	/// - Parameter notification: notification received with data
	func setLocationsInfo(notification:Notification){
		if let locationsInfo = notification.userInfo?["locationsData"]{
			self.locationsInfo = locationsInfo as? [JSON]
			self.renderMapAnnotations()
		}
	}

	/// add annotation to map
	func renderMapAnnotations(){
		if self.locationsMap != nil && self.locationsInfo != nil{
			if !self.locationsMap.annotations.isEmpty{
				self.locationsMap.removeAnnotations(self.locationsMap.annotations)
			}
			for userLocation in self.locationsInfo!{
				let locationAnnotation = MKPointAnnotation()
				let coordinates = userLocation["coordinates"].arrayValue
				locationAnnotation.coordinate = CLLocationCoordinate2DMake(coordinates[1].doubleValue, coordinates[0].doubleValue);
				locationAnnotation.title = userLocation["name"].stringValue
				locationAnnotation.subtitle = userLocation["address"].stringValue
				self.locationsMap.addAnnotation(locationAnnotation)
			}
		}
	}
	
	/// handle tapping a map annotation upon selection
	///
	/// - Parameters:
	///   - mapView
	///   - view: annotation view being selected
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if carMode == .SINGLE{
			self.renderMapAnnotations()
			carMode = .MULTIPLE
		}else{
			let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.tapAnnotationPin(gesture:)))
			view.addGestureRecognizer(tap)
			self.locationsMap.annotations.forEach({ (annotation) in
				guard view.annotation != nil && annotation.title! == view.annotation!.title! else{
					self.locationsMap.removeAnnotation(annotation)
					return
				}
			})
			carMode = .SINGLE
		}
	}
	
	
	/// handles tap gestures on map annotation upon deselection
	///
	/// - Parameter gesture: tap gesture
	func tapAnnotationPin(gesture: UITapGestureRecognizer){
		if gesture.view != nil && gesture.view is MKAnnotationView{
			let annotationView = gesture.view as! MKAnnotationView
			annotationView.removeGestureRecognizer(gesture)
			self.locationsMap.deselectAnnotation(annotationView.annotation!, animated: true)
		}
	}
	
//	func authorizeLocation(){
//		let status = CLLocationManager.authorizationStatus()
//		if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
//			locationManager.requestAlwaysAuthorization()
//			locationManager.requestWhenInUseAuthorization()
//		}
//		locationManager.startUpdatingLocation()
//		locationManager.startUpdatingHeading()
//	}
	
	/// fetches the user's current location
	///
	/// - Parameters:
	///   - mapView
	///   - userLocation
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
		
		self.locationsMap.setRegion(region, animated: true)
		
		let currentLocationAnnotation = MKPointAnnotation()
		currentLocationAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
		currentLocationAnnotation.title = "Current location"
		currentLocationAnnotation.subtitle = userLocation.subtitle
		self.locationsMap.addAnnotation(currentLocationAnnotation)

	}
//	
//	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		let userLocation:CLLocation = locations[0] as CLLocation
//
//		let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//		
//		self.locationsMap.setRegion(region, animated: true)
//		
//		let myAnnotation = MKPointAnnotation()
//		myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//		myAnnotation.title = "Current location"
//		self.locationsMap.addAnnotation(myAnnotation)
//	}
}
