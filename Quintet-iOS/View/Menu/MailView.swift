//
//  MailView.swift
//  Quintet-iOS
//
//  Created by Phil on 2/22/24.
//

import SwiftUI
import StoreKit
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool

        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = context.coordinator
        mailVC.setToRecipients(["rlavlfrb0119@gmail.com"]) // 개발자 이메일 주소 설정
        mailVC.setSubject("문의하기") // 이메일 제목 설정
        mailVC.setMessageBody("", isHTML: false) // 이메일 본문 설정
        return mailVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

