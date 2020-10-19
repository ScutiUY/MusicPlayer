//
//  LyricsViewController.swift
//  Flo
//
//  Created by 신의연 on 2020/10/01.
//

import UIKit
import SnapKit
import MarqueeLabel

class LyricsViewController: UIViewController {
    
    var isLyricsButtonOn = false
    
    lazy var viewBackgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var dimmingView: UIVisualEffectView = {
        var view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return view
    }()
    
    
    lazy var musicInfoView: UIView = {
        var view = UIView()
        return view
    }()
    
    lazy var albumCover = AlbumCoverView(frame: .zero)
    
    lazy var songTitle: MarqueeLabel = {
        var label = MarqueeLabel(frame: .zero, duration: 8, fadeLength: 10)
        label.text = "\(playList[0].title)       "
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var artist: UILabel = {
        var label = UILabel()
        label.text = playList[0].singer
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var lyricsToggleButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "lyricsUnselected"), for: .normal)
        button.setImage(UIImage(named: "lyricsSelected"), for: .selected)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        return button
    }()
    
    lazy var lyricsTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setTableViewDelegate()
        addNoti()
        addButtonAction()
    }
    
    // MARK:- viewDidAppear 동기화 문제로 AudioControlButtonStack과 ProgressBarAnTimeLabelStack 선언
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(ProgressBarAndTimeLabelStackView.shared)
        view.addSubview(AudioControlButtonStackView.shared)
        
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
        lyricsTableView.snp.makeConstraints { (m) in
            m.top.equalTo(musicInfoView.snp.bottom).offset(10)
            m.bottom.equalTo(ProgressBarAndTimeLabelStackView.shared.snp.top).offset(-10)
            m.centerX.equalTo(view.snp.centerX)
            m.width.equalTo(view.snp.width).multipliedBy(0.9)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressBarAndTimeLabelStackView.shared.removeFromSuperview()
        AudioControlButtonStackView.shared.removeFromSuperview()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .getCurrentTime, object: nil)
    }
    
    // MARK: - 레이아웃 세팅
    private func setLayout() {
        
        view.addSubview(viewBackgroundImage)
        view.addSubview(dimmingView)
        view.addSubview(musicInfoView)
        view.addSubview(lyricsTableView)
        
        musicInfoView.addSubview(closeButton)
        musicInfoView.addSubview(lyricsToggleButton)
        
        musicInfoView.addSubview(albumCover)
        musicInfoView.addSubview(songTitle)
        musicInfoView.addSubview(artist)
        
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
        
        musicInfoView.snp.makeConstraints { (m) in
            m.centerY.equalTo(view.snp.centerY).multipliedBy(0.2)
            m.centerX.equalTo(view.snp.centerX)
            m.width.equalTo(view.snp.width).multipliedBy(0.9)
            m.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        albumCover.layer.cornerRadius = 10
        albumCover.snp.makeConstraints { (m) in
            m.width.equalTo(musicInfoView.snp.height)
            m.height.equalTo(musicInfoView.snp.height)
            m.leading.equalTo(musicInfoView.snp.leading)
            m.centerY.equalToSuperview()
        }
        songTitle.snp.makeConstraints { (m) in
            m.centerY.equalTo(musicInfoView.snp.centerY).multipliedBy(0.7)
            m.height.equalTo(musicInfoView.snp.height).multipliedBy(0.5)
            m.leading.equalTo(albumCover.snp.trailing).offset(5)
            m.trailing.equalTo(closeButton.snp.leading).offset(-5)
        }
        artist.snp.makeConstraints { (m) in
            m.centerY.equalTo(musicInfoView.snp.centerY).multipliedBy(1.3)
            m.height.equalTo(musicInfoView.snp.height).multipliedBy(0.5)
            m.leading.equalTo(albumCover.snp.trailing).offset(5)
            m.trailing.equalTo(closeButton.snp.leading).offset(-5)
        }
        
        closeButton.snp.makeConstraints { (m) in
            m.width.equalTo(albumCover.snp.width).multipliedBy(0.5)
            m.height.equalTo(albumCover.snp.height).multipliedBy(0.5)
            m.top.equalTo(musicInfoView.snp.top)
            m.trailing.equalTo(musicInfoView.snp.trailing)
        }
        lyricsToggleButton.snp.makeConstraints { (m) in
            m.width.equalTo(albumCover.snp.width).multipliedBy(0.5)
            m.height.equalTo(albumCover.snp.height).multipliedBy(0.5)
            m.bottom.equalTo(musicInfoView.snp.bottom)
            m.trailing.equalTo(musicInfoView.snp.trailing)
        }
        
        
        
        
    }
    //MARK: - TableView Setting
    func setTableViewDelegate() {
        lyricsTableView.delegate = self
        lyricsTableView.dataSource = self
        lyricsTableView.register(LyricsTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //MARK: - Notification Adding
    func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotiTimeLabelText), name: .getCurrentTime, object: nil)
    }
    //MARK: - add Button Method
    func addButtonAction() {
        lyricsToggleButton.addTarget(self, action: #selector(lyricsToggle), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    @objc func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func lyricsToggle(sender: UIButton) {
        
        sender.isSelected.toggle()
        
        if sender.isSelected {
            isLyricsButtonOn = true
        } else {
            isLyricsButtonOn = false
        }
    }
    
    @objc func updateNotiTimeLabelText() {
        let minute: Int = Int(SoundManager.shared.player.currentTime / 60)
        let second: Int = Int(SoundManager.shared.player.currentTime.truncatingRemainder(dividingBy: 60))
        
        let timeText: String = String(format: "%02ld:%02ld", minute, second)
        
        ProgressBarAndTimeLabelStackView.shared.timeLabel.text = timeText
        
        updateLyricsTextView()
    }
    
    func updateLyricsTextView() {
        let currentTime = floor(Double(SoundManager.shared.player.currentTime) * 10) / 10
        // Scroll the textView
        guard let row = refineLyrics.lastIndex(where: {$0.0 <= currentTime}) else {
            guard let selectedItems = lyricsTableView.indexPathsForSelectedRows else { return }
            for indxPath in selectedItems {
                lyricsTableView.deselectRow(at: indxPath, animated: false)
            }
            lyricsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            return
        }
        let indxPath = IndexPath(row: Int(row), section: 0)
        lyricsTableView.selectRow(at: indxPath, animated: true, scrollPosition: .middle)
    }
    
}
extension LyricsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refineLyrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lyricsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LyricsTableViewCell
        cell.backgroundColor = .clear
        cell.textLabel?.text = refineLyrics[indexPath.row].1
        cell.textLabel?.textColor = .gray
        cell.selectionStyle = .none
        return cell
    }
    //MARK: - tableView Selected Function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = lyricsTableView.cellForRow(at: indexPath)!
        
        if isLyricsButtonOn {
            cell.textLabel?.textColor = .white
            SoundManager.shared.player.currentTime = TimeInterval(refineLyrics[indexPath.row].0)
            lyricsTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            
        } else {
            cell.textLabel?.textColor = .gray
            self.dismiss(animated: true, completion: nil)
        }
    }
}

