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
    
    let lyricsAnimator = LyricsAnimationController()
    
    lazy var viewBackgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var dimmingView: UIVisualEffectView = {
        var view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return view
    }()
    
    lazy var albumCover = AlbumCoverView(frame: .zero)
    
    lazy var panelStackView = PanelStackView()
    
    
    // MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        SoundManager.shared.initializedPlayer(soundData: mp3Data)
        setLayout()
        addAction()
        addNoti()
        lyricsTableViewSetting()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
        addNoti()
        view.layoutIfNeeded()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .getCurrentTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AudioPlayerDidFinishPlaying, object: nil)
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
        
        panelStackView.snp.makeConstraints { (c) in
            c.top.equalTo(view.snp.top).offset(view.frame.height/2 + 5)
            c.leading.equalTo(view.snp.leading).offset(20)
            c.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        ProgressBarAndTimeLabelStackView.shared.snp.makeConstraints { (m) in
            m.width.equalToSuperview().multipliedBy(0.9)
            m.bottom.equalTo(AudioControlButtonStackView.shared.snp.top).offset(-10)
            m.centerX.equalToSuperview()
        }
        AudioControlButtonStackView.shared.snp.makeConstraints { (m) in
            m.width.equalToSuperview().multipliedBy(0.9)
            m.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                m.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                m.bottom.equalTo(view.snp.bottom).offset(-10)
            }
        }
    }
    
    //MARK: - TableView Setting
    private func lyricsTableViewSetting() {
        panelStackView.lyricsTableView.delegate = self
        panelStackView.lyricsTableView.dataSource = self
        panelStackView.lyricsTableView.register(LyricsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    
    //MARK:- 재생 시간 업데이트
    private func updateTimeLabelText(time: TimeInterval) {
        print("수동 재생시간 업데이트")
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        
        let timeText: String = String(format: "%02ld:%02ld", minute, second)
        
        ProgressBarAndTimeLabelStackView.shared.timeLabel.text = timeText
        
        updateLyricsTextView()
    }
    
    @objc func updateNotiTimeLabelText() {
        print("자동 재생시간 업데이트")
        let minute: Int = Int(SoundManager.shared.player.currentTime / 60)
        let second: Int = Int(SoundManager.shared.player.currentTime.truncatingRemainder(dividingBy: 60))
        
        let timeText: String = String(format: "%02ld:%02ld", minute, second)
        
        ProgressBarAndTimeLabelStackView.shared.timeLabel.text = timeText
        updateLyricsTextView()
    }
    
    //MARK:- 가사 업데이트
    private func updateLyricsTextView() {
        
        let currentTime = floor(Double(SoundManager.shared.player.currentTime) * 10) / 10
        // Scroll the textView
        guard let row = refineLyrics.lastIndex(where: {$0.0 <= currentTime}) else {
            guard let selectedItems = panelStackView.lyricsTableView.indexPathsForSelectedRows else { return }
            for indxPath in selectedItems {
                panelStackView.lyricsTableView.deselectRow(at: indxPath, animated: false)
            }
            panelStackView.lyricsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            return
        }
        let indxPath = IndexPath(row: Int(row), section: 0)
        panelStackView.lyricsTableView.selectRow(at: indxPath, animated: false, scrollPosition: .top)
        
    }
    
    //MARK: -  Add Notification Observer
    private func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotiTimeLabelText), name: .getCurrentTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayButton), name: .AudioPlayerDidFinishPlaying, object: nil)
    }
    
    //MARK:- addAction to Views
    private func addAction() {
        let playPauseButton = AudioControlButtonStackView.shared.playPauseButton
        let progressSlider = ProgressBarAndTimeLabelStackView.shared.progressSlider
        
        playPauseButton.addTarget(self, action: #selector(touchUpPlayPauseButton), for: .touchUpInside)
        
        playPauseButton.addTarget(self, action: #selector(touchDownPlayPauseButton), for: .touchDown)
        playPauseButton.addTarget(self, action: #selector(touchCancelPlayPauseButton(_:)) , for: .touchUpOutside)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentLyricsView))
        panelStackView.lyricsTableView.addGestureRecognizer(tapGesture)
    }
    
    //MARK:- View Action
    @objc func touchUpPlayPauseButton(_ sender: UIButton) {
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
            TimerManger.shared.makeAndFireTimer(vc: self)
        } else {
            TimerManger.shared.invalidateTimer()
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
    @objc func resetPlayButton() {
        AudioControlButtonStackView.shared.playPauseButton.isSelected = false
    }
    
    //MARK: - present
    @objc func presentLyricsView(_ gesutre: UITapGestureRecognizer) {
        let LyricsVC = UIStoryboard(name: "LyricsSB", bundle: nil).instantiateViewController(withIdentifier: "LyricsSB") as! LyricsViewController
        LyricsVC.transitioningDelegate = self
        LyricsVC.modalPresentationStyle = .fullScreen
        LyricsVC.view.backgroundColor = self.view.backgroundColor
        LyricsVC.albumCover.image = albumCover.image
        LyricsVC.viewBackgroundImage.image = albumCover.image
        lyricsAnimator.targetImage = albumCover.image
        lyricsAnimator.targetTableView = panelStackView.lyricsTableView
        present(LyricsVC, animated: true, completion: nil)
    }
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

//MARK:- TableView DataSource, Delegate
extension MusicPlayerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refineLyrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = panelStackView.lyricsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LyricsTableViewCell
        cell.backgroundColor = .clear
        cell.textLabel!.text = refineLyrics[indexPath.row].1
        cell.textLabel?.textColor = .gray
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return panelStackView.lyricsTableView.frame.height/2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = panelStackView.lyricsTableView.cellForRow(at: indexPath)!
        cell.textLabel?.textColor = .white
        panelStackView.lyricsTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = panelStackView.lyricsTableView.cellForRow(at: indexPath)!
        cell.textLabel?.textColor = .gray
    }
}
