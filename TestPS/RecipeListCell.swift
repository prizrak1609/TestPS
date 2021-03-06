//
//  RecipeListCell.swift
//  TestPS
//
//  Created by Dima Gubatenko on 22.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import AlamofireImage

final class RecipeListCell: UITableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var thumbnailImageView: UIImageView!
    @IBOutlet fileprivate weak var descriptionTextView: UITextView!

    var model: RecipeModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            if let url = URL(string: model.thumbnail) {
                thumbnailImageView.layer.borderWidth = 1
                thumbnailImageView.af_setImage(withURL: url)
            }
            descriptionTextView.text = model.ingredients
            descriptionTextView.sizeToFit()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.layer.borderWidth = 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionTextView.isScrollEnabled = false
        thumbnailImageView.layer.masksToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
    }
}
