//
//  GameSceneDelegate.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/10/23.
//

import Foundation

protocol GameSceneDelegate: AnyObject {
    func restartGame()
    func goToMainMenu()
    func presentLeaderboard()
}
