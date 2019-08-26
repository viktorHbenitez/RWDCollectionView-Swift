//
//  CollectionViewCell.swift
//  CollectionView
//
//  Created by Brian on 7/17/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var selectionImage: UIImageView!
  
  var isEditing: Bool = false {
    didSet {
      // show the image circle
      selectionImage.isHidden = !isEditing
    }
  }
  
  override var isSelected: Bool { // var isSelected is property of the collectionViewCell
    didSet {
      if isEditing {
        selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
      }
    }
  }
  
  
}
