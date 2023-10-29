//
//  ViewModelHelper.swift
//  OMDbMovieApp
//
//  Created by Muhammed Emin Aydın on 28.10.2023.
//

import Foundation

enum ObservationType<T, E> {
    case updateUI(data: T? = nil), error(error: E?)
}

protocol ViewModel {
    func start()
}
