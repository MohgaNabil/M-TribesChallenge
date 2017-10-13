//
//  MainViewController.swift
//  M-Tribes Challenge
//
//  Created by Mohga Nabil on 10/13/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
			viewController = mapViewController
			break
		}
		viewController!.view.center = self.layoutView.center
		self.layoutView.addSubview(viewController!.view)
	}

}

