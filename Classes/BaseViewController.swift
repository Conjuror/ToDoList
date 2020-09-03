//
//  BaseViewController.swift
//  ToDoList
//
//  Created by Radu Ursache on 21/02/2019.
//  Copyright © 2019 Radu Ursache. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, Accessible {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupBindings()
        generateAccessibilityIdentifiers()
    }
    
    @objc func setupUI() {
        DispatchQueue.main.async {
            self.setupNavigationBar()
        }
    }

    func setupBindings() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupUI), name: Config.Notifications.themeUpdated, object: nil)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .black;
        self.navigationController?.navigationBar.barTintColor = Utils().getCurrentThemeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        UISearchBar.appearance().backgroundColor = Utils().getCurrentThemeColor()
    }
}
