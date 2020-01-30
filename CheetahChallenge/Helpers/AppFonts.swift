//
//  AppFonts.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import UIKit
import SwiftUI

public enum AppFonts: String {
    case thin = "Roboto-Thin"
    case light = "Roboto-Light"
    case regular = "Roboto-Regular"
    case medium = "Roboto-Medium"
    case bold = "Roboto-Bold"
    
    func ofSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
