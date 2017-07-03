//
//  MKMapViewDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print(view)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(view)
    }

    func addStudentInformationsToMap() {
        guard let studentInformations = studentInformations else {
            return
        }

        studentInformations.forEach { studentInformation in
            let coordinate = CLLocationCoordinate2D(latitude: studentInformation.latitude, longitude: studentInformation.longitude)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = studentInformation.fullName
            annotation.subtitle = studentInformation.mediaURL

            mapView.addAnnotation(annotation)
        }

    }
}
