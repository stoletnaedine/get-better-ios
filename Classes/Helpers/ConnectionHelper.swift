//
//  ConnectionHelper.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 27.05.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Reachability

class ConnectionHelper {
    
    private let alertService: AlertServiceProtocol = AlertService()
    
    func isConnect() -> Bool {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            alertService.showErrorMessage(desc: R.string.localizable.errorNoInternet())
        }
        return reachability.connection != .unavailable
    }

    func checkConnect() {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            alertService.showErrorMessage(desc: R.string.localizable.errorNoInternet())
        }
    }
    
}
