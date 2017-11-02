//
//  VideoDataSource.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

struct VideoDataSource {
    
    let items: [Video]
    
    init() {
        let audioFileName = "MindStudios"
        let subdirectory = "VideoFiles"
        let videoURL = Bundle.main.url(forResource: audioFileName, withExtension: "mp4", subdirectory: subdirectory)
        let video = Video(url: videoURL)
        
        items = [video, video, video, video, video]
    }
}

// MARK: - DataSource

extension VideoDataSource: DataSource {
    
    func numberOfObjects(in section: Int) -> Int {
        return items.count
    }
    
    func object(at indexPath: IndexPath) -> Video {
        return items[indexPath.item]
    }
}

