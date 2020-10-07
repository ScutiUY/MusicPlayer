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
    
    var player: AVAudioPlayer!
    var timer: Timer!
    var mp3Data: Data?
    
    lazy var panelStackView = PanelStackView()
    
    lazy var albumCover: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var lyricsTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .purple
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textColor = .yellow
        textView.text = "Sleep inside the eye of your mind~ don't you know in ma mind, a better place to play"
        return textView
    }()
    lazy var progressSlider: UISlider = {
        var slider = UISlider()
        return slider
    }()
    
    lazy var timeLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePlayer()
        setLayout()
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK:- 레이아웃 세팅
    private func setLayout() {
        
        view.addSubview(albumCover)
        view.addSubview(panelStackView)
        

        
        //앨범 커버
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
        albumCover.layer.cornerRadius = albumCover.frame.size.height / 2
        
        // 아래 content 전체 스택 뷰
        panelStackView.snp.makeConstraints { (c) in
            c.top.equalTo(view.snp.top).offset(view.frame.height/2 + 5)
            c.leading.equalTo(view.snp.leading).offset(20)
            c.trailing.equalTo(view.snp.trailing).offset(-20)
            c.bottom.equalTo(view.snp.bottom).offset(-50)
        }
        
    }
    
    //MARK:- Player 세팅
    func initializePlayer() {
        
        guard let data = mp3Data else {
            fatalError("Invalid mp3Data")
        }
        do {
            try self.player = AVAudioPlayer(data: data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
        
        self.progressSlider.maximumValue = Float(playList[0].duration)
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = 0
        player.play()
    }
    
    func updateTimeLabelText(time: TimeInterval) {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        let milisecond: Int = Int(time.truncatingRemainder(dividingBy: 1) * 100)
        
        let timeText: String = String(format: "%02ld:%02ld:%02ld", minute, second, milisecond)
        
        self.timeLabel.text = timeText
    }

    
    func makeAndFireTimer() {
        var count = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if self.progressSlider.isTracking { return }
            self.updateTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
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
extension MusicPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
