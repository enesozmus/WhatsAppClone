//
//  MessageList.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI

struct MessageList: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MessageListController
    private var viewModel: ChatRoomViewModel
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> MessageListController {
        let messageListController = MessageListController(viewModel)
        return messageListController
    }
    
    func updateUIViewController(_ uiViewController: MessageListController, context: Context) { }
}
