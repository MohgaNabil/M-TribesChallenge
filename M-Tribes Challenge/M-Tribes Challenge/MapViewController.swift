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

        // Do any additional setup after loading the view.
    }

	func setLocationsInfo(notification:Notification){
		if let locationsInfo = notification.userInfo?["locationsData"]{
			self.locationsInfo = locationsInfo as? [JSON]
		}
	}

}
