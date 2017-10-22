//
//  ViewController.swift
//  M-Tribes Challenge
//
//  Created by Mohga Nabil on 10/12/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import SwiftyJSON
class ListTableViewController: UITableViewController,UIChangesDelegate {
	public var locationsInfo : [JSON]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.dataSource = self
		self.tableView.register(UINib(nibName:"LocationTableViewCell",bundle:nil), forCellReuseIdentifier: "LocationInfoCell")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
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
			return cell
		}
		
		return cell

	}
	
	/// cascade changes in model data
	///
	/// - Parameter notification: notification received with data
	func  cascadeChange(locationsData: [JSON]?){
		if let locationsInfo = locationsData{
			self.locationsInfo = locationsInfo
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
}

