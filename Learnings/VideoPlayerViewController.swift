//
//  VideoPlayerViewController.swift
//  Learnings
//
//  Created by Hxtreme on 04/10/23.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var seekSlider: UISlider! {
        didSet {
            self.seekSlider.addTarget(self, action: #selector(onTapToSlide), for: .valueChanged)
        }
    }
    private var timeObserver : Any? = nil
    private var isThumbSeek : Bool = false
    private var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                lblTotalTime.textColor = .white
        lblCurrentTime.textColor = .white
    }
    
    func setupView() {
        playButton.layer.cornerRadius = playButton.frame.size.width / 2
        playButton.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        if player == nil {
            setupView()
            playVideo()
            setObserverToPlayer()
            videoView.bringSubviewToFront(lblCurrentTime)
            videoView.bringSubviewToFront(lblTotalTime)
            videoView.bringSubviewToFront(seekSlider)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {

//        let vc = AVPlayerViewController()
//        vc.player = player
//        self.present(vc, animated: true)
//        vc.player?.play()
//    }
    
    func playVideo() {
        let videoURL = URL(string: "https://static.pexels.com/lib/videos/free-videos.mp4")
        player = AVPlayer(url: videoURL!)
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self?.activityLoader.isHidden = true
                    } else {
                        self?.activityLoader.isHidden = false
                    }
                }
            }
            if newStatus == .paused {
                self.playButton.isHidden = false
            } else {
                self.playButton.isHidden = true
            }
        }
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        if !(player?.isPlaying ?? true){
            player?.play()
            playButton.isHidden = true
            pauseButton.isHidden = false
        }
    }
    
    
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        if (player?.isPlaying ?? false){
            player?.pause()
            playButton.isHidden = false
            pauseButton.isHidden = true
        }
    }
}

// Slider actions with time label
extension VideoPlayerViewController {
   
    private func setObserverToPlayer() {
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
            self.updatePlayerTime()
        })
    }
    
    private func updatePlayerTime() {
        guard let currentTime = self.player?.currentTime() else { return }
        guard let duration = self.player?.currentItem?.duration else { return }
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isThumbSeek == false {
            self.seekSlider.value = Float(currentTimeInSecond/durationTimeInSecond)
        }
        
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        
        var hours = value / 3600
        var mins =  (value / 60).truncatingRemainder(dividingBy: 60)
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lblCurrentTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
        
        hours = durationTimeInSecond / 3600
        mins = (durationTimeInSecond / 60).truncatingRemainder(dividingBy: 60)
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lblTotalTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
    }
    
   
    @objc private func onTapToSlide() {
        self.isThumbSeek = true
        guard let duration = self.player?.currentItem?.duration else { return }
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        if value.isNaN == false {
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed {
                    self.isThumbSeek = false
                }
            })
        }
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
