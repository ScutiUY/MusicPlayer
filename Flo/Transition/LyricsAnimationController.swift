//
//  LyricAnimationController.swift
//  Flo
//
//  Created by 신의연 on 2020/10/12.
//

import Foundation
import UIKit
import SnapKit

class LyricsAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = TimeInterval(0.2)
    var presenting = true
    var targetTableView: UITableView?
    var targetImage: UIImage?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        if presenting {
            
            guard let fromVC = transitionContext.viewController(forKey: .from) as? MusicPlayerViewController else { fatalError() }
            guard let toVC = transitionContext.viewController(forKey: .to) as? LyricsViewController else { fatalError() }
            guard let fromView = fromVC.view else { fatalError() }
            guard let toView = toVC.view else { fatalError() }
            
            toView.alpha = 0.0
            containerView.addSubview(toVC.view)
            
            let targetAlbumCover = fromVC.albumCover
            let targetMusicTitleLabel = fromVC.panelStackView.musicInfoStackView.songInfoStackView.songTitle
            let targetAlbumTitleLabel = fromVC.panelStackView.musicInfoStackView.songInfoStackView.albumTitle
            let targetArtistLabel = fromVC.panelStackView.musicInfoStackView.artist
            
            let albumCoverImageViewStartFrame = fromVC.albumCover.frame
            let musicTitleLabelStartFrame = fromVC.panelStackView.musicInfoStackView.convert(targetMusicTitleLabel.frame, to: fromView)
            let albumTitleLabelStartFrame = fromVC.panelStackView.musicInfoStackView.convert(targetAlbumTitleLabel.frame, to: fromView)
            let artistNameLabelStartFrame = fromVC.panelStackView.musicInfoStackView.convert(targetArtistLabel.frame, to: fromView)
            
            let musicInfoView = UIView()
            musicInfoView.backgroundColor = .clear
            
            let albumCoverImageView = UIImageView(frame: albumCoverImageViewStartFrame)
            albumCoverImageView.alpha = 1.0
            albumCoverImageView.contentMode = .scaleAspectFill
            albumCoverImageView.clipsToBounds = true
            albumCoverImageView.image = targetImage
            albumCoverImageView.layer.cornerRadius = 20
            
            let musicTitleLabel = UILabel(frame: musicTitleLabelStartFrame)
            musicTitleLabel.text = playList[0].title
            musicTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
            musicTitleLabel.textColor = .white

            let albumTitleLabel = UILabel(frame: albumTitleLabelStartFrame)
            albumTitleLabel.text = playList[0].albumTitle
            albumTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            albumTitleLabel.textColor = .white

            let artistNameLabel = UILabel(frame: artistNameLabelStartFrame)
            artistNameLabel.text = playList[0].singer
            artistNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            artistNameLabel.textColor = .lightGray
            
            containerView.addSubview(musicInfoView)
            containerView.addSubview(albumCoverImageView)
            containerView.addSubview(musicTitleLabel)
            containerView.addSubview(albumTitleLabel)
            containerView.addSubview(artistNameLabel)
            containerView.addSubview(ProgressBarAndTimeLabelStackView.shared)
            containerView.addSubview(AudioControlButtonStackView.shared)

            ProgressBarAndTimeLabelStackView.shared.snp.makeConstraints { (m) in
                m.width.equalToSuperview().multipliedBy(0.9)
                m.bottom.equalTo(AudioControlButtonStackView.shared.snp.top).offset(-10)
                m.centerX.equalToSuperview()
            }
            AudioControlButtonStackView.shared.snp.makeConstraints { (m) in
                m.width.equalToSuperview().multipliedBy(0.9)
                m.centerX.equalToSuperview()
                if #available(iOS 11.0, *) {
                    m.bottom.equalTo(containerView.safeAreaLayoutGuide.snp.bottom)
                } else {
                    m.bottom.equalTo(containerView.snp.bottom).offset(-10)
                }
            }

            musicInfoView.snp.makeConstraints { (m) in
                m.centerY.equalTo(containerView.snp.centerY).multipliedBy(0.2)
                m.centerX.equalTo(containerView.snp.centerX)
                m.width.equalTo(containerView.snp.width).multipliedBy(0.9)
                m.height.equalTo(containerView.snp.height).multipliedBy(0.1)
            }
            
            targetAlbumCover.alpha = 0.0
            targetMusicTitleLabel.alpha = 0.0
            targetAlbumTitleLabel.alpha = 0.0
            targetArtistLabel.alpha = 0.0
            targetTableView!.alpha = 0.0
            
            containerView.layoutIfNeeded()
            
            //MARK:- Presenting animation
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                
                albumCoverImageView.snp.remakeConstraints { (m) in
                    m.width.equalTo(musicInfoView.snp.height)
                    m.height.equalTo(musicInfoView.snp.height)
                    m.leading.equalTo(musicInfoView.snp.leading)
                    m.centerY.equalTo(musicInfoView.snp.centerY)
                }
                musicTitleLabel.snp.remakeConstraints { (m) in
                    m.centerY.equalTo(musicInfoView.snp.centerY).multipliedBy(0.7)
                    m.centerX.equalTo(containerView.snp.centerX)
                }
                albumTitleLabel.snp.remakeConstraints { (m) in
                    m.centerY.equalTo(musicInfoView.snp.centerY).multipliedBy(0.7)
                    m.centerX.equalTo(containerView.snp.centerX)
                }
                artistNameLabel.snp.remakeConstraints { (m) in
                    m.centerY.equalTo(musicInfoView.snp.centerY).multipliedBy(1.3)
                    m.centerX.equalTo(containerView.snp.centerX)
                }
                
                albumCoverImageView.layer.cornerRadius = 10
                musicTitleLabel.alpha = 0.0
                albumTitleLabel.alpha = 0.0
                artistNameLabel.alpha = 0.0
                
                containerView.layoutIfNeeded()
            } completion: { (complement) in
                
                musicInfoView.removeFromSuperview()
                albumCoverImageView.removeFromSuperview()
                musicTitleLabel.removeFromSuperview()
                albumTitleLabel.removeFromSuperview()
                artistNameLabel.removeFromSuperview()
                
                toView.alpha = 1.0
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

            
        } else {
            
            guard let fromVC = transitionContext.viewController(forKey: .from) as? LyricsViewController else { fatalError() }
            guard let toVC = transitionContext.viewController(forKey: .to) as? MusicPlayerViewController else { fatalError() }
            
            toVC.view.frame = containerView.frame
            containerView.addSubview(toVC.view)
            
            fromVC.view.alpha = 0.0
            
            let targetImage = toVC.albumCover.image
            
            let albumImageViewStartFrame = fromVC.musicInfoView.convert(fromVC.albumCover.frame, to: fromVC.view)
            let musicTitleLabelStartFrame = fromVC.musicInfoView.convert(fromVC.songTitle.frame, to: fromVC.view)
            let artistLabelStartFrame = fromVC.musicInfoView.convert(fromVC.artist.frame, to: fromVC.view)
            
            let albumImageViewFinalFrame = toVC.albumCover.frame
            let musicTitleLabelFinalFrame = toVC.panelStackView.musicInfoStackView.songInfoStackView.convert(toVC.panelStackView.musicInfoStackView.songInfoStackView.songTitle.frame, to: toVC.view)
            let albumTitleLabelFinalFrame = toVC.panelStackView.musicInfoStackView.convert(toVC.panelStackView.musicInfoStackView.songInfoStackView.albumTitle.frame, to: toVC.view)
            let artistLabelFinalFrame = toVC.panelStackView.musicInfoStackView.songInfoStackView.convert(toVC.panelStackView.musicInfoStackView.artist.frame, to: toVC.view)
            
            let albumCoverImageView = UIImageView(frame: albumImageViewStartFrame)
            albumCoverImageView.alpha = 1.0
            albumCoverImageView.contentMode = .scaleAspectFill
            albumCoverImageView.clipsToBounds = true
            albumCoverImageView.image = targetImage
            albumCoverImageView.layer.cornerRadius = 20
            
            let musicTitleLabel = UILabel(frame: musicTitleLabelStartFrame)
            musicTitleLabel.text = playList[0].title
            musicTitleLabel.font = musicTitleLabel.font.withSize(22)
            musicTitleLabel.textColor = .white
            
            let albumTitleLabel = UILabel()
            albumTitleLabel.text = playList[0].albumTitle
            albumTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            albumTitleLabel.textColor = .white
            
            let artistNameLabel = UILabel(frame: artistLabelStartFrame)
            artistNameLabel.text = playList[0].singer
            artistNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            artistNameLabel.textColor = .lightGray
            
            toVC.view.alpha = 1.0
            albumTitleLabel.alpha = 0.0
            
            containerView.addSubview(albumCoverImageView)
            containerView.addSubview(musicTitleLabel)
            containerView.addSubview(albumTitleLabel)
            containerView.addSubview(artistNameLabel)
            
            //MARK:- Dismissing animation
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                
                albumCoverImageView.frame = albumImageViewFinalFrame
                albumCoverImageView.layer.cornerRadius = 20
                
                musicTitleLabel.frame = musicTitleLabelFinalFrame
                albumTitleLabel.frame = albumTitleLabelFinalFrame
                albumTitleLabel.alpha = 1.0
                artistNameLabel.frame = artistLabelFinalFrame
                
            } completion: { (complement) in
                
                let success = !transitionContext.transitionWasCancelled
                if !success {
                    fromVC.view.alpha = 1.0
                    toVC.view.removeFromSuperview()
                }
                albumCoverImageView.alpha = 0.0
                musicTitleLabel.alpha = 0.0
                albumTitleLabel.alpha = 0.0
                artistNameLabel.alpha = 0.0
                toVC.albumCover.alpha = 1.0
                toVC.panelStackView.musicInfoStackView.songInfoStackView.songTitle.alpha = 1.0
                toVC.panelStackView.musicInfoStackView.songInfoStackView.albumTitle.alpha = 1.0
                toVC.panelStackView.musicInfoStackView.artist.alpha = 1.0
                toVC.panelStackView.lyricsTableView.alpha = 1.0
                
                albumCoverImageView.removeFromSuperview()
                transitionContext.completeTransition(success)
                
            }

        }
        
    }
    
    
}

