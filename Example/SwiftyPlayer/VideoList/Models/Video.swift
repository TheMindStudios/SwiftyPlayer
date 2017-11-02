//
//  Video.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

struct Video: VideoCellViewModel {
    let title: String
    let coverImage: UIImage
    let ownerImage: UIImage
    let url: URL?
    
    init(title: String = "MindStudios",
         coverImage: UIImage = UIImage(named: "coverImage")!,
         ownerImage: UIImage = UIImage(named: "ownerImage")!,
         url: URL?) {
        
        self.title = title
        self.coverImage = coverImage
        self.ownerImage = ownerImage
        self.url = url   
    }
}
