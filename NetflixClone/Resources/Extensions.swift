//
//  Extensions.swift
//  NetflixClone
//
//  Created by Chingiz on 20.02.24.
//

import Foundation

extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
