//
//  ViewController.swift
//  iOS_UI_practice1
//
//  Created by Alex on 24.11.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

// Класс веб-сессии
class Session {
    static let instance = Session()
    
    private init() {}
    
    var token: String = ""
    var userId: Int?
}

class LoginViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passInput: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shakeMeLabel: UILabel!
    @IBOutlet weak var loader: Loader!
    @IBInspectable let useUIAnimations : Bool = true
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPass: UILabel!
    @IBOutlet weak var scrollBottom: NSLayoutConstraint!
    
    @IBAction func buttonPressed(_ sender: Any) {
        login()
    }
    
    let navigationAnimator = CustomNavigationControllerAnimation()
    var snowEmitterLayer = CAEmitterLayer()
    
    // Создаем глобальный класс для сессии
    let session = Session.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginInput.setLeftPaddingPoints(8); loginInput.setRightPaddingPoints(8)
        passInput.setLeftPaddingPoints(8); passInput.setRightPaddingPoints(8)
        
        if useUIAnimations {
            // Если анимаиции разрешены, то выставляем стартовые положения для анимируемых объектов
            logo.transform = CGAffineTransform(translationX: 0, y: -220)
            loginInput.transform = CGAffineTransform(translationX: -view.frame.width/2 - loginInput.frame.width, y: 0)
            passInput.transform = CGAffineTransform(translationX: view.frame.width/2 + passInput.frame.width, y: 0)
            loginButton.alpha = 0
            forgotPass.alpha = 0
        }
        
        // Подписываемся на события клавиатуры
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notification.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        let logoPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanLogo))
        logo.isUserInteractionEnabled = true
        logo.addGestureRecognizer(logoPanGesture)
        transitioningDelegate = self
        
        startAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        snowEmitterLayer.removeAllAnimations()
        loader.stopAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  
        shakeMeLabel.alpha = 0.0
        
        if useUIAnimations {
            easterEggAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Отписываемся от событий клавиатуры
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if useUIAnimations && motion == .motionShake {
            snowAnimation()
        }
    }
    
    // MARK: - Анимация таскания логотипа
    var logoPanAnimator = UIViewPropertyAnimator()
    
    @objc func onPanLogo(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else { return }
        let translation = recognizer.translation(in: recognizer.view)
        
        switch recognizer.state {
        case .began:
            break
        case .changed:
            logoPanAnimator = UIViewPropertyAnimator(duration: 1.2, dampingRatio: 0.25, animations: {
                self.logo.transform = CGAffineTransform(translationX: translation.x * 0.15, y: translation.y * 0.15)
            })
            logoPanAnimator.startAnimation()
            break
        case .ended:
            logoPanAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            logoPanAnimator.addAnimations {
                self.logo.transform = .identity
            }
            break
        default:
            return
        }
    }
    
    func login() {
        let login = loginInput.text ?? ""
        let password = passInput.text ?? ""
        
        //        if login == "admin" && password == "12345678" {
        if login == "" && password == "" {
            loader.playAnimation()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "MainTab")
//            navigationController?.pushViewController(nextViewController, animated: true)
//            nextViewController.modalPresentationStyle = .custom
//            nextViewController.modalPresentationCapturesStatusBarAppearance = true
            nextViewController.transitioningDelegate = self
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.present(nextViewController, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Ошибка", message: "Неверная пара логин/пароль", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startAnimations() {
        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            self.logo.transform = .identity
            self.logo.didMoveToWindow()
        })
        
        UIView.animate(withDuration: 1.5, delay: 1.25, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.25, options: [], animations: {
            self.loginInput.transform = .identity
            self.passInput.transform = .identity
        })
        
        UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
            self.loginButton.alpha = 1.0
        })
        
        UIView.animate(withDuration: 1.0, delay: 1.75, options: [], animations: {
            self.forgotPass.alpha = 1.0
        })
    }
    
    func easterEggAnimation() {
        UIView.animate(withDuration: 1.0, delay: 10.0, options: [], animations: {
            self.shakeMeLabel.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.75, delay: 4.0, usingSpringWithDamping: 0.25, initialSpringVelocity: 0.5, options: [.repeat, .autoreverse], animations: {
            self.shakeMeLabel.transform = CGAffineTransform(translationX: 6.0, y: 3.0)
        })
    }
    
    // MARK: - Snow animation
    func snowAnimation() {
        shakeMeLabel.isHidden = true
        
        let emitterSnow = CAEmitterCell()
        emitterSnow.contents = UIImage(named: "snowflake")?.cgImage
        emitterSnow.scale = 0.1
        emitterSnow.scaleRange = 0.3
        emitterSnow.birthRate = 10
        emitterSnow.lifetime = 10.0
        emitterSnow.velocity = -30
        emitterSnow.velocityRange = -20
        emitterSnow.yAcceleration = 30
        emitterSnow.xAcceleration = 5
        emitterSnow.spin = -0.5
        emitterSnow.spinRange = 1.0
        
        snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width/2, y: -50)
        snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width * 1.5, height: 0)
        snowEmitterLayer.emitterShape = .line
        snowEmitterLayer.beginTime = CACurrentMediaTime()
        snowEmitterLayer.timeOffset = 2.0
        snowEmitterLayer.emitterCells = [emitterSnow]
        view.layer.addSublayer(snowEmitterLayer)
    }
    
    @objc func keyboardChanged(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardScreenEndFrame = value.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//        let newContentInsets = UIEdgeInsets(top: 0,
//                                            left: 0,
//                                            bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
//                                            right: 0)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollBottom.constant = 0
        } else {
            scrollBottom.constant = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
        }
        view.layoutIfNeeded()
//        
//        self.scrollView?.contentInset = newContentInsets
//        self.scrollView?.scrollIndicatorInsets = newContentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        self.scrollView?.contentInset = .zero
        print("Клавиатура исчезает")
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class CustomNavigationControllerAnimation: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
            case .pop:
                return FadePopAnimation()
            case .push:
                return FadePushAnimation()
            case .none:
                return nil
        }
    }
}

class FadePushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 1.0
        }) { completion in
            transitionContext.completeTransition(completion)
        }
    }
}

class FadePopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 1.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC.view.alpha = 0
        }) { completion in
            transitionContext.completeTransition(completion)
        }
    }
}

//class AnimatorTransition: NSObject, UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 1.0
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let source = transitionContext.viewController(forKey: .from),
//            let to = transitionContext.viewController(forKey: .to) else {
//            return
//        }
//
//        transitionContext.containerView.addSubview(to.view)
//
//        to.view.frame = CGRect(x: 0,
//                               y: transitionContext.containerView.frame.height,
//                               width: source.view.frame.width,
//                               height: source.view.frame.height)
//
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            source.view.frame = CGRect(x: 0,
//                                       y: -source.view.frame.height,
//                                       width: source.view.frame.width,
//                                       height: source.view.frame.height)
//            to.view.frame = CGRect(x: 0,
//                                   y: 0,
//                                   width: source.view.frame.width,
//                                   height: source.view.frame.height)
//        }, completion: { isCompleted in
//            transitionContext.completeTransition(isCompleted)
//        })
//    }
//}
//
//extension LoginViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return standartAnimator
//    }
//}

extension LoginViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CircularTransition()
        return CardRotateTransition()
    }
}
