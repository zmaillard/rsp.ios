//
//  Router.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/18/26.
//
import SwiftUI

@Observable
@MainActor
final class Router {
    var path: [BrowseRoute] = []
    
    func push(_ route: BrowseRoute) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func setPath(_ newPath: [BrowseRoute]) {
        path = newPath
    }
    
}
