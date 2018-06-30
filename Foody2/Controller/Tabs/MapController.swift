//
//  MapController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit


class MapController: UIViewController {
    
    private var mapView: MapView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupNavigationBar(title: Strings.MAP)
        setupMapView()
        

    }
    
    private func setupMapView() {
        let mapView = MapView()
        self.mapView = mapView
        view.addSubview(mapView)
        mapView.pinToEdges(view: view)
    }
    

}
