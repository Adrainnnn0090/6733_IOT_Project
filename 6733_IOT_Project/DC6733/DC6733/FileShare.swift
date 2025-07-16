//
//  FileShare.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import SwiftUI
import UIKit

struct FileSharer: UIViewControllerRepresentable {
    var fileURLs: [URL]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: fileURLs, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    
    }
}
