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
    var locationManager = CLLocationManager()
    var isLogged: Bool!
    private let myCellId = "myCellId"
    private var allMeals: [Meal]  = []
    var userLocation: CLLocation?
    
    //data for testing:
//    private var allMeals: [Meal]  = [Meal(title: "meal1", imageUrlString: "https://firebasestorage.googleapis.com/v0/b/foody-4454f.appspot.com/o/meals_images%2FB9C5CD46-3456-466D-9CE5-E5775A98F59E.png?alt=media&token=fa322f67-638f-4236-9f55-8dc837467065", rating: 3.5, date: "27.07.2018", isFavorite: true, mealDescription: "Det var soligt", placeLatitude: 65.83220512169559, placeLongitude: 17.39847067977414, price: "101"), Meal(title: "meal2", imageUrlString: "https://firebasestorage.googleapis.com/v0/b/foody-4454f.appspot.com/o/meals_images%2FB9C5CD46-3456-466D-9CE5-E5775A98F59E.png?alt=media&token=fa322f67-638f-4236-9f55-8dc837467065", rating: 1.5, date: "27.07.2018", isFavorite: true, mealDescription: "Det var soligt", placeLatitude: 20.83220512169559, placeLongitude: 20.39847067977414, price: "101")]
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLogged = Auth.auth().currentUser?.uid != nil
        if (isLogged) {
            
            locationManager.delegate = self
            //locationManager.requestLocation()
            locationManager.startUpdatingLocation()//much faster

            
            setupNavigationBar(title: "List".localized)
            setupView()
            
            //getMealsFromFirebase()
            //allMeals = getMealsFromFirebase()
            //TODO
            //perform(#selector(updateTableView), with: nil, afterDelay: 2)
        }
        else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }


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
        print("viewDidAppear run")
        
        if isLogged {
            allMeals = []
            getMealsFromFirebase()//TODO: change
            perform(#selector(updateTableView), with: nil, afterDelay: 2)
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
            if distanceInMeters > 1000 {
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        let mealController = MealController()
        mealController.meal = allMeals[indexPath.row]
        print(mealController.meal ?? "meal is nil")
        //present()
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
    
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
            self.userLocation = location
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
