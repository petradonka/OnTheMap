//
//  ViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 19.06.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        StudentLocation.studentLocations(limitTo: 10, skipping: 0, orderedBy: []) { (studentLocations) in
            print(studentLocations.count)

            StudentLocation.studentLocation(forUserId: studentLocations.first!.udacityUserId, completion: { (studentLocation) in
                if let studentLocation = studentLocation {
                    print (studentLocation)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

