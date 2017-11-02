//
//  VideoCellViewModel.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

protocol VideoCellViewModel {
    
    var coverImage: UIImage { get }
    var ownerImage: UIImage { get }
    var title: String { get }
    
}
