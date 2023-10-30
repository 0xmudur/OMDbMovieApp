//
//  ViewController.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    weak var coordinatorDelegate: Coordinator?
    var homeViewModel: HomeViewModel?
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 8
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ComedyCell.self, forCellWithReuseIdentifier: ComedyCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSearchBar()
        configureTableView()
        configureCollectionView()
        configureActivityIndicator()
        addObservationListener()
        homeViewModel?.start()
        
    }
    
    func injectDependencies(viewModel: HomeViewModel) {
        self.homeViewModel = viewModel
    }
    
    private func configureSearchBar() {
        navigationItem.titleView = searchBar
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                         left: self.view.leftAnchor,
                         right: self.view.rightAnchor,
                         paddingTop: 20.0,
                         paddingLeft: 20.0,
                         paddingRight: 20.0,
                         height: view.frame.height * 6/10)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: self.tableView.bottomAnchor,
                              left: self.view.leftAnchor,
                              bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                              right: self.view.rightAnchor,
                              paddingTop: 20.0,
                              paddingLeft: 20.0,
                              paddingRight: 20.0)
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center(inView: view)
    }
    
    private func collectionViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func tableViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func showAlert(title: String, message: String, style: UIAlertController.Style) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.homeViewModel?.workItem?.cancel()
        self.tableView.isScrollEnabled = false
        
        let newWorkItem = DispatchWorkItem {
            if !searchText.isEmpty {
                self.homeViewModel?.tableViewDataList.removeAll()
                self.homeViewModel?.currentSearchText = searchText
                self.homeViewModel?.fetchMovies(searchText: searchText, section: .vertical)
                DispatchQueue.main.async {
                    self.tableView.isScrollEnabled = true
                }
            }
        }
        
        self.homeViewModel?.workItem = newWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: newWorkItem)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel?.tableViewDataList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case .movie(let data) = homeViewModel?.tableViewDataList[indexPath.row] {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
                cell.selectionStyle = .none
                cell.setupCell(movie: data)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let activityIndicator = UIActivityIndicatorView()
        if let lastCellIndex = homeViewModel?.tableViewDataList.count, lastCellIndex - 1 == indexPath.last {
            activityIndicator.startAnimating()
            tableView.tableFooterView = activityIndicator
            homeViewModel?.tableViewCurrentPage += 1
            homeViewModel?.fetchMovies(searchText: homeViewModel?.currentSearchText ?? "", section: .vertical)
        } else {
            activityIndicator.stopAnimating()
            tableView.tableFooterView = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .movie(let data) = homeViewModel?.tableViewDataList[indexPath.row],
           let coordinator = self.coordinatorDelegate as? HomeCoordinator {
                coordinator.navigateToMovieDetail(data: data)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.collectionViewDataList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch homeViewModel?.collectionViewDataList[indexPath.row] {
        case .movie(let data):
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComedyCell.identifier, for: indexPath) as? ComedyCell {
                cell.setupCell(imageString: data.poster ?? "")
                return cell
            }
        default: break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let lastCellIndex = homeViewModel?.collectionViewDataList.count, lastCellIndex - 1 == indexPath.last {
            homeViewModel?.collectionViewCurrentPage += 1
            homeViewModel?.fetchMovies(searchText: "Comedy", section: .horizontal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .movie(let data) = homeViewModel?.collectionViewDataList[indexPath.row],
           let coordinator = self.coordinatorDelegate as? HomeCoordinator {
                coordinator.navigateToMovieDetail(data: data)
        }
    }
}

extension HomeViewController {
    
    private func addObservationListener() {
        self.homeViewModel?.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.handleObservationListener(event: data)
            case .error(let error):
                self?.showAlert(title: "", message: error?.localizedDescription ?? "", style: .alert)
            }
        }
    }
    
    private func handleObservationListener(event: HomeViewModelImplementation.UserInteraction?) {
        switch event {
        case .showLoading(let start):
            start ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        case .reloadVerticalUI:
            tableViewReload()
        case .reloadHorizontalUI:
            collectionViewReload()
        case .showAlert(let message):
            self.showAlert(title: "", message: message, style: .alert)
        default:
            break
        }
    }
}


