//
//  HomeViewModel.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import Foundation

protocol HomeViewModel: ViewModel {
    var stateClosure: ((ObservationType<HomeViewModelImplementation.UserInteraction, Error>) -> ())? { get set }
    var tableViewDataList: [HomeViewModelImplementation.RowType] { get set }
    var collectionViewDataList: [HomeViewModelImplementation.RowType] { get }
    var currentSearchText: String { get set }
    var tableViewCurrentPage: Int { get set }
    var collectionViewCurrentPage: Int { get set }
    var workItem: DispatchWorkItem? { get set }
    func fetchMovies(searchText: String, section: HomeViewModelImplementation.SectionType)
    func start()
    
}

class HomeViewModelImplementation: HomeViewModel {
    var stateClosure: ((ObservationType<HomeViewModelImplementation.UserInteraction, Error>) -> ())?
    private let dispatchGroup = DispatchGroup()
    var workItem: DispatchWorkItem?
    var tableViewDataList: [RowType] = []
    var collectionViewDataList: [RowType] = []
    var currentSearchText: String = "Star"
    var tableViewCurrentPage: Int = 1
    var collectionViewCurrentPage: Int = 1
    
    func start() {
        stateClosure?(.updateUI(data: .showLoading(start: true)))
        fetchMovies(searchText: currentSearchText, section: .vertical)
        fetchMovies(searchText: "Comedy", section: .horizontal)
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.stateClosure?(.updateUI(data: .showLoading(start: false)))
        }
    }
    
    func fetchMovies(searchText: String, section: SectionType) {
        dispatchGroup.enter()
        
        NetworkManager.shared.fetchMovies(search: searchText, page: section == .vertical ? tableViewCurrentPage : collectionViewCurrentPage) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.prepareUI(data: movies, section: section)
            case .failure(let error):
                self?.stateClosure?(.updateUI(data: .showAlert(message: error.localizedDescription)))
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func prepareUI(data: [Movie], section: SectionType) {
        if  !data.isEmpty {
            data.forEach { movie in
                switch section {
                case .horizontal:
                    collectionViewDataList.append(.movie(data: movie))
                case .vertical:
                    tableViewDataList.append(.movie(data: movie))
                }
            }
            stateClosure?(.updateUI(data: section == .horizontal ? .reloadHorizontalUI : .reloadVerticalUI))
        } else {
            tableViewDataList.removeAll()
            stateClosure?(.updateUI(data: .reloadVerticalUI))
            stateClosure?(.updateUI(data: .showAlert(message: "Movie Not Found")))
        }
    }
}

extension HomeViewModelImplementation {
    
    enum UserInteraction {
        case showLoading(start: Bool)
        case reloadVerticalUI
        case reloadHorizontalUI
        case showAlert(message: String)
    }
    
    enum SectionType {
        case vertical
        case horizontal
    }
    
    enum RowType {
        case movie(data: Movie)
        case activityIndicator
    }
}
