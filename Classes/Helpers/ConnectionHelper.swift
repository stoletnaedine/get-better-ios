//
//  ConnectionHelper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import UIKit
import Reachability

class ConnectionHelper: UIViewController {
    
    private let alertService: AlertService = AlertServiceDefault()
    
    func isConnectionAvailable() -> Bool {
        let reachability = try! Reachability()
        print(reachability.connection)
        return reachability.connection != .unavailable
    }
    
    func checkConnectOnStartApp() {
        let reachability = try! Reachability()
        print(reachability.connection)
        if reachability.connection == .unavailable {
            NotificationCenter.default.post(name: .showNoInternetScreen, object: nil)
        }
    }
    
    func checkConnect() {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            alertService.showErrorMessage(desc: R.string.localizable.errorNoInternet())
        }
    }
}
