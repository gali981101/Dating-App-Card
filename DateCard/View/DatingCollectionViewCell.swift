//
//  DatingCollectionViewCell.swift
//  DateCard
//
//  Created by Terry Jason on 2024/1/11.
//

import UIKit

protocol DatingCollectionCellDelegate {
    func didLikeButtonPressed(cell: DatingCollectionViewCell)
}

class DatingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    var delegate: DatingCollectionCellDelegate?
    
    var isLiked: Bool = false {
        didSet {
            likeButton.setImage(isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        delegate?.didLikeButtonPressed(cell: self)
    }
    
}
