//
//  Logoutable.swift
//  OnTheMap
//
//  Created by Petra Donka on 23.07.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import Foundation
import UIKit

protocol LogoutDelegate {
    func logout()
    func dismissAfterLogout()
}

extension LogoutDelegate {
    func logout() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let user = appDelegate.user {
            user.logout(completion: { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.dismissAfterLogout()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
