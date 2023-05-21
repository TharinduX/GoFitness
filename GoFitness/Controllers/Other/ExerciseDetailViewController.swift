//
//  ExerciseDetailViewController.swift
//  GoFitness
//
//  Created by Tharindu on 2023-05-20.
//

import UIKit
import AVKit
import SnapKit

class ExerciseDetailViewController: UIViewController {
    
    var exercise: [String: Any]?
    private var playerViewController: AVPlayerViewController?
    private var player: AVPlayer?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IntegralCF-Bold", size: 24)
        label.textColor = .white
        return label
    }()
    
    private let setsRepsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.textColor = UIColor(named: "primary")
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let bodyPartsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-bold", size: 16)
        label.textColor = UIColor(named: "primary")
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        
        playerViewController = AVPlayerViewController()
        playerViewController?.view.backgroundColor = .clear
        
        addChild(playerViewController!)
        view.addSubview(playerViewController!.view)
        playerViewController!.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width * 9 / 16 + 100)
        playerViewController!.didMove(toParent: self)
        
        view.addSubview(titleLabel)
        view.addSubview(setsRepsLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(bodyPartsLabel)
        

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(playerViewController!.view.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        setsRepsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(setsRepsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        bodyPartsLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        playVideo()
    }
    
    private func playVideo() {
        guard let exercise = exercise, let videoURLString = exercise["video"] as? String, let videoURL = URL(string: videoURLString) else {
            return
        }
        
        player = AVPlayer(url: videoURL)
        
        playerViewController?.player = player

        player?.automaticallyWaitsToMinimizeStalling = false
        player?.play()
        player?.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        
        titleLabel.text = exercise["name"] as? String
        setsRepsLabel.text = "Sets: \(exercise["sets"] ?? "") • Reps: \(exercise["reps"] ?? "")"
        descriptionLabel.text = exercise["description"] as? String
        
        if let bodyParts = exercise["bodyParts"] as? [String] {
            let formattedBodyParts = bodyParts.map { $0.capitalized }.joined(separator: ", ")
            bodyPartsLabel.text = "Effective body parts: \(formattedBodyParts)"
        } else {
            bodyPartsLabel.text = ""
        }
    }
    
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }
    
}