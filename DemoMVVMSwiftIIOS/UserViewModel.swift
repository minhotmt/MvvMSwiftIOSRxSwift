//
//  UserViewModel.swift
//  DemoMVVMSwiftIIOS
//
//  Created by MinKo on 10/7/19.
//  Copyright © 2019 MinKo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel: NSObject {
    var searchInput = Variable<String?>("")
    var searchResult = Variable<[UserModel]>([])
    var disposeBag = DisposeBag()
    
    override init() {
        super.init()
        bindingData()
    }
    func bindingData(){
        self.searchInput.asObservable().subscribe(onNext: { (text) in
            if text!.isEmpty {
                self.searchResult.value = []
            } else {
                self.requestJSON(url: "https://api.github.com/search/users?q=\(text!)")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
    
    func requestJSON(url: String) {
        let url = URL(string: url)
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, result, error) in
            if error == nil {
                do {
                    if let result:Dictionary<String, Any> = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any> {
                        var userArray: Array<UserModel> = []
                        if let items: Array<Any> = result["items"] as? Array<Any> {
                            for i in items {
                                let user = UserModel(object: i)
                                userArray.append(user)
                            }
                            self.searchResult.value = userArray
                        }
                    }
                }catch{}
                
            }
        }.resume()
    }
}
