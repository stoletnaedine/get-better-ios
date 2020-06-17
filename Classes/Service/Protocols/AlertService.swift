//
// Created by Artur Islamgulov on 07.06.2020.
// Copyright (c) 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import SwiftEntryKit

protocol AlertService {
    
    func showPopUpMessage(icon: String, title: String, description: String)

    func showNotificationMessage(title: String, desc: String, textColor: EKColor, colors: [EKColor], image: UIImage?)

    func showErrorMessage(desc: String)

    func showSuccessMessage(desc: String)
}