//
//  LoadingState.swift
//  rpbrowser
//
//  Created by Zach Maillard on 8/12/26.
//
enum LoadingState<T: Equatable> : Equatable {
    case idle
    case loading
    case loaded(T)
    case error(String)
}
