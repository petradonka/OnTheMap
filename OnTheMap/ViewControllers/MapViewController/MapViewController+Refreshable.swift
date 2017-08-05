//
//  MapViewController+Refreshable.swift
//  OnTheMap
//
//  Created by Petra Donka on 26.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

extension MapViewController: Refreshable {
    func refresh(complete: @escaping () -> Void) {
        refreshStudentInformations(complete: complete)
    }
}
