//
//  MovieCell.swift
//  PaxelMiniTest
//
//  Created by Febbry Ramadhan on 12/22/18.
//  Copyright © 2018 Febbry Ramadhan. All rights reserved.
//
import UIKit
import DisplaySwitcher
import AlamofireImage

private let avatarListLayoutSize: CGFloat = 80.0

class MovieCell: UICollectionViewCell, CellInterface {
    
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var backgroundGradientView: UIView!
    @IBOutlet fileprivate weak var nameListLabel: UILabel!
    @IBOutlet fileprivate weak var nameGridLabel: UILabel!
    @IBOutlet weak var statisticLabel: UILabel!
    
    // avatarImageView constraints
    @IBOutlet fileprivate weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var avatarImageViewHeightConstraint: NSLayoutConstraint!
    
    // nameListLabel constraints
    @IBOutlet var nameListLabelLeadingConstraint: NSLayoutConstraint! {
        didSet {
            initialLabelsLeadingConstraintValue = nameListLabelLeadingConstraint.constant
        }
    }
    
    // statisticLabel constraints
    @IBOutlet weak var statisticLabelLeadingConstraint: NSLayoutConstraint!
    
    fileprivate var avatarGridLayoutSize: CGFloat = 0.0
    fileprivate var initialLabelsLeadingConstraintValue: CGFloat = 0.0
    
    func bind(_ movie: Movie) {
        
        if let image_url = movie.image_url {
            let url = URL(string: image_url)
            avatarImageView.af_setImage(
                withURL: url!,
                placeholderImage: UIImage(named: "poster-placeholder.png"),
                filter: nil,
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.5),
                runImageTransitionIfCached: false)
        }
        
        

        nameListLabel.text = movie.title
        nameGridLabel.text = movie.title
        let release_date = "Release date: \(movie.release_date) • "
        let rating = "Vote average: \(movie.vote_average) • "
        
        statisticLabel.text = release_date + rating
    }
    
    func setupGridLayoutConstraints(_ transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil((cellWidth - avatarListLayoutSize) * transitionProgress + avatarListLayoutSize)
        avatarImageViewWidthConstraint.constant = ceil(avatarImageViewHeightConstraint.constant)
        nameListLabelLeadingConstraint.constant = -avatarImageViewWidthConstraint.constant * transitionProgress + initialLabelsLeadingConstraintValue
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = 1 - transitionProgress
        statisticLabel.alpha = 1 - transitionProgress
        nameGridLabel.isHidden = false
    }
    
    func setupListLayoutConstraints(_ transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil(avatarGridLayoutSize - (avatarGridLayoutSize - avatarListLayoutSize) * transitionProgress)
        avatarImageViewWidthConstraint.constant = avatarImageViewHeightConstraint.constant
        nameListLabelLeadingConstraint.constant = avatarImageViewWidthConstraint.constant * transitionProgress + (initialLabelsLeadingConstraintValue - avatarImageViewHeightConstraint.constant)
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameGridLabel.isHidden = true
        nameListLabel.alpha = transitionProgress
        statisticLabel.alpha = transitionProgress
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? DisplaySwitchLayoutAttributes {
            if attributes.transitionProgress > 0 {
                if attributes.layoutState == .grid {
                    setupGridLayoutConstraints(attributes.transitionProgress, cellWidth: attributes.nextLayoutCellFrame.width)
                    avatarGridLayoutSize = attributes.nextLayoutCellFrame.width
                } else {
                    setupListLayoutConstraints(attributes.transitionProgress, cellWidth: attributes.nextLayoutCellFrame.width)
                }
            }
        }
    }
}
