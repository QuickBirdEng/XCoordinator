//
//  Transition+Presentable.swift
//  rx-coordinator
//
//  Created by Stefan Kofler on 20.07.18.
//

import Foundation

extension Transition {

    var presentable: Presentable? {
        switch type {
        case let transitionType as TransitionTypeVC:
            switch transitionType {
            case .present(let presentable):
                return presentable
            case .embed(let presentable, _):
                return presentable
            case .dismiss, .none:
                return nil
            case .registerPeek(_, let popTransition):
                return popTransition().presentable
            }
        case let transitionType as TransitionTypeNC:
            switch transitionType {
            case .push(let presentable):
                return presentable
            case .present(let presentable):
                return presentable
            case .embed(let presentable, _):
                return presentable.viewController
            case .registerPeek(_, let popTransition):
                return popTransition().presentable
            case .pop, .popToRoot, .dismiss, .none:
                return nil
            }
        default:
            return nil
        }
    }

}
