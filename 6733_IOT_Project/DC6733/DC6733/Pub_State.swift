//
//  Pub_State.swift
//  DC6733
//
//  Created by Jo on 2025/7/16.
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var hasAppeared_V3_2: Bool = false
    @Published var hasAppeared_V4_2: Bool = false
}
