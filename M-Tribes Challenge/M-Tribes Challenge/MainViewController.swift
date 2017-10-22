//
//  MainViewController.swift
//  M-Tribes Challenge
//
//  Created by Mohga Nabil on 10/13/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UIChangesDelegate {
	func cascadeChange(locationsData: [JSON]?)
}
class MainViewController: UIViewController {

	@IBOutlet weak var locationLayoutOptions: UISegmentedControl!
	var mapViewController: MapViewController!
	var listViewController: ListTableViewController!
	@IBOutlet weak var layoutView: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapLayout") as! MapViewController
		listViewController = storyBoard.instantiateViewController(withIdentifier: "ListLayout") as! ListTableViewController
		listViewController.shared = self
		self.layoutView.addSubview(listViewController.view)
		listViewController.view.topAnchor.constraint(equalTo: self.layoutView.topAnchor).isActive = true
		self.view.layoutSubviews()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.loadLocations()
	}
    
	/// handle switching segments
	///
	/// - Parameter sender: selected segment
	@IBAction func layoutOptionChanged(_ sender: UISegmentedControl) {
		let index = sender.selectedSegmentIndex
		var viewController:UIViewController?
		for childView in self.layoutView.subviews{
			childView.removeFromSuperview()
		}
		switch index {
			case 0:
				viewController = listViewController
				break
			default:
				mapViewController.tableLocation = nil
				viewController = mapViewController
				break
		}
		self.layoutView.addSubview(viewController!.view)
		viewController!.view.topAnchor.constraint(equalTo: self.layoutView.topAnchor).isActive = true
		self.view.layoutSubviews()
	}
	
	/// loading locations from backend service and cascade model changes
	func loadLocations(){
		let locationService = LocationService.getInstance()
		locationService.getLocations { (locationsData, error) in
			if locationsData != nil && error == nil{
				self.listViewController.cascadeChange(locationsData: locationsData)
				self.mapViewController.cascadeChange(locationsData: locationsData)
			}else{
				let errAlert = UIAlertController(title: "Error", message: "Something went wrong, try again later", preferredStyle: .alert)
				errAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				DispatchQueue.main.async {
					self.present(errAlert, animated: true, completion: nil)
				}
			}
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	/// show selected location on map
	///
	/// - Parameter location
	func showLocationOnMap(location: JSON){
		mapViewController.tableLocation = location
		self.layoutView.addSubview(mapViewController.view)
		mapViewController.view.topAnchor.constraint(equalTo: self.layoutView.topAnchor).isActive = true
		self.locationLayoutOptions.selectedSegmentIndex = 1
	}
}

