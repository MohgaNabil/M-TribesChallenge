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

class MapViewController: UIViewController,MKMapViewDelegate {

	@IBOutlet weak var locationsMap: MKMapView!
	private var locationsInfo : [JSON]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.locationsMap.showsUserLocation = false
		self.renderMapAnnotations()
    }

	func setLocationsInfo(notification:Notification){
		if let locationsInfo = notification.userInfo?["locationsData"]{
			self.locationsInfo = locationsInfo as? [JSON]
			self.renderMapAnnotations()
		}
	}

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
	
}
