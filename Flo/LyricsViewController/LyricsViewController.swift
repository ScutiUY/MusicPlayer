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
    
    lazy var viewBackgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var dimmingView: UIVisualEffectView = {
        var view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return view
    }()
    
    lazy var closeLyricsViewButton: UIButton = {
        var button = UIButton()
        button.setTitle("Close", for: .normal)
        button.titleLabel!.textColor = .white
        return button
    }()
    
    lazy var musicInfoView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var albumCover: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(data: playList[0].imageData!)
        return imageView
    }()
    
    lazy var songTitle: UILabel = {
        var label = UILabel()
        label.text = playList[0].title
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
    
    lazy var lyricstableView: UITableView = {
        var tableView = UITableView()
        return tableView
    }()
    
    lazy var lyricsTextView: UITextView = {
        var textView = UITextView()
        textView.textColor = .white
        textView.text = playList[0].lyrics
        textView.backgroundColor = .clear
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 20
        let attributes = [NSAttributedString.Key.paragraphStyle : style]
        textView.attributedText = NSAttributedString(string: playList[0].lyrics, attributes: attributes)
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        closeLyricsViewButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(ProgressBarAndTimeLabelStackView.shared)
        view.addSubview(AudioControlButtonStackView.shared)
        AudioControlButtonStackView.shared.snp.makeConstraints { (m) in
            m.bottom.equalTo(view.snp.bottom).offset(-50)
            m.width.equalToSuperview().multipliedBy(0.7)
            m.centerX.equalToSuperview()
        }
        ProgressBarAndTimeLabelStackView.shared.snp.makeConstraints { (m) in
            m.width.equalToSuperview().multipliedBy(0.7)
            m.bottom.equalTo(AudioControlButtonStackView.shared.snp.top).offset(-10)
            m.centerX.equalToSuperview()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressBarAndTimeLabelStackView.shared.removeFromSuperview()
        AudioControlButtonStackView.shared.removeFromSuperview()
    }
    private func setLayout() {

        view.addSubview(viewBackgroundImage)
        view.addSubview(dimmingView)
        
        view.addSubview(musicInfoView)
    
        musicInfoView.addSubview(albumCover)
        musicInfoView.addSubview(songTitle)
        musicInfoView.addSubview(artist)
        
        view.addSubview(closeLyricsViewButton)

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

        musicInfoView.snp.makeConstraints { (m) in
            if #available(iOS 11.0, *) {
                m.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                m.top.equalTo(view.snp.top).offset(20)
            }
            m.width.equalTo(view.snp.width).multipliedBy(0.9)
            m.centerX.equalTo(view.snp.centerX)
            m.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
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
            m.trailing.equalTo(musicInfoView.snp.trailing)
        }
        artist.snp.makeConstraints { (m) in
            m.centerY.equalTo(musicInfoView.snp.centerY).multipliedBy(1.3)
            m.height.equalTo(musicInfoView.snp.height).multipliedBy(0.5)
            m.leading.equalTo(albumCover.snp.trailing).offset(5)
            m.trailing.equalTo(musicInfoView.snp.trailing)
        }
//        lyricsTextView.snp.makeConstraints { (m) in
//            m.top.equalTo(musicInfoView.snp.bottom).offset(10)
//            m.leading.equalTo(musicInfoView.snp.leading)
//            m.width.equalTo(view.snp.width).multipliedBy(0.8)
//            m.centerX.equalToSuperview()
//            m.bottom.equalTo(ProgressBarAndTimeLabelStackView.shared.snp.top).offset(-20)
//        }
        
        closeLyricsViewButton.snp.makeConstraints { (m) in
            m.top.equalTo(musicInfoView.snp.bottom)
            m.width.equalTo(50)
            m.height.equalTo(50)
            m.leading.equalTo(view.snp.leading)
        }
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
extension LyricsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lyricstableView.dequeueReusableCell(withIdentifier: "cell") as? LyricsTableViewCell
        return cell!
    }
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

