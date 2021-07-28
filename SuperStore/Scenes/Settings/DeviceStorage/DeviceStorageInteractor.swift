//
//  DeviceStorageInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 08/07/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DeviceStorageBusinessLogic
{
    func doSomething(request: DeviceStorage.Something.Request)
}

protocol DeviceStorageDataStore
{
    //var name: String { get set }
}

class DeviceStorageInteractor: DeviceStorageBusinessLogic, DeviceStorageDataStore
{
    var presenter: DeviceStoragePresentationLogic?
    var worker: DeviceStorageWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func doSomething(request: DeviceStorage.Something.Request)
    {
        worker = DeviceStorageWorker()
        worker?.doSomeWork()
        
        let response = DeviceStorage.Something.Response()
        presenter?.presentSomething(response: response)
    }
}