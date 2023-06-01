//
//  SettingsCellViewModel.swift
//  Mugonggan
//
//  Created by yeomim kim on 2023/06/01.
//

import SwiftUI

enum SettingsCellViewModel: Int, CaseIterable {

    case account
    case notifications
    case starredMessages
    
    var title: String {
        switch self {
        case .account: return "계정"
        case .notifications: return "알림"
        case .starredMessages: return "스타메세지"
        }
    }
    
    var imageName: String {
        switch self {
        case .account: return "key.fill"
        case .notifications: return "bell.fill"
        case .starredMessages: return "star.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .account: return .blue
        case .notifications: return .red
        case .starredMessages: return .yellow
        }
    }
    
}
