//
//  MusicPlayerViewController.swift
//  Flo
//
//  Created by 신의연 on 2020/10/01.
//

import UIKit
import SnapKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    var mp3Data: Data?
    
    lazy var panelStackView = PanelStackView()
    
    lazy var viewBackgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var dimmingView: UIVisualEffectView = {
        var view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return view
    }()
    
    lazy var albumCover: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let lyricsAnimator = LyricsAnimationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SoundManager.shared.initializedPlayer(soundData: mp3Data)
        setLayout()
        addAction()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
        view.layoutIfNeeded()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    //MARK:- 레이아웃 세팅
    private func setLayout() {
        
        view.addSubview(viewBackgroundImage)
        view.addSubview(dimmingView)
        view.addSubview(albumCover)
        view.addSubview(panelStackView)
        view.addSubview(ProgressBarAndTimeLabelStackView.shared)
        view.addSubview(AudioControlButtonStackView.shared)
        //앨범 커버
        
        viewBackgroundImage.image = albumCover.image
        
        viewBackgroundImage.snp.makeConstraints { (m) in
            m.center.equalTo(view.snp.center)
            m.width.equalTo(view.snp.width)
            m.height.equalTo(view.snp.height)
        }
        
        dimmingView.snp.makeConstraints { (m) in
            m.center.equalTo(view.snp.center)
            m.width.equalTo(view.snp.width)
            m.height.equalTo(view.snp.height)
        }
        
        albumCover.snp.makeConstraints { (c) in
            if #available(iOS 11.0, *) {
                c.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY).multipliedBy(0.6)
            } else {
                c.centerY.equalTo(view.snp.centerY).multipliedBy(0.6)
            }
            c.centerX.equalTo(view.snp.centerX)
            c.width.equalTo(view.snp.width).multipliedBy(0.7)
            c.height.equalTo(view.snp.width).multipliedBy(0.7)
        }
        
        // 아래 content 전체 스택 뷰
        panelStackView.snp.makeConstraints { (c) in
            c.top.equalTo(view.snp.top).offset(view.frame.height/2 + 5)
            c.leading.equalTo(view.snp.leading).offset(20)
            c.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        ProgressBarAndTimeLabelStackView.shared.snp.makeConstraints { (m) in
            m.width.equalToSuperview().multipliedBy(0.7)
            m.bottom.equalTo(AudioControlButtonStackView.shared.snp.top).offset(-10)
            m.centerX.equalToSuperview()
        }
        AudioControlButtonStackView.shared.snp.makeConstraints { (m) in
            m.width.equalToSuperview().multipliedBy(0.7)
            m.centerX.equalToSuperview()
            m.bottom.equalTo(view.snp.bottom).offset(-50)
        }
        
    }
    
    //MARK:- 재생 시간 업데이트
    func updateTimeLabelText(time: TimeInterval) {
        
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        
        let timeText: String = String(format: "%02ld:%02ld", minute, second)
        
        ProgressBarAndTimeLabelStackView.shared.timeLabel.text = timeText
    }
    //MARK:- Timer 시작
    func makeAndFireTimer() {
        TimerManger.shared.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer: Timer) in
            
            if ProgressBarAndTimeLabelStackView.shared.progressSlider.isTracking { return }
            self.updateTimeLabelText(time: SoundManager.shared.player.currentTime)
            ProgressBarAndTimeLabelStackView.shared.progressSlider.value = Float(SoundManager.shared.player.currentTime)
            updateLyricsTextView()
        })
        TimerManger.shared.timer.fire()
        print(TimerManger.shared.timer.isValid)
    }
    //MARK:- 타이머 멈추기
    func invalidateTimer() {
        TimerManger.shared.timer?.invalidate()
        TimerManger.shared.timer = nil
    }
    
    //MARK:- 가사 업데이트
    func updateLyricsTextView() {
        
        let progress = SoundManager.shared.player.currentTime / SoundManager.shared.player.duration
        
        let characters = panelStackView.lyricsTextView.text.count
        
        // Calculate where to scroll
        let location = Double(characters) * progress
        
        // Scroll the textView
        panelStackView.lyricsTextView.scrollRangeToVisible(NSRange(location: Int(location), length: 10))
    }
    
    //MARK:- addAction to Views
    func addAction() {
        let playPauseButton = AudioControlButtonStackView.shared.playPauseButton
        let progressSlider = ProgressBarAndTimeLabelStackView.shared.progressSlider
        let lyricsTextView = panelStackView.lyricsTextView
        
        playPauseButton.addTarget(self, action: #selector(touchUpPlayPauseButton), for: .touchUpInside)
        
        playPauseButton.addTarget(self, action: #selector(touchDownPlayPauseButton), for: .touchDown)
        playPauseButton.addTarget(self, action: #selector(touchCancelPlayPauseButton(_:)) , for: .touchUpOutside)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentLyricsView))
        lyricsTextView.addGestureRecognizer(tapGesture)
    }
    
    //MARK:- View Action
    @objc func touchUpPlayPauseButton(_ sender: UIButton) {
        print("musicplayer touched")
        print("play button is selected?",sender.isSelected)
        sender.transform = .identity
        
        sender.isSelected.toggle()
        
        if sender.isSelected {
            DispatchQueue.global(qos: .background).async {
                SoundManager.shared.player?.play()
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                SoundManager.shared.player?.pause()
            }
        }
        
        if sender.isSelected {
            self.makeAndFireTimer()
        } else {
            self.invalidateTimer()
        }
        
    }
    @objc func sliderValueChanged(_ sender: UISlider) {
        self.updateTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        SoundManager.shared.player.currentTime = TimeInterval(sender.value)
    }
    @objc func touchDownPlayPauseButton(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    @objc func touchCancelPlayPauseButton(_ sender: UIButton) {
        sender.transform = .identity
    }
    
    //MARK: - present
    @objc func presentLyricsView(_ gesutre: UITapGestureRecognizer) {
        let LyricsVC = UIStoryboard(name: "LyricsSB", bundle: nil).instantiateViewController(withIdentifier: "LyricsSB") as! LyricsViewController
        LyricsVC.transitioningDelegate = self
        LyricsVC.modalPresentationStyle = .fullScreen
        LyricsVC.view.backgroundColor = self.view.backgroundColor
        lyricsAnimator.targetImage = albumCover.image
        lyricsAnimator.targetTextView = panelStackView.lyricsTextView
        present(LyricsVC, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

//MARK:- TransitioningDelegate
extension MusicPlayerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        lyricsAnimator.presenting = true
        return lyricsAnimator
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        lyricsAnimator.presenting = false
        return lyricsAnimator
    }
}
