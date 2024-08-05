//
//  GridPoints.swift
//  sti_exam
//
//  Created by Andreas Antonsson on 2024-04-03.
//

import SwiftUI
import Foundation

struct GridPoints {
    static let half = gridPoint * 0.5
    static let x1 = gridPoint
    static let x2 = gridPoint * 2
    static let x3 = gridPoint * 3
    static let x4 = gridPoint * 4
    static let x5 = gridPoint * 5
    static let x6 = gridPoint * 6
    static let x7 = gridPoint * 7
    static let x8 = gridPoint * 8

    static func custom(_ value: CGFloat) -> CGFloat {
        gridPoint * value
    }

    private static let gridPoint: CGFloat = 8.0
    private init() {}
}

