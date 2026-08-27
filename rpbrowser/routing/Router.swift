//
//  Router.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/18/26.
//
import SwiftUI

@Observable
@MainActor
final class Router : Codable {
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

@Observable
@MainActor
class AppRouter : Codable {
    var browseRouter = Router()
    var selectedTab: TabIdentifier = .random
    
    func navigateTo(tab: TabIdentifier) {
       self.selectedTab = tab
    }
}
