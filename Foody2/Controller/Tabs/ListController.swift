//
//  ListController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase

class ListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var listView: ListView!
    
    
    private let myCellId = "myCellId"
    private var allMeals: [Meal]  = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        
//        let ref = Database.database().reference(fromURL: "https://foody-4454f.firebaseio.com/")
//        ref.updateChildValues(["someValue" : 123123])
        
        //get data from FireBase on background thread
        TestData.getMeals(complition: { (meals) in
            self.allMeals = meals
            self.listView.tableView.reloadData()
        })

        setupNavigationBar(title: Strings.LIST)
        setupView()
        
    }
    
    
    private func setupView() {
        let listView = ListView()
        self.listView = listView
        
        view.addSubview(listView)
        listView.pinToEdges(view: view)
        
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.register(ListCell.self, forCellReuseIdentifier: myCellId)
    }
    
    
    // MARK: - UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMeals.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! ListCell
        cell.titleLabel.text = allMeals[indexPath.item].title
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPHONE ? 80 : 160
    }
    
    // MARK: - UITableViewDelegate functions
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: remove from firebase
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Helpers
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            // remove warning from the console by using performSelector
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let welcomeController = WelcomeController()
        present(welcomeController, animated: true)
    }
}
