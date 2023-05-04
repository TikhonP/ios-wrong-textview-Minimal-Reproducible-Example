//
//  ChatView.swift
//  Medsenger
//
//  Created by Tikhon Petrishchev on 07.11.2022.
//  Copyright © 2022 TelePat ltd. All righchatViewModelts reserved.
//

import SwiftUI

struct ChatView: View {
    
    @State private var inputViewHeight: CGFloat = 48.33
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack {
                    ForEach(0...100, id: \.self) {
                        Text("Message \($0)")
                            .padding()
                    }
                }
            }
            MessageInputView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Chat")
        
    }
}

#if DEBUG
//struct ChatView_Previews: PreviewProvider {
//    static let persistence = PersistenceController.preview
//
//    static var contract1: Contract = {
//        let context = persistence.container.viewContext
//        let contract = Contract.createSampleContract1(for: context)
//        PersistenceController.save(for: context)
//        return contract
//    }()
//
//    static var user: User = {
//        let context = persistence.container.viewContext
//        let user = User.createSampleUser(for: context)
//        PersistenceController.save(for: context)
//        return user
//    }()
//
//    static var previews: some View {
//        NavigationView {
//            ChatView(contract: contract1, user: user)
//                .environment(\.managedObjectContext, persistence.container.viewContext)
//        }
//    }
//}
#endif
