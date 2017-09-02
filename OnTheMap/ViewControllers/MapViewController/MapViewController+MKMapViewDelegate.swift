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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? StudentInformationAnnotation else {
            return
        }

        guard let url = URL(string: annotation.studentInformation.mediaURL) else {
            showErrorMessage("\(annotation.studentInformation.mediaURL) is not a URL")
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentInformationAnnotation {
            let identifier = "studentInformationAnnotationView"
            
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequedView.annotation = annotation
                return dequedView
            } else {
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                return view
            }
        } else {
            return nil
        }
    }

    func addStudentInformationsToMap(shouldClear: Bool, studentInformations: [StudentInformation]) {
        if (shouldClear) {
            mapView.removeAnnotations(mapView.annotations)
        }

        let annotations = studentInformations.map { StudentInformationAnnotation.init(studentInformation: $0) }
        mapView.addAnnotations(annotations)
    }
}
