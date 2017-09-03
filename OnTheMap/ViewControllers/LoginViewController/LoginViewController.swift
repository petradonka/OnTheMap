//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class LoginViewController: KeyboardHideableViewController, StudentInformationDelegate, Scrollable, ErrorHandlerDelegate {
    
    @IBOutlet var backgroundView: GradientView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        backgroundView.draw(CGRect(origin: CGPoint.init(x: 0, y: 0), size: size))
    }
    
    // MARK: - IBAction
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            login(username: username, password: password)
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        openSignupPage()
    }
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) {
        print(unwindSegue)
    }
    
    // MARK: - Login logic
    
    private func login(username: String, password: String) {
        setUI(isLoggingIn: true)
        Session.session(forUsername: username, andPassword: password) { result in
            switch result {
            case .success(let session):
                User.user(withSession: session, completion: { (result) in
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.saveNewUser(user)
                            self.finishLogin() {
                                self.setUI(isLoggingIn: false)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.setUI(isLoggingIn: false)
                            self.handleError(error)
                        }
                    }
                })
            case .failure(let error):
                DispatchQueue.main.async {
                    self.setUI(isLoggingIn: false)
                    self.handleError(error)
                }
            }
        }
    }
    
    private func saveNewUser(_ user: User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.user = user
        }
    }
    
    private func finishLogin(complete: @escaping () -> Void) {
        fetchStudentInformations {
            switch $0 {
            case .success:
                self.performSegue(withIdentifier: "afterLoginSegue", sender: self)
            case .failure(let error):
                self.handleError(error)
            }
            complete()
        }
    }
    
    private func openSignupPage() {
        if let url = URL(string: UdacityConfig.SignupURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func setUI(isLoggingIn: Bool) {
        usernameTextField.isEnabled = !isLoggingIn
        passwordTextField.isEnabled = !isLoggingIn
        loginButton.isEnabled = !isLoggingIn
        signupButton.isEnabled = !isLoggingIn
        
        switch isLoggingIn {
        case true:
            loadingActivityIndicator.startAnimating()
        case false:
            loadingActivityIndicator.stopAnimating()
        }
    }
    
}
