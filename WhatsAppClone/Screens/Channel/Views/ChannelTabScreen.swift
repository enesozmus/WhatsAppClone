//
//  ChannelTabScreen.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI


// MARK: View
struct ChannelTabScreen: View {
    
    // MARK: Properties
    @State private var searchText: String = ""
    @StateObject private var viewModel = ChannelTabViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navRoutes) {
            List {
                archivedButton()
                
                ForEach(viewModel.channels) { channel in
                    Button {
                        viewModel.navRoutes.append(.chatRoom(channel))
                    } label: {
                        ChannelItemView(channel: channel)
                    }
                    //                    NavigationLink {
                    //                        ChatRoomScreen(channel: channel)
                    //                    } label: {
                    //                        ChannelItemView(channel: channel)
                    //                    }
                }
                
                inboxFooterView()
                    .listRowSeparator(.hidden)
            }
            .navigationTitle("Chats")
            .searchable(text: $searchText)
            .listStyle(.plain)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .navigationDestination(for: ChannelTabRoutes.self) { route in
                destinationView(for: route)
            }
            .sheet(isPresented: $viewModel.showChatPartnerPickerView) {
                ChatPartnerPickerScreen(onCreate: viewModel.onNewChannelCreation)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if let newChannel = viewModel.newChannel {
                    ChatRoomScreen(channel: newChannel)
                }
            }
        }
    }
}


// MARK: Extension
extension ChannelTabScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Button {
                    
                } label: {
                    Label("Select Chats", systemImage: "checkmark.circle")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            aiButton()
            cameraButton()
            newChatButton()
        }
    }
    
    private func aiButton() -> some View {
        Button {
            
        } label: {
            Image(.circle)
        }
    }
    
    private func cameraButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "camera")
        }
    }
    
    private func newChatButton() -> some View {
        Button {
            viewModel.showChatPartnerPickerView = true
        } label: {
            Image(.plus)
        }
    }
    
    private func archivedButton() -> some View {
        Button {
            
        } label: {
            Label("Archived", systemImage: "archivebox.fill")
                .bold()
                .padding()
                .foregroundStyle(.gray)
        }
    }
    
    private func inboxFooterView() -> some View {
        HStack {
            Image(systemName: "lock.fill")
            
            (
                Text("Your personal messages are ")
                +
                Text("end-to-end encrypted")
                    .foregroundColor(.blue)
            )
        }
        .foregroundStyle(.gray)
        .font(.caption)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func destinationView(for route: ChannelTabRoutes) -> some View {
        switch route {
        case .chatRoom(let channel):
            ChatRoomScreen(channel: channel)
        }
    }
}


// MARK: Preview
#Preview {
    ChannelTabScreen()
}
