//
//  UIViewControllerExtension.swift
//  SearchToBuy
//
//  Created by Jude Song on 8/13/25.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, okHandler: @escaping (() -> Void), cancelHandler: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) {_ in okHandler() }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) {_ in cancelHandler() }
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
  
    }
    
}
