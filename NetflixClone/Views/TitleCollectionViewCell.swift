//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Chingiz on 20.02.24.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    public func configure(with model: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else {return}
        imageView.sd_setImage(with: url, completed: nil) 
    }
}
