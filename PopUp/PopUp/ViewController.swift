//
//  ViewController.swift
//  PopUp
//
//  Created by sun on 2022/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(viewDidTap(_:))
        )
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func viewDidTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            showPopup(title: "제목", message: "메시지") {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) {
                    print("dismiss")
                }
            }
        }
        
    }
}

extension UIViewController {
    func showPopup(
        title: String? = nil,
        message: String? = nil,
        attributedMessage: NSAttributedString? = nil,
        leftActionTitle: String = "취소",
        rightActionTitle: String = "확인",
        leftActionCompletion: (() -> Void)? = nil,
        rightActionCompletion: (() -> Void)? = nil
    ) {
        let popupViewController = PopUpViewController(
            titleText: title,
            messageText: message,
            attributedMessageText: attributedMessage
        )
        
        showPopup(
            popupViewController: popupViewController,
            leftActionTitle: leftActionTitle,
            rightActionTitle: rightActionTitle,
            leftActionCompletion: leftActionCompletion,
            rightActionCompletion: rightActionCompletion
        )
    }
    
    func showPopup(
        contentView: UIView,
        leftActionTitle: String = "취소",
        rightActionTitle: String = "확인",
        leftActionCompletion: (() -> Void)? = nil,
        rightActionCompletion: (() -> Void)? = nil
    ) {
        let popupViewController = PopUpViewController(contentView: contentView)
        
        showPopup(
            popupViewController: popupViewController,
            leftActionTitle: leftActionTitle,
            rightActionTitle: rightActionTitle,
            leftActionCompletion: leftActionCompletion,
            rightActionCompletion: rightActionCompletion
        )
    }
    
    private func showPopup(
        popupViewController: PopUpViewController,
        leftActionTitle: String,
        rightActionTitle: String,
        leftActionCompletion: (() -> Void)?,
        rightActionCompletion: (() -> Void)?
    ) {
        popupViewController.addActionToButton(
            title: leftActionTitle,
            titleColor: .systemGray,
            backgroundColor: .secondarySystemBackground) {
                UIView.animate(withDuration: 0.5) {
                    
                    self.view.window!.layer.add(CATransition().fadeTransition(), forKey: kCATransition)
                    popupViewController.dismiss(animated: false, completion: leftActionCompletion)
                }

            }
        popupViewController.addActionToButton(
            title: rightActionTitle,
            titleColor: .white,
            backgroundColor: .blue) {
                popupViewController.dismiss(animated: false, completion: rightActionCompletion)
            }
        present(popupViewController, animated: false, completion: nil)
    }
}

extension CATransition {
    func fadeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight

        return transition
    }
}
