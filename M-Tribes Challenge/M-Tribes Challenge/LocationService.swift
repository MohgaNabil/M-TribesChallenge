//
//  LocationService.swift
//  M-Tribes Challenge
//
//  Created by Mohga Nabil on 10/12/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LocationService {
	private static var instance:LocationService?
	/// Singlton
	/// Constructor
	/// - Returns: instance of LocationService
	public static func getInstance() -> LocationService{
		guard instance != nil else {
			instance = LocationService()
			return instance!
		}
		return instance!
	}
	
	/// Load car locations from server
	///
	/// - Parameter completionHandler: locationsData and error details(if any)
	public func getLocations(completionHandler:@escaping (_ locationsData: [JSON]?,_ error: Error?) -> Void){
		let locationsServiceURI = "http://m-tribes.com/wp-content/uploads/coding-challenge/locations.json"
		Alamofire.request(locationsServiceURI).validate().responseJSON { (response) in
			switch response.result{
			case .success(let value):
				if let placemarks = JSON(value).dictionary?["placemarks"]{
					completionHandler(placemarks.array,nil)
				}else{
					completionHandler(nil ,nil)
				}
				break;
			
			case .failure(let err):
				completionHandler(nil,err)
				break;
			}
		}
	}
}
