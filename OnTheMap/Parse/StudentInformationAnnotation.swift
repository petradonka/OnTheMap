//
//  StudentInformation+MKAnnotation.swift
//  OnTheMap
//
//  Created by Petra Donka on 03.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import MapKit

class StudentInformationAnnotation: MKPointAnnotation {
    var studentInformation: StudentInformation

    init(studentInformation: StudentInformation) {
        self.studentInformation = studentInformation

        super.init()

        coordinate = CLLocationCoordinate2D(latitude: studentInformation.latitude, longitude: studentInformation.longitude)
        title = studentInformation.fullName
        subtitle = studentInformation.mediaURL
    }
}
