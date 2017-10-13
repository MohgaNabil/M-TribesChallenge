//
//  ViewController.swift
//  M-Tribes Challenge
//
//  Created by Mohga Nabil on 10/12/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import SwiftyJSON
class ListTableViewController: UITableViewController {

	var locationsInfo : [JSON]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(UINib(nibName:"LocationTableViewCell",bundle:nil), forCellReuseIdentifier: "LocationInfoCell")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.loadLocations()
	}
	func loadLocations(){
		let locationService = LocationService.getInstance()
		locationService.getLocations { (locationsData, error) in
			if locationsData != nil && error == nil{
				self.locationsInfo = locationsData
				self.tableView.reloadData()
			}else{
			}
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard self.locationsInfo == nil else {
			return self.locationsInfo!.count
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LocationInfoCell", for: indexPath) as! LocationTableViewCell
		guard self.locationsInfo == nil else {
			let location = locationsInfo![indexPath.row].dictionaryValue
			cell.address.text = location["address"]!.stringValue
			cell.locationName.text = location["name"]!.stringValue
//			cell.fuel.text = location["fuel"]!.stringValue
//			cell.vin.text = location["vin"]!.stringValue
//			cell.ex_interior.text = "\(location["exterior"]!.stringValue))/\(String(describing: location["interior"]!.stringValue))"
			return cell
		}
		
		return cell

	}
}

