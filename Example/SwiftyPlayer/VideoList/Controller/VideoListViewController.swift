//
//  VideoListViewController.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

final class VideoListViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    // MARK: - Private properties
    
    private let dataSource = VideoDataSource()
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: VideoCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: VideoCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension VideoListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfObjects(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = dataSource.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier, for: indexPath) as! VideoCell
        cell.fill(with: item)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension VideoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return VideoCell.size(for: collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate

extension VideoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let item = dataSource.object(at: indexPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let videoPlayerViewController = storyboard.instantiateViewController(withIdentifier: "FullscreenVideoPlayerViewController") as! FullscreenVideoPlayerViewController
        videoPlayerViewController.itemURL = item.url
        present(videoPlayerViewController, animated: true, completion: nil)
    }
}
