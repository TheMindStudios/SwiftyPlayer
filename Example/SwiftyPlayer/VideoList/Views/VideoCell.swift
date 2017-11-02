//
//  VideoCell.swift
//  SwiftyPlayer_Example
//
//  Created by Sergey Degtyar on 11/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

final class VideoCell: UICollectionViewCell, ReusableView {
    
    private struct Constants {
        let coverImageAspectRatio: CGFloat = 16/9
        let coverImageInset: UIEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 69, right: 20)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var ownerImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    // MARK: - LifeCycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.image = nil
        ownerImageView.image = nil
        titleLabel.text = nil
    }

}

// MARK: - Public Methods

extension VideoCell {
    
    func fill(with viewModel: VideoCellViewModel) {
        
        coverImageView.image = viewModel.coverImage
        ownerImageView.image = viewModel.ownerImage
        titleLabel.text = viewModel.title
    }
    
    static func size(for width: CGFloat) -> CGSize {
        
        let constants = Constants()
        let height = width / constants.coverImageAspectRatio + constants.coverImageInset.top + constants.coverImageInset.bottom
        
        return CGSize(width: width, height: height)
    }
}
