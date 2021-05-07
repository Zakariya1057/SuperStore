//
//  FeedbackViewController.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 06/05/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SCLAlertView

protocol FeedbackDisplayLogic: AnyObject
{
    func displaySendFeedback(viewModel: Feedback.SendFeedback.ViewModel)
}

class FeedbackViewController: UIViewController, FeedbackDisplayLogic
{
    var interactor: FeedbackBusinessLogic?
    var router: (NSObjectProtocol & FeedbackRoutingLogic & FeedbackDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = FeedbackInteractor()
        let presenter = FeedbackPresenter()
        let router = FeedbackRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openKeyboardOnTextView()
    }
    
    let spinner: SpinnerViewController = SpinnerViewController()
    
    @IBOutlet var feedbackTextView: UITextView!
    
    func displaySendFeedback(viewModel: Feedback.SendFeedback.ViewModel)
    {
        stopLoading()
        
        if let error = viewModel.error {
            showError(title: "Feedback Error", error: error)
        } else {
            feedbackSuccess()
        }
    }
    
    func sendFeedback()
    {
        let message = feedbackTextView.text ?? ""
        
        if message.replacingOccurrences(of: " ", with: "") != "" {
            startLoading()
            
            let request = Feedback.SendFeedback.Request(message: message)
            interactor?.sendFeedback(request: request)
        } else {
            showError(title: "Feedback Error", error: "Feedback text required")
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendFeedback()
    }
    
}

extension FeedbackViewController {
    func openKeyboardOnTextView(){
        feedbackTextView.becomeFirstResponder()
    }
}

extension FeedbackViewController {
    // Alert. Thank You for the feedback.
    func feedbackSuccess(){
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 22)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )

        let alert = SCLAlertView(appearance: appearance)
        
        alert.showSuccess(
            "Feedback Sent",
            subTitle: "Thank you for your feedback.",
            closeButtonTitle: "Okay",
            timeout: .init(timeoutValue: TimeInterval(2), timeoutAction: {
                self.router?.routeToSettings(segue: nil)
            }),
            colorStyle: 0x1976CD,
            colorTextButton: 0xFFFFFF,
            circleIconImage: nil,
            animationStyle: .bottomToTop)
        
    }
}
extension FeedbackViewController {
    func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopLoading(){
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
