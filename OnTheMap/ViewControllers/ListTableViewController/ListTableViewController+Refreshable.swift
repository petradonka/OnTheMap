//
//  ListTableViewController+Refreshable.swift
//  OnTheMap
//
//  Created by Petra Donka on 26.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

extension ListTableViewController: Refreshable {
    func refresh(complete: @escaping () -> Void) {
        setupStudentInformations(andFetch: true, complete: complete)
    }
}
