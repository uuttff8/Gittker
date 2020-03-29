//
//  RoomChatCoordinator.swift
//  Gittker
//
//  Created by uuttff8 on 3/15/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class RoomChatCoordinator: Coordinator {

    weak var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    
    var roomId: String
    
    init(with navigationController: UINavigationController?, roomId: String) {
        self.navigationController = navigationController
        self.roomId = roomId
    }
    
    func start() {
        let vc = RoomChatViewController(coordinator: self, roomId: roomId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
