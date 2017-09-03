//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, ErrorHandlerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupStudentInformations()
    }
}
