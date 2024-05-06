//
//  ViewExtensions.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/5/24.
//
#if canImport(UIKit)
import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
