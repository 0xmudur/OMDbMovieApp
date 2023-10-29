//
//  FilmCell.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    private let posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        title.numberOfLines = 0
        return title
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
        posterView.image = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: contentView.frame.width / 4,
                                  height: contentView.frame.height)
        titleLabel.frame = CGRect(x: posterView.frame.width + 10,
                                  y: 0,
                                  width: contentView.frame.size.width - posterView.frame.width,
                                  height: contentView.frame.size.height)
    }
    
    func setupCell(movie: Movie) {
        if let imageString = movie.poster, let imageURL = URL(string: imageString) {
            posterView.load(url: imageURL, placeholder: nil)
            titleLabel.text = movie.title ?? ""
        } else {
            posterView.load(url: URL(string: "")!, placeholder: nil)
            titleLabel.text = movie.title ?? ""
        }
    }
}
