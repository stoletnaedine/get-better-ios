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
    
    func isConnectionAvailable() -> Bool {
        let reachability = try! Reachability()
        print(reachability.connection)
        return reachability.connection == .wifi
            || reachability.connection == .cellular
    }
    
    func checkConnect() {
        let reachability = try! Reachability()
        print(reachability.connection)
        if reachability.connection == .unavailable {
            NotificationCenter.default.post(name: .showNoInternetScreen, object: nil)
        }
    }
}
