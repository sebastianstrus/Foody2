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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        print("checked")
        
        setupNavigationBar(title: Strings.LIST)
        setupView()
        
        allMeals = getMealsFromFirebase()
        //TODO
        perform(#selector(updateTableView), with: nil, afterDelay: 2)
        
        //get data for testing on background thread
//        FirebaseHandler.getMeals(complition: { (meals) in
//            self.allMeals = meals
//            self.listView.tableView.reloadData()
//        })


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupView() {
        let listView = ListView()
        self.listView = listView
        
        view.addSubview(listView)
        listView.pinToEdges(view: view)
        
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.register(MealListCell.self, forCellReuseIdentifier: myCellId)
    }
    
    // MARK: - UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMeals.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCellId, for: indexPath) as! MealListCell
        cell.titleLabel.text = allMeals[indexPath.item].title
        return cell
    }

    // MARK: - UITableViewDelegate functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPHONE ? 80 : 160
    }
    
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
            //return
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
    
    // temp firebase
    func getMealsFromFirebase() -> [Meal] {
        var meals: [Meal] = []
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("meals").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let mealsDict = snapshot.value as? NSDictionary
            print("Meals:")
            if mealsDict != nil {
                print(mealsDict!)
                
                for json in (mealsDict!) {
                    let mJson = json.value as! [String : AnyObject]
                    guard let title = mJson["title"] as? String else { return }
                    guard let imageUrlString = mJson["imageUrlString"] as? String else { return }
                    guard let rating = mJson["rating"] as? Double else { return }
                    guard let date = mJson["date"] as? String else { return }
                    guard let isFavorite = mJson["isFavorite"] as? Bool else { return }
                    guard let mealDescription = mJson["mealDescription"] as? String else { return }
                    guard let placeLatitude = mJson["placeLatitude"] as? Double else { return }
                    guard let placeLongitude = mJson["placeLongitude"] as? Double else { return }
                    guard let price = mJson["price"] as? String else { return }
                    
                    let meal = Meal(title: title,
                                    imageUrlString: imageUrlString,
                                    rating: rating,
                                    date: date,
                                    isFavorite: isFavorite,
                                    mealDescription: mealDescription,
                                    placeLatitude: placeLatitude,
                                    placeLongitude: placeLongitude,
                                    price: price)
                    self.allMeals.append(meal)
                    print("title: \(meal.title) isFavorite: \(meal.isFavorite)")
                    print("count: \(self.allMeals.count)")
                }
            } else {
                print("No meals found")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        return meals
    }
    
    @objc func updateTableView() {
        listView.tableView.reloadData()
    }
}
