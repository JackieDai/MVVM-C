//
//  DetailNavigationController.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import UIKit

class DetailNavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

}

extension DetailNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .push, toVC is PlaceholderViewController else {
            return nil
        }
        return DetailNavigationControllerAnimator(operation: operation)
    }
}

class DetailNavigationControllerAnimator: NSObject {
    
    let operation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
        super.init()
    }
}

extension DetailNavigationControllerAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        if operation == .push {
            switch toVC is PlaceholderViewControllerType {
            case true:
                animatePushAsPop(from: fromVC, to: toVC, using: transitionContext)
            case false:
                animatePush(from: fromVC, to: toVC, using: transitionContext)
            }
        } else if operation == .pop {
            animatePop(from: fromVC, to: toVC, using: transitionContext)
        }
        
    }
    
    
    // MARK: - Push / Pop

    private func animatePush(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        let dx = containerView.frame.size.width
        toVC.view.frame = finalFrame.offsetBy(dx: dx, dy: 0.0)
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIView.AnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
                fromVC.view.frame = finalFrame.offsetBy(dx: dx / -2.5, dy: 0.0)
        },
            completion: { (finished) in transitionContext.completeTransition(true) }
        )
    }

    private func animatePushAsPop(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        let dx = containerView.frame.size.width
        toVC.view.frame = finalFrame.offsetBy(dx: dx / -2.5, dy: 0.0)
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIView.AnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
                fromVC.view.frame = finalFrame.offsetBy(dx: dx, dy: 0.0)
        },
            completion: { (finished) in transitionContext.completeTransition(true) }
        )
    }

    private func animatePop(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIView.AnimationOptions.curveEaseOut ],
            animations: {
                fromVC.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.width, dy: 0)
                toVC.view.frame = containerView.bounds
        },
            completion: { (finished) in transitionContext.completeTransition(true) }
        )
    }
    
}
