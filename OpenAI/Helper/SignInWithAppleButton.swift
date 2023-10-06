//
//  SignInWithAppleButton.swift
//  OpenAI
//
//  Created by Apple on 2023/04/02.
//
import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
    var completionHandler: ((Result<ASAuthorization, Error>) -> Void)?

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        var parent: SignInWithAppleButton

        init(_ parent: SignInWithAppleButton) {
            self.parent = parent
        }

        @objc func buttonTapped() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            let result: Result<ASAuthorization, Error> = .success(authorization)
            parent.completionHandler?(result)
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            let result: Result<ASAuthorization, Error> = .failure(error)
            parent.completionHandler?(result)
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return UIWindow()
        }
    }
}
