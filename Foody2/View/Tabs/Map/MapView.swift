//
//  MapView.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-06-28.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {
    
    lazy var mapView: MKMapView = {
        var mv = MKMapView()
        return mv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(mapView)
        mapView.pinToEdges(view: self)
    }
}
