//
//  MyCell.swift
//  iOS Assignment
//
//  Created by Mohan Soni on 03/08/24.
//

import UIKit
import AVFoundation

class MyCell: UITableViewCell, ReusableView, NibLoadableView {
    
    @IBOutlet weak var thumbnailImage1: UIImageView!
    @IBOutlet weak var player1: UIView!
    
    @IBOutlet weak var thumbnailImage2: UIImageView!
    @IBOutlet weak var player2: UIView!
    
    @IBOutlet weak var thumbnailImage3: UIImageView!
    @IBOutlet weak var player3: UIView!
    
    @IBOutlet weak var thumbnailImage4: UIImageView!
    @IBOutlet weak var player4: UIView!
    
    public var playerAV1 =  AVPlayer()
    public var playerAV2 =  AVPlayer()
    public var playerAV3 = AVPlayer()
    public var playerAV4 = AVPlayer()
    
    private var playerLayer: AVPlayerLayer?
    
    var playfirstVideo: Bool? {
        didSet {
            if let status = playfirstVideo, status == true {
                self.thumbnailImage1.isHidden = true
                self.playerAV1.play()
                NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerAV1.currentItem)
            }
        }
    }
    
    var currentPlayerIndex = 0
    
    var dataArray: [Arr]? {
        didSet {
            if let layer = self.playerLayer {
                layer.removeFromSuperlayer()
                NotificationCenter.default.removeObserver(self,name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
            
            
            let image1 = dataArray?[0].thumbnail ?? ""
            let video1 = dataArray?[0].video ?? ""
            
            let image2 = dataArray?[1].thumbnail ?? ""
            let video2 = dataArray?[1].video ?? ""
            
            let image3 = dataArray?[2].thumbnail ?? ""
            let video3 = dataArray?[2].video ?? ""
            
            let image4 = dataArray?[3].thumbnail ?? ""
            let video4 = dataArray?[3].video ?? ""
            
            let imageURL1 = URL(string: image1)
            let imageURL2 = URL(string: image2)
            let imageURL3 = URL(string: image3)
            let imageURL4 = URL(string: image4)
            
            thumbnailImage1.downloadImage(from: imageURL1 ?? URL(string: ""))
            thumbnailImage2.downloadImage(from: imageURL2 ?? URL(string: ""))
            thumbnailImage3.downloadImage(from: imageURL3 ?? URL(string: ""))
            thumbnailImage4.downloadImage(from: imageURL4 ?? URL(string: ""))
            
            let url1 = URL(string: video1)!
            let url2 = URL(string: video2)!
            let url3 = URL(string: video3)!
            let url4 = URL(string: video4)!
            
            setupPlayer(videoView: player1, url: url1, imageView: thumbnailImage1, player: &playerAV1, id: 0)
            setupPlayer(videoView: player2, url: url2, imageView: thumbnailImage2, player: &playerAV2, id: 1)
            setupPlayer(videoView: player3, url: url3, imageView: thumbnailImage3, player: &playerAV3, id: 2)
            setupPlayer(videoView: player4, url: url4, imageView: thumbnailImage4, player: &playerAV4, id: 3)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //player setup
    private func setupPlayer(videoView: UIView, url:URL, imageView: UIImageView, player: inout AVPlayer, id: Int) {
        
        //creating player item, player
        let playerItem = AVPlayerItem(url: url)
        let avPlayer = AVPlayer(playerItem: playerItem)
        
        //creating player layer
        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        //  avPlayerLayer.videoGravity = .resizeAspectFill
        avPlayerLayer.backgroundColor = UIColor.clear.cgColor
        
        //add layer to video view
        videoView.layer.addSublayer(avPlayerLayer)
        
        //play video
        let endTime = CMTimeMakeWithSeconds(6, preferredTimescale: 600)
        avPlayer.playImmediately(atRate: 2.0)
        avPlayer.currentItem?.forwardPlaybackEndTime = endTime
        avPlayer.isMuted = true
        //set player layer to local var
        self.playerLayer = avPlayerLayer
        player = avPlayer
        
        if (id == 0 && self.tag == 0) {
            player.play()
            thumbnailImage1.isHidden = true
        }else {
            player.pause()
        }
        
        //set audio session category for audio
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
}

extension MyCell {
    @objc private func videoDidEnded() {
        print("currentPlayerIndex:", currentPlayerIndex)
        print("VIDEOENDED")
        
        NotificationCenter.default.removeObserver(self)
        
        switch currentPlayerIndex {
        case 0:
            self.playerAV1.seek(to: .zero)
            self.playerAV1.pause()
            self.thumbnailImage1.isHidden = false
            
            currentPlayerIndex += 1
            
            self.thumbnailImage2.isHidden = true
            self.playerAV2.play()
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerAV2.currentItem)
            
            break
        case 1:
            self.playerAV2.seek(to: .zero)
            self.playerAV2.pause()
            self.thumbnailImage2.isHidden = false
            
            currentPlayerIndex += 1
            
            self.thumbnailImage3.isHidden = true
            self.playerAV3.play()
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerAV3.currentItem)
            
            break
        case 2:
            self.playerAV3.pause()
            self.playerAV3.seek(to: .zero)
            self.thumbnailImage3.isHidden = false
            
            currentPlayerIndex += 1
            
            self.thumbnailImage4.isHidden = true
            self.playerAV4.play()
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerAV4.currentItem)
            
            break
        default:
            NotificationCenter.default.removeObserver(self)
            
            self.thumbnailImage4.isHidden = false
            self.playerAV4.seek(to: .zero)
            self.playerAV4.pause()
            break
        }
    }
}
