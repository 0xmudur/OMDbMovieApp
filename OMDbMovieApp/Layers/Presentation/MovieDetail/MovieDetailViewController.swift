//
//  MovieDetailViewController.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 29.10.2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    weak var coordinatorDelegate: Coordinator?
    private (set) var movie: Movie?
    
    private let posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        title.textAlignment = .center
        return title
    }()
    
    private let yearLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        title.textAlignment = .center
        return title
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        setData()
    }
    
    func injectDependencies(data: Movie) {
        self.movie = data
    }
    
    private func configureUI() {
        view.addSubview(posterView)
        posterView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 20.0,
                          paddingLeft: 20.0,
                          paddingRight: 20.0)
        view.addSubview(titleLabel)
        titleLabel.anchor(top: posterView.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor,
                          paddingTop: 20.0,
                          paddingLeft: 20.0,
                          paddingRight: 20.0)
        view.addSubview(yearLabel)
        yearLabel.anchor(top: titleLabel.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20.0,
                         paddingLeft: 20.0,
                         paddingRight: 20.0)
    }
    
    private func setData() {
        if let imageString = movie?.poster, let imageURL = URL(string: imageString) {
            posterView.load(url: imageURL, placeholder: nil)
            titleLabel.text = movie?.title ?? ""
            yearLabel.text = movie?.year ?? ""
        } else {
            posterView.load(url: URL(string: "")!, placeholder: nil)
            titleLabel.text = movie?.title ?? ""
            yearLabel.text = movie?.year ?? ""
        }
    }
}
