//
//  AddStudentInformationViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.09.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit
import MapKit

enum AddStudentInformationUIState {
    case waitingForLocationInput, findingLocation, findFailed, waitingForMediaInput, submitting, submitFailed
}

class AddStudentInformationViewController: UIViewController, ErrorHandlerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var currentState = AddStudentInformationUIState.waitingForLocationInput

    fileprivate let addMediaPromptText = "Tap to add a URL"

    var studentInformation: StudentInformation!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let user = appDelegate.user else {
            fatalError("No user, even though a new StudentInformation needs to be added")
        }

        topTextField.delegate = self
        centerTextField.delegate = self

        studentInformation = StudentInformation(udacityUserId: user.userId, firstName: user.firstName, lastName: user.lastName)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setUI(forState: .waitingForLocationInput)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        if (currentState != .submitting) {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func findTapped(_ sender: Any) {
        guard let address = centerTextField.text, address.characters.count > 0 else {
            showErrorMessage("You forgot to add your location")
            return
        }

        setUI(forState: .findingLocation)
        studentInformation.mapString = address
        findCoordinatesForAddress(address) { location in
            guard let location = location else {
                print("No location")
                self.setUI(forState: .findFailed)
                return
            }
            self.studentInformation.latitude = location.coordinate.latitude
            self.studentInformation.longitude = location.coordinate.longitude
            self.setUI(forState: .waitingForMediaInput)
            self.showStudentInformationOnMap(self.studentInformation)
        }
    }

    @IBAction func submitTapped(_ sender: Any) {
        guard let mediaURL = topTextField.text, mediaURL.characters.count > 0 else {
            showErrorMessage("You forgot to add a URL")
            return
        }

        setUI(forState: .submitting)

        studentInformation.mediaURL = mediaURL
        studentInformation.send { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.setUI(forState: .submitFailed)
                    self.handleError(error)
                }
            }
        }

    }

    private func findCoordinatesForAddress(_ address: String, completion: @escaping (CLLocation?) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (location, error) in
            guard let location = location else {
                self.showErrorMessage(error!.localizedDescription)
                completion(nil)
                return
            }

            completion(location[0].location)
        })
    }

    private func setUI(forState state: AddStudentInformationUIState) {
        currentState = state

        switch state {
        case .waitingForLocationInput:
            topTextField.isEnabled = false
            centerTextField.isEnabled = true
            findButton.isEnabled = true
            submitButton.isEnabled = false

        case .findingLocation:
            centerTextField.isEnabled = false
            findButton.isEnabled = false

            if (!activityIndicator.isAnimating) {
                activityIndicator.startAnimating()
            }

        case .findFailed:
            centerTextField.isEnabled = true
            findButton.isEnabled = true
            if (activityIndicator.isAnimating) {
                activityIndicator.stopAnimating()
            }

        case .waitingForMediaInput:
            findButton.isEnabled = false

            if (activityIndicator.isAnimating) {
                activityIndicator.stopAnimating()
            }

            UIView.animate(withDuration: 0.3, animations: {
                let distanceToMove = self.view.bounds.width
                self.centerTextField.frame.origin.x -= distanceToMove
                self.findButton.frame.origin.x += distanceToMove
            }, completion: { _ in
                self.centerTextField.removeFromSuperview()
                self.findButton.removeFromSuperview()
                self.submitButton.isEnabled = true
                self.topTextField.text = nil
                self.topTextField.placeholder = self.addMediaPromptText
                self.topTextField.isEnabled = true
            })

        case .submitting:
            resignFirstResponder()
            topTextField.isEnabled = false
            submitButton.isEnabled = false
            if (!activityIndicator.isAnimating) {
                activityIndicator.activityIndicatorViewStyle = .gray
                activityIndicator.startAnimating()
            }

        case .submitFailed:
            topTextField.isEnabled = true
            submitButton.isEnabled = true
            if (activityIndicator.isAnimating) {
                activityIndicator.stopAnimating()
            }
        }
    }

}
