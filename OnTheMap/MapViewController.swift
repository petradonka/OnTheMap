//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, StudentInformationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupStudentInformations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupStudentInformations() {
        // show loading indicator
        if let studentInformations = studentInformations {
            print(studentInformations.count)
        } else {
            fetchStudentInformations {
                switch $0 {
                case .success:
                    if let studentInformations = self.studentInformations {
                        print(studentInformations.count)
                        // hide loading indicator
                    }
                case .failure(let error):
                    print(error) // extract error handling (show error & hide loading indicator)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
