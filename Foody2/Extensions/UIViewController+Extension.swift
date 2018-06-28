//
//  UIViewController+Extension.swift
//  FireBaseSample
//
//  Created by Sebastian Strus on 2018-06-15.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import AVKit

extension UIViewController {
    func playVideo(title: String) {
        let path = Bundle.main.path(forResource: title, ofType:"mov")
        let player = AVPlayer(url: URL(fileURLWithPath: path!))
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        self.addChild(playerController)
        playerController.view.frame = UIScreen.main.bounds
        playerController.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        self.view.addSubview(playerController.view)
        player.play()
        // repead video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    func setupNavigationBar(title: String) {
        view.backgroundColor = .white
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: AppFonts.NAV_BAR_FONT]
    }
}
