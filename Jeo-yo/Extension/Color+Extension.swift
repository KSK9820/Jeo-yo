//
//  Color+Extension.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/27/24.
//

import SwiftUI

import SwiftUI

extension Color {
    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        return (red: Double(components[0]),
                green: Double(components[1]),
                blue: Double(components[2]),
                alpha: Double(components[3]))
    }
}

extension View {
    func gradientColors(count: Int) -> [Color] {
        let lightBlue = Color.aliceBlue
        let darkBlue = Color.deepSkyBlue

        return (0...count).map { index in
            let ratio = Double(index) / Double(max(count, 1)) 
            let lightComponents = lightBlue.rgba
            let darkComponents = darkBlue.rgba
            
            let red = lightComponents.red + (darkComponents.red - lightComponents.red) * ratio
            let green = lightComponents.green + (darkComponents.green - lightComponents.green) * ratio
            let blue = lightComponents.blue + (darkComponents.blue - lightComponents.blue) * ratio
            
            return Color(red: red, green: green, blue: blue)
        }
    }
}
