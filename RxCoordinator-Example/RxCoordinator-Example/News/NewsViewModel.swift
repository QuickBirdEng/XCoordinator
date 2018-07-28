//  
//  NewsViewModel.swift
//  RxCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol NewsViewModelInput {
}

protocol NewsViewModelOutput {
}

protocol NewsViewModel {
    var input: NewsViewModelInput { get }
    var output: NewsViewModelOutput { get }
}

extension NewsViewModel where Self: NewsViewModelInput & NewsViewModelOutput {
    var input: NewsViewModelInput { return self }
    var output: NewsViewModelOutput { return self }
}
