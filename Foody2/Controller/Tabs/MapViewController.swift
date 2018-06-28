//
//  MapViewController.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-12.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    
    private let mapView: MKMapView = {
        let mv = MKMapView()
        return mv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(title: Strings.MAP)
        setupMapView()
        

    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.pinToEdges(view: view)
    }
    

}
