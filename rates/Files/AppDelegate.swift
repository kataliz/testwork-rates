//
//  AppDelegate.swift
//  rates
//
//  Created by Chimit Zhanchipzhapov on 29/08/2018.
//  Copyright © 2018 Chimit Zhanchipzhapov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: Properties
    
    private var factory: RootFactory = RootFactory()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        (window?.rootViewController as? ConverterViewController)?.viewModel = factory.converterViewModel
        
        return true
    }
}

