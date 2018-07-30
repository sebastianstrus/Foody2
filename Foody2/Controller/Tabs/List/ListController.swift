//
//  ListController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ListController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var listView: ListView!
    private let myCellId = "myCellId"
    private var allMeals: [Meal]  = []
    
    var locationManager = CLLocationManager()
    var isLoggedIn: Bool!
    var userLocation: CLLocation?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn = Auth.auth().currentUser?.uid != nil
        if isLoggedIn {
            locationManager.delegate = self
            setupNavigationBar(title: "List".localized)
            setupView()
            FirebaseHandler.getMeals(favorites: nil) { (meals) in
                self.allMeals = meals
                self.locationManager.startUpdatingLocation()
            }
        } else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoggedIn {
            FirebaseHandler.getMeals(favorites: nil) { (meals) in
                // prevent reloading data if there is no new meal
                if (meals.count != self.allMeals.count) {
                    self.allMeals = meals
                    self.locationManager.startUpdatingLocation()
                }
            }
        }
    }
    
    private func setupView() {
        let listView = ListView()
        self.listView = listView
        view.addSubview(listView)
        listView.pinToEdges(view: view)
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.allowsSelection = true
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
        cell.pictureImageView.image = nil
        cell.pictureImageView.load(urlString: allMeals[indexPath.item].imageUrlString!)
        cell.cosmosView.rating = allMeals[indexPath.item].rating!
        // set distance
        if let useLoc = userLocation {
            let mealLocation = CLLocation(latitude: allMeals[indexPath.item].placeLatitude!, longitude: allMeals[indexPath.item].placeLongitude!)
            let distanceInMeters = useLoc.distance(from: mealLocation)
            if distanceInMeters > 999 {
                if distanceInMeters < 100000 {
                    cell.distanceLabel.text = "\(Double(distanceInMeters/1000).roundedDecimal(to: 1)) km"
                } else {
                    cell.distanceLabel.text = "\(Int(distanceInMeters/1000)) km"
                }
            } else {
                cell.distanceLabel.text = "\(Int(distanceInMeters)) m"
            }
        }
        return cell
    }

    // MARK: - UITableViewDelegate functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Device.IS_IPHONE ? 80 : 160
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //TODO: remove from firebase
            allMeals.remove(at: indexPath.row)
            listView.tableView.deleteRows(at: [indexPath], with: .fade)
            listView.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealController = MealController()
        mealController.meal = allMeals[indexPath.row]
        navigationController?.pushViewController(mealController, animated: true)
    }
    
    // MARK: - Helpers
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let welcomeController = WelcomeController()
        present(welcomeController, animated: true)
    }
    
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error == nil {
                completion(UIImage(data: data!))
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            DispatchQueue.global(qos: .userInteractive).async {
                self.userLocation = location
                self.locationManager.stopUpdatingLocation()
                DispatchQueue.main.async {
                    self.listView.tableView.reloadData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
