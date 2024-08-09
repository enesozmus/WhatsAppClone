//
//  MessageListController.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import Combine
import Foundation
import SwiftUI
import UIKit

final class MessageListController: UIViewController {
    
    // MARK: View's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        setUpViews()
        setUpMessageListners()
    }
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    private let viewModel: ChatRoomViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let cellIdentifier = "MessageListControllerCells"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let backgroundImageView: UIImageView = {
        let backgroudImageView = UIImageView(image: .chatBackground)
        backgroudImageView.translatesAutoresizingMaskIntoConstraints = false
        return backgroudImageView
    }()
    
    // MARK: Methods
    private func setUpViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setUpMessageListners() {
        let delay = 200
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscriptions)
    }
}


// MARK: UITableViewDelegate & UITableViewDataSource
extension MessageListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let message = viewModel.messages[indexPath.row]
        
        cell.contentConfiguration = UIHostingConfiguration {
            switch message.type {
            case .text:
                BubbleText(item: message)
            case .video, .photo:
                BubbleImage(item: message)
            case .audio:
                BubbleAudio(item: message)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
