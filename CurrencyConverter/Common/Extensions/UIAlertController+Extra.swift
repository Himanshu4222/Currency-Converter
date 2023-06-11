//
//  UIAlertController+Extra.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//

import UIKit

@objc extension UIAlertController {
    
    convenience init(title pTitle: String?, message pMessage: String?, actionSheet pActionSheet: Bool = false) {
        self.init(title: pTitle, message: pMessage, preferredStyle: (pActionSheet) ? .actionSheet : .alert)
    }
    
    class func alertController(title: String? = nil, message: String? = nil, actionSheet: Bool = false) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: (actionSheet) ? .actionSheet : .alert)
    }
    
    func addAction(_ title: String, withHandler handler: (() -> Void)? = nil) {
        addActionWithTitle(title: title, style: .default, handler: handler)
    }
    
    func setActionColour(colour: UIColor, title: String) {
        for action in self.actions {
            if action.title == title {
                action.setValue(colour, forKey: "titleTextColor")
            }
        }
    }
    
    func addDestructiveAction(_ title: String, withHandler handler: (() -> Void)? = nil) {
        addActionWithTitle(title: title, style: .destructive, handler: handler)
    }
    
    func addCancelAction(_ title: String? = nil, handler: (() -> Void)? = nil) {
        let cancelTitle = title == nil ? "Cancel" : title!
        addActionWithTitle(title: cancelTitle, style: .cancel, handler: handler)
    }
    
    private func addActionWithTitle(title: String, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil) {
        addAction(UIAlertAction(title: title, style: style, handler: { action in
            if let theHandler = handler {
                theHandler()
            }
        }))
    }
            
    class func showAlert(title: String? = nil, message: String? = nil, from: UIViewController, completion: (() -> Void)? = nil) {
        let theAlert = UIAlertController.alertController(title: title, message: message)
        theAlert.addCancelAction("OK", handler: completion)
        theAlert.presentFrom(from)
    }
    
    class func showAlertFrom(_ from: UIViewController, withTitle title: String?, withMessage message: String?, withCancelActionTitle cancelActionTitle: String? = nil, withAactionTitle actionTitle: String? = nil, withCompletion completion: (() -> Void)? = nil) {
        let theAlert = UIAlertController(title: title, message: message)
        theAlert.addCancelAction(cancelActionTitle)
        theAlert.addAction(actionTitle ?? "OK", withHandler: completion)
        theAlert.presentFrom(from)
    }

    class func showErrorAlert(withError error: Error, fromViewControler viewController: UIViewController) {
        showAlert(title: "Error", message: error.localizedDescription, from: viewController)
    }
    
    @objc @discardableResult
    class func errorAlert(withMessage message: String, fromViewControler viewController: UIViewController, andCompletion completion: (() -> Void)? = nil) -> UIAlertController {
        let theAlert = alertController(title: "Error", message: message)
        theAlert.addActionWithTitle(title: "OK", handler: completion)
        theAlert.presentFrom(viewController)
        return theAlert
     }
    
    class func yb_showDestructiveConfirmWithTitle(_ title: String, withMessage message: String?, withButton button: String, fromViewController from: UIViewController, withAction action: @escaping () -> Void) {
        let theAlert = UIAlertController(title: title, message: message)
        theAlert.addDestructiveAction(button, withHandler: action)
        theAlert.addCancelAction()
        theAlert.presentFrom(from)
    }
    
    class func showConfirm(title: String? = nil, message: String? = nil, button: String = "OK", style: UIAlertAction.Style = .default, from: UIViewController, action: @escaping () -> Void) {
        let theAlert = UIAlertController.alertController(title: title, message: message)
        theAlert.addActionWithTitle(title: button, style: style, handler: action)
        theAlert.addCancelAction()
        theAlert.presentFrom(from)
    }
    
    func presentFrom(_ from: UIViewController) {
        view.tintColor = from.view.tintColor
        from.present(self, animated: true)
    }
}
