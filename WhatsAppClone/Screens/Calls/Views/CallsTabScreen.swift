//
//  CallsTabScreen.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI


// MARK: View
struct CallsTabScreen: View {
    
    @State private var searchText: String = ""
    @State private var callHistory: CallHistory = CallHistory.all
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    CreateCallLinkSection()
                }
                Section {
                    ForEach(0..<12) { _ in
                        RecentCallItemView()
                    }
                } header: {
                    Text("Recent")
                        .textCase(nil)
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.whatsAppBlack)
                }
            }
            .navigationTitle("Calls")
            .searchable(text: $searchText)
            .toolbar {
                leadingNavItem()
                trailingNavItem()
                principalNavItem()
            }
        }
    }
}


// MARK: Extension
extension CallsTabScreen {
    
    @ToolbarContentBuilder
    private func leadingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                
            } label: {
                Text("Edit")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "phone.arrow.up.right")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func principalNavItem() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Picker("", selection: $callHistory) {
                ForEach(CallHistory.allCases) { item in
                    Text(item.rawValue.capitalized)
                        .tag(item)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
    }
    
    // MARK: Enum
    private enum CallHistory: String, CaseIterable, Identifiable {
        case all, missed
        
        var id: String {
            return rawValue
        }
    }
}


// MARK: Components
private struct CreateCallLinkSection: View {
    var body: some View {
        HStack {
            Image(systemName: "link")
                .padding(8)
                .background(Color(.systemGray6))
                .clipShape(Circle())
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading) {
                Text("Create Call Link")
                    .foregroundStyle(.blue)
                
                Text("Share a link for your WhatsApp call")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
        }
    }
}

private struct RecentCallItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 45, height: 45)
            
            recentCallsTextView()
            
            Spacer()
            
            Text("Yesterday")
                .foregroundStyle(.gray)
                .font(.system(size: 16))
            
            Image(systemName: "info.circle")
        }
    }
    
    private func recentCallsTextView() -> some View {
        VStack(alignment: .leading) {
            Text("John Smith")
            
            HStack(spacing: 5) {
                Image(systemName: "phone.arrow.up.right.fill")
                Text("Outgoing")
            }
            .font(.system(size: 14))
            .foregroundStyle(.gray)
        }
    }
}


// MARK: Preview
#Preview {
    CallsTabScreen()
}
