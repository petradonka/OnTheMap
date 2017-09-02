//
//  AddStudentInformationViewController+MKMapViewDelegate.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.09.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation

import Foundation
import MapKit

extension AddStudentInformationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentInformationAnnotation {
            let identifier = "studentInformationAnnotationView"

            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequedView.annotation = annotation
                return dequedView
            } else {
                let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
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

    func showStudentInformationOnMap(_ studentInformation: StudentInformation) {
        addStudentInformationsToMap(shouldClear: true, studentInformations: [studentInformation])

        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude: studentInformation.latitude ?? 0,
                                                                                 longitude: studentInformation.longitude ?? 0),
                                             span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }
}

