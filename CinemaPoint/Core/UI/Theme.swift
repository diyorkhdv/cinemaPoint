//
//  Theme.swift
//  CinemaPoint
//
//  Created by diyor on 16/10/25.
//

import UIKit

enum Theme {
    static let accent: UIColor = UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 1.0, green: 0.45, blue: 0.3, alpha: 1.0)
        : UIColor(red: 0.95, green: 0.35, blue: 0.25, alpha: 1.0)
    }
    
    static let background: UIColor = UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor(red: 0.08, green: 0.08, blue: 0.1, alpha: 1.0)
        : UIColor.systemBackground
    }

    static let shadow: UIColor = UIColor { trait in
        trait.userInterfaceStyle == .dark
        ? UIColor.black.withAlphaComponent(0.4)
        : UIColor.black.withAlphaComponent(0.15)
    }

    static let textPrimary: UIColor = UIColor { trait in
        trait.userInterfaceStyle == .dark ? .white : .black
    }
}
