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

	private var locationsInfo : [JSON]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
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
	
	func setLocationsInfo(notification:Notification){
		if let locationsInfo = notification.userInfo?["locationsData"]{
			self.locationsInfo = locationsInfo as? [JSON]
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
}

