//
//  ReportIssueViewController.swift
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

protocol ReportIssueDisplayLogic: AnyObject
{
    func displaySendIssue(viewModel: ReportIssue.SendIssue.ViewModel)
}

class ReportIssueViewController: UIViewController, ReportIssueDisplayLogic
{
    var interactor: ReportIssueBusinessLogic?
    var router: (NSObjectProtocol & ReportIssueRoutingLogic & ReportIssueDataPassing)?
    
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
        let interactor = ReportIssueInteractor()
        let presenter = ReportIssuePresenter()
        let router = ReportIssueRouter()
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
    
    @IBOutlet var issueTextView: UITextView!
    
    func sendIssue()
    {
        let issue: String = issueTextView.text ?? ""
        
        if issue.replacingOccurrences(of: " ", with: "") != "" {
            startLoading()
            
            let request = ReportIssue.SendIssue.Request(issue: issue)
            interactor?.sendIssue(request: request)
        } else {
            showError(title: "Report Issue Error", error: "Issue details required.")
        }

    }
    
    func displaySendIssue(viewModel: ReportIssue.SendIssue.ViewModel)
    {
        stopLoading()
        
        if let error = viewModel.error {
            showError(title: "Report Issue Error", error: error)
        } else {
            reportIssueSuccess()
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        sendIssue()
    }
}

extension ReportIssueViewController {
    func reportIssueSuccess(){

        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 22)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )

        let alert = SCLAlertView(appearance: appearance)
        
        alert.showSuccess(
            "Issue Reported",
            subTitle: "Thank you for reporting this issue.",
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

extension ReportIssueViewController {
    func openKeyboardOnTextView(){
        issueTextView.becomeFirstResponder()
    }
}

extension ReportIssueViewController {
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