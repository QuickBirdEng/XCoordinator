//
//  TransitionObservables.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import RxSwift

public struct TransitionObservables {
    let presentation: Observable<Void>
    let dismissal: Observable<Void>
}
