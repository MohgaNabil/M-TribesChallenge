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

class MapViewController: UIViewController,MKMapViewDelegate {

	@IBOutlet weak var locationsMap: MKMapView!
	private var locationsInfo : [JSON]?
	var carMode : CarMode = .MULTIPLE
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.locationsMap.delegate = self
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
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if carMode == .SINGLE{
			self.renderMapAnnotations()
			view.setSelected(false, animated: true)
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
	
	
	func tapAnnotationPin(gesture: UITapGestureRecognizer){
		if gesture.view is MKAnnotationView{
			let annotationView = gesture.view as! MKAnnotationView
			annotationView.removeGestureRecognizer(gesture)
			self.locationsMap.deselectAnnotation(annotationView.annotation!, animated: true)
		}
	}
}
