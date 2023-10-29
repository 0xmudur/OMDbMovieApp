//
//  ComedyCell.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

class ComedyCell: UICollectionViewCell {
    static let identifier = "ComedyCell"
    
    private let posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
        posterView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterView.frame = CGRect(x: 0,
                                  y: 0,
                                  width : contentView.frame.size.width,
                                  height: contentView.frame.size.height)
    }
    
    func setupCell(imageString: String) {
        guard let imageURL = URL(string: imageString) else { return }
        posterView.load(url: imageURL, placeholder: nil)
    }
}
