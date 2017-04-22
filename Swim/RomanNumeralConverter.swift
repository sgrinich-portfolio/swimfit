//
//  toRoman.swift
//  Swim
//
//  Created by StephenGrinich on 1/29/17.
//  Copyright © 2017 StephenGrinich. All rights reserved.
//

import Foundation

func toRoman(number: Int) -> String {
    
    let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
    let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    
    var romanValue = ""
    var startingValue = number
    
    for (index, romanChar) in enumerate(romanValues) {
        var arabicValue = arabicValues[index]
        
        var div = startingValue / arabicValue
        
        if (div > 0)
        {
            for j in 0..<div
            {
                romanValue += romanChar
            }
            
            startingValue -= arabicValue * div
        }
    }
    
    return romanValue
}
