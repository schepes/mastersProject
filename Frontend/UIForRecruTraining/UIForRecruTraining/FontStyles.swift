//
//  FontStyles.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/1/24.
//

import Foundation
import SwiftUI

extension Font {
    
    static var navModelTitle: Font {
        
        return Font.custom("Raleway-Bold", size: 20)
    }
    
    static var chatHistory: Font {
        
        return Font.custom("Raleway-SemiBold", size: 16)
    }
    
    static var chatMessage: Font {
        
        return Font.custom("Raleway-Medium", size: 16)
    }
}
