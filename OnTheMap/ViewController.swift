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

        StudentInformation.studentLocations(limitTo: 10, skipping: 0, orderedBy: []) { result in
            switch result {
            case .success(let studentLocations):
                print(studentLocations.count)

                StudentInformation.studentLocation(forUserId: studentLocations.first!.udacityUserId) { result in
                    switch result {
                    case .success(let studentLocation):
                        print(studentLocation)

                        studentLocation.save { result in
                            switch result {
                            case .success(_):
                                print("Student location was saved!")
                            case .failure(let error):
                                print("Student location could not be saved because of an error", error)
                            }
                        }
                    case .failure(let error):
                        switch error {
                        case .noResults:
                            print("No student location was found for this user ID!")
                        default:
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                switch error {
                case .requestError(let error):
                    print("REQUEST ERROR: \(error)")
                case .noResults:
                    print("No student locations were found!")
                default:
                    print(error)
                }
            }
        }


        Session.session(forUsername: "donkapetra@gmail.com", andPassword: "3ampiart120") { result in
            switch result {
            case .success(let session):
                print(session)

                User.user(withSession: session) { result in
                    switch result {
                    case .success(let user):
                        print(user)
                    case .failure(let error):
                        print(error)
                    }
                }

            case .failure(let error):
                switch error {
                case .loginError(let error):
                    // update ui
                    print("LOGIN FAILED: \(error)")
                case .requestError(let error):
                    // update ui
                    print(error)
                default:
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

