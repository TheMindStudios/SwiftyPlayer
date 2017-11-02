//
//  ReusableView.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
