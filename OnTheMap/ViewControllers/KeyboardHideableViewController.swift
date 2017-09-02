//
//  OnTheMapViewController.swift
//  OnTheMap
//
//  Created by Petra Donka on 05.08.17.
//  Copyright © 2017 Petra Donka. All rights reserved.
//

import UIKit

class KeyboardHideableViewController: UIViewController {

    fileprivate var originalScrollViewContentInset: UIEdgeInsets?

    // MARK: - Event handling

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribe()
    }

    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    // MARK: - Dismiss keyboard if tapped outside of a text field

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches where type(of: touch.view) != UITextField.self {
            touch.view?.endEditing(true)
        }
    }

    // MARK: - Handle keyboard popping up

    @objc func keyboardWasShown(_ notification: Notification) {
        let keyboardFrame = getKeyboardFrame(fromNotification: notification)

        guard let firstResponder = UIResponder.currentFirstResponder(),
            let _ = firstResponder as? UITextField else {
            return
        }

        guard let scrollableSelf = self as? Scrollable,
            let scrollView = scrollableSelf.scrollView else {
                print("View is not Scrollable")
                return
        }

        if (originalScrollViewContentInset == nil) {
            originalScrollViewContentInset = scrollView.contentInset
        }

        let contentInset = UIEdgeInsetsMake(originalScrollViewContentInset?.top ?? 0,
                                            originalScrollViewContentInset?.left ?? 0,
                                            keyboardFrame?.height ?? 0 + 20,
                                            originalScrollViewContentInset?.right ?? 0)

        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillBeHidden(_ notification: Notification) {
        guard let scrollableSelf = self as? Scrollable,
            let scrollView = scrollableSelf.scrollView else {
            print("View does not conform to Scrollable")
            return
        }

        scrollView.contentInset = originalScrollViewContentInset ?? UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = originalScrollViewContentInset ?? UIEdgeInsets.zero
    }

    // MARK: Helpers

    fileprivate func getKeyboardFrame(fromNotification notification: Notification) -> CGRect? {
        let userInfo = notification.userInfo
        guard let rawValue = userInfo?[UIKeyboardFrameEndUserInfoKey],
            let frame = rawValue as? CGRect else {
                return nil
        }
        return frame
    }
}

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil

    public class func currentFirstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }

    @objc internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}

