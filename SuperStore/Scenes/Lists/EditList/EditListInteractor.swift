//
//  EditListInteractor.swift
//  SuperStore
//
//  Created by Zakariya Mohummed on 04/03/2021.
//  Copyright (c) 2021 Zakariya Mohummed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EditListBusinessLogic
{
    func getList(request: EditList.GetList.Request)
    func updateList(request: EditList.UpdateList.Request)
    func restartList(request: EditList.RestartList.Request)
    
    var list: ListModel! { get set }
}

protocol EditListDataStore
{
    var list: ListModel! { get set }
}

class EditListInteractor: EditListBusinessLogic, EditListDataStore
{
    var presenter: EditListPresentationLogic?
    
    var listWorker: ListWorker = ListWorker(listAPI: ListAPI())
    var validationWorker: ListValidationWorker = ListValidationWorker()

    var list: ListModel!
    
    
    func getList(request: EditList.GetList.Request)
    {
        let response = EditList.GetList.Response(name: list.name, supermarketChainID: list.supermarketChainID)
        presenter?.presentList(response: response)
    }
    
    func updateList(request: EditList.UpdateList.Request){
        let formFields: [ListFormField] = [
            ListFormField(name: "Name", value: request.name, type: .name)
        ]
        
        let error = validationWorker.validateFields(formFields)
        
        if let error = error {
            let response = EditList.UpdateList.Response(error: error)
            presenter?.presentListUpdated(response: response)
        } else {
            listWorker.updateList(listID: list.id, name: request.name, supermarketChainID: list.supermarketChainID) { (error: String?) in
                let response = EditList.UpdateList.Response(error: error)
                self.presenter?.presentListUpdated(response: response)
            }
        }
    }
    
    func restartList(request: EditList.RestartList.Request){
        listWorker.restartList(listID: list!.id) { (error: String?) in
            let response = EditList.RestartList.Response(error: error)
            self.presenter?.presentListRestarted(response: response)
        }
    }
}
