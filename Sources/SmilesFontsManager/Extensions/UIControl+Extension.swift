//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/04/2023.
//

import Foundation
import UIKit

extension UIControl.State: CaseIterable {

    public typealias AllCases = [UIControl.State]

    public static var allCases: [UIControl.State] {
        var controlStates: [UIControl.State] = [.normal, .highlighted, .disabled, .selected, .application]
        if #available(iOS 9, *) {
            controlStates.append(.focused)
        }
        return controlStates
    }

}
