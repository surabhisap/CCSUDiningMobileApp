//
//  CommonExtensions.swift
//  CCSUDining
//
//  Created by Surabhi Agnihotri on 2/25/19.
//  Copyright © 2019 CCSU. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class InspectableUIView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}


class InspectableUIButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
