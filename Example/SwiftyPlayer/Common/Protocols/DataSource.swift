
//
//  DataSource.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol DataSource {
    
    associatedtype Item
    
    func numberOfSections() -> Int
    func numberOfObjects(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Item
}

extension DataSource {
    
    func numberOfSections() -> Int {
        return 1
    }
}
