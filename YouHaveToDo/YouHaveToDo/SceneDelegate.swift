//
//  SceneDelegate.swift
//  YouHaveToDo
//
//  Created by Berat Rıdvan Asiltürk on 11.07.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // Note: Opsiyonellerin her zaman var olması gerektiğini unutmayın.
    var window: UIWindow?
    let dataModel = DataModel()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Bu kod satiri storyboard'a bakarak AllListsViewController'ı bulur ve ardından dataModel özelliğini ayarlar.
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        saveData()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveData()
    }

    // MARK: - Helper Methods
    func saveData() {
        dataModel.saveChecklists()
    }
}

// NOTES: iOS uygulamanızda sahne başına yalnızca bir UIWindow nesnesi vardır. iOS'ta birden fazla pencereye sahip olmak istediğinizde, ek sahneler oluşturmanız gerekir.
