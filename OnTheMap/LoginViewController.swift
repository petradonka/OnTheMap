//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 02.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, StudentInformationDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            login(username: username, password: password)
        }
    }

    @IBAction func signupButtonPressed(_ sender: Any) {
    }

    // MARK: - Login logic

    private func login(username: String, password: String) {
        Session.session(forUsername: username, andPassword: password) { result in
            switch result {
            case .success(let session):
                print(session)
                User.user(withSession: session, completion: { (result) in
                    switch result {
                    case .success(let user):
                        DispatchQueue.main.async {
                            self.saveNewUser(user)
                            self.finishLogin()
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                print(error)
            }
        }
    }

    private func saveNewUser(_ user: User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.user = user
            print(user)
        }
    }

    private func finishLogin() {
        fetchStudentInformations {
            switch $0 {
            case .success:
                self.performSegue(withIdentifier: "afterLoginSegue", sender: self)
            case .failure(let error):
                print(error)
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
