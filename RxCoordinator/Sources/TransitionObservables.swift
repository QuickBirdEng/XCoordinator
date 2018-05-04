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
    public let presentation: Observable<Void>
    public let dismissal: Observable<Void>
}
