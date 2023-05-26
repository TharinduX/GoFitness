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
        label.font = UIFont(name: "OpenSans-Bold", size: 16)
        label.textColor = UIColor(named: "primary")
        label.numberOfLines = 0
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .systemGreen
        return button
    }()

    private let stopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()

    private let resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = .systemYellow
        return button
    }()

    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0

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
        view.addSubview(timeLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(resetButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(playerViewController!.view.snp.bottom).offset(5)
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
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bodyPartsLabel.snp.bottom).offset(20)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-75)
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.width.height.equalTo(80)
        }
        
        stopButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(startButton)
            make.width.height.equalTo(80)
        }
        
        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(75)
            make.centerY.equalTo(startButton)
            make.width.height.equalTo(80)
        }
        
        playVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupButtonTargets()
    }
    
    private func setupButtonTargets() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
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
        
        updateTimeLabel()
    }

    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }

    @objc private func startButtonTapped() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        }
    }

    @objc private func stopButtonTapped() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func resetButtonTapped() {
        timer?.invalidate()
        elapsedTime = 0.0
        updateTimeLabel()
    }

    @objc private func updateTimeLabel() {
        let minutes = Int(elapsedTime / 60)
        let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((elapsedTime * 10).truncatingRemainder(dividingBy: 10))
        
        timeLabel.text = String(format: "%02d:%02d:%01d", minutes, seconds, milliseconds)
        
        elapsedTime += 0.1
    }
}
