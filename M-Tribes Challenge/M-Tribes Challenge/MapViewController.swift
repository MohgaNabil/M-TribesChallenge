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
	var shared:MainViewController?
	var tableLocation:JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
		//Configure Map
		self.locationsMap.delegate = self
		self.locationsMap.setUserTrackingMode(.follow, animated: true)
		
		//Configure location
		self.locationManager = CLLocationManager()
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.authorizeLocation()
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
			self.clearMap()

			if self.tableLocation == nil {
				for carLocation in self.locationsInfo!{
					let locationAnnotation = MKPointAnnotation()
					let coordinates = carLocation["coordinates"].arrayValue
					locationAnnotation.coordinate = CLLocationCoordinate2DMake(coordinates[1].doubleValue, coordinates[0].doubleValue);
					locationAnnotation.title = carLocation["name"].stringValue
					locationAnnotation.subtitle = carLocation["address"].stringValue
					self.locationsMap.addAnnotation(locationAnnotation)
				}
			}else {
				let locationAnnotation = MKPointAnnotation()
				let coordinates = self.tableLocation!["coordinates"].arrayValue
				locationAnnotation.coordinate = CLLocationCoordinate2DMake(coordinates[1].doubleValue, coordinates[0].doubleValue)
				locationAnnotation.title = self.tableLocation!["name"].stringValue
				locationAnnotation.subtitle = self.tableLocation!["address"].stringValue
				self.locationsMap.addAnnotation(locationAnnotation)
				
				let useLocationAnnotation = MKPointAnnotation()
				useLocationAnnotation.coordinate = self.locationManager.location!.coordinate
				useLocationAnnotation.title = self.locationsMap.userLocation.title
				useLocationAnnotation.subtitle = self.locationsMap.userLocation.subtitle
				self.locationsMap.addAnnotation(useLocationAnnotation)
			}
		}
	}
	
	/// handle tapping a map annotation upon selection
	///
	/// - Parameters:
	///   - mapView
	///   - view: annotation view being selected
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard self.tableLocation != nil else{
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
			return
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
	
	/// Authorize app to access current location
	func authorizeLocation(){
		let status = CLLocationManager.authorizationStatus()
		if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
			locationManager.requestAlwaysAuthorization()
			locationManager.requestWhenInUseAuthorization()
		}
		locationManager.startUpdatingLocation()
		locationManager.startUpdatingHeading()
	}
	
	/// fetches the user's current location
	///
	/// - Parameters:
	///   - mapView
	///   - userLocation
//	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//		let userLocationJson = ["name":"Current location", "Address":userLocation.subtitle as Any,"coordinates":[userLocation.coordinate.longitude,userLocation.coordinate.latitude] ]
//		self.locationsInfo?.append(JSON(userLocationJson))
//		
//		let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//		
//		self.locationsMap.setRegion(region, animated: true)
//		
//		let currentLocationAnnotation = MKPointAnnotation()
//		currentLocationAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//		currentLocationAnnotation.title = "Current location"
//		currentLocationAnnotation.subtitle = userLocation.subtitle
//		self.locationsMap.addAnnotation(currentLocationAnnotation)
//
//	}
	
	/// remove all map annotation
	func clearMap(){
		if !self.locationsMap.annotations.isEmpty{
			self.locationsMap.removeAnnotations(self.locationsMap.annotations)
		}
	}
	
	/// fetches the user's current location
	///
	/// - Parameters:
	///   - manager
	///   - locations
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.locationManager.stopUpdatingLocation()
		self.locationManager.stopUpdatingHeading()
		let userLocation = locations[0] as CLLocation
		let userLocationJson = ["name":"Current location", "Address": "", "coordinates":[userLocation.coordinate.longitude,userLocation.coordinate.latitude]] as [String : Any]
		self.locationsInfo?.append(JSON(userLocationJson))
		self.renderMapAnnotations()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.clearMap()
	}
}
