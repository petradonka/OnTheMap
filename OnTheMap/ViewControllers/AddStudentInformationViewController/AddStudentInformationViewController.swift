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
    case waitingForLocationInput, findingLocation, waitingForMediaInput, submitting
}

class AddStudentInformationViewController: UIViewController {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var currentState = AddStudentInformationUIState.waitingForLocationInput

    fileprivate let addMediaPromptText = "Tap to add a URL"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setUI(forState: .waitingForLocationInput)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        if (currentState != .submitting) {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func findTapped(_ sender: Any) {
        setUI(forState: .waitingForMediaInput)
    }

    @IBAction func submitTapped(_ sender: Any) {
        setUI(forState: .submitting)
    }

    func setUI(forState state: AddStudentInformationUIState) {
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
        }
    }

}
