//
//  PopUpViewController.swift
//  PopUp
//
//  Created by sun on 2022/02/22.
//

import UIKit

class PopUpViewController: UIViewController {
    
    private var titleText: String?
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
    
    /// container stack view 와 button stack view 를 감싸 여백을 관리하는 뷰
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        
        /// 팝업이 등장할 때(viewWillAppear) 에서 containerView.transform = .identity 로 하여 애니메이션 효과 주는 용도
        view.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
        
        return view
    }()
    
    /// 타이틀, button stack view 를 감싸고 있는 뷰
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 100
        view.alignment = .center
        view.backgroundColor = .systemTeal
        return view
    }()
    
    /// 2개의 버튼을 담고 있는 스택 뷰
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 14.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    /// 팝업의 제목 라벨
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    /// 팝업의 내용 라벨
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil || attributedMessageText != nil
        else { return nil }
        
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .gray
        label.numberOfLines = 0
        
        if let attributedMessageText = attributedMessageText {
            label.attributedText = attributedMessageText
        }
        
        return label
    }()
    
    convenience init(
        titleText: String? = nil,
        messageText: String? = nil,
        attributedMessageText: NSAttributedString? = nil
    ) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        self.attributedMessageText = attributedMessageText
        
        /// present 시 fullScreen( 화면을 덮도록 설정) -> 설정 안하면 pageSheet gudxo (위가 좀 남아서 밑에 깔린 뷰가 보이는 형태)
        modalPresentationStyle = .overFullScreen
    }
    
    convenience init(contentView: UIView) {
        self.init()
        
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
        makeConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.containerView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.containerView.alpha = 1
//            self?.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//            self?.containerView.transform = .identity
//            self?.containerView.isHidden = false
        }

//        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) {
//            [weak self] in
//            self?.containerView.transform = .identity
//            self?.containerView.isHidden = false
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) {
//            [weak self] in
//            self?.containerView.alpha = 0
//            self?.containerView.transform = .identity
//            self?.containerView.isHidden = true
        }
        print("disappearing")
    }
    
    private func setupViews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap(_:)))
        view.addGestureRecognizer(tap)
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        let tap2 = UITapGestureRecognizer(target: self, action: nil)
        containerView.addGestureRecognizer(tap2)
        view.backgroundColor = .black.withAlphaComponent(0.2)
//        containerView.backgroundColor = .yellow
    }
    
    @objc private func backgroundDidTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func addSubviews() {
//        view.addSubview(containerView)
        
        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }
            
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
        }
        
//        if let lastView = containerStackView.subviews.last {
//            containerStackView.setCustomSpacing(100.0, after: lastView)
//        }
        
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 32),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32),
            
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 48),
            buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PopUpViewController {
    /// 커스텀 액션 버튼을 생성하고 추가하는 메서드
    public func addActionToButton(
        title: String? = nil,
        titleColor: UIColor = .white,
        backgroundColor: UIColor = .blue,
        completion: (() -> Void)? = nil
    ) {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        
        // enable
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)
        
        // disable
        button.setTitleColor(.gray, for: .disabled)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)
        
        // layer
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        
        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }
        
        buttonStackView.addArrangedSubview(button)
    }
}

extension UIControl {
    public typealias UIControlTargetClosure = (UIControl) -> ()
    
    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(
                self,
                &AssociatedKeys.targetClosure
            ) as? UIControlClosureWrapper
            else { return nil }
            
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue
            else { return }
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.targetClosure,
                UIControlClosureWrapper(newValue),
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure
        else { return }
        targetClosure(self)
    }
    
    public func addAction(for event: UIControl.Event, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }
}

extension UIColor {
    
    /// UIColor 를 이미지로 변환
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
