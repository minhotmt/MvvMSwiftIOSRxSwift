//
//  ViewController.swift
//  DemoMVVMSwiftIIOS
//
//  Created by MinKo on 9/29/19.
//  Copyright © 2019 MinKo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableviewName: UITableView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    var userViewModel = UserViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindUI()
    }
    
    func bindUI(){
        self.textFieldSearch.rx.text.asObservable().bind(to: self.userViewModel.searchInput).addDisposableTo(disposeBag)
        self.userViewModel.searchResult.asObservable().bindTo(self.tableviewName.rx.items(cellIdentifier: "Cell", cellType: NameCell.self)) {
            (index, user, cell) in
            cell.labelName.text = user.userName
            
        }.addDisposableTo(disposeBag)
    }

}

