//
//  Fmp4AVPlayer.swift
//  fmp4_player
//
//  Created by Giáp Phan Văn on 28/10/25.
//

import UIKit
import AVFoundation
import AVKit
import MobileVLCKit

@objcMembers
class Fmp4AVPlayerView: UIView {
  private static var avlayer : AVPlayerLayer?
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
  }

  required init?(coder: NSCoder) {
      super.init(coder: coder)
      commonInit()
  }

  private func commonInit() {
    Fmp4AVPlayerView.avlayer = AVPlayerLayer()
    layer.addSublayer(Fmp4AVPlayerView.avlayer!)
  }
  
  func setStreamID(_ Id : String) {
  }
  
  static func AttachPlayerToLayer(avplayer : AVPlayer) {
    Fmp4AVPlayerView.avlayer?.player = avplayer
  }

  
  override func layoutSubviews() {
      super.layoutSubviews()
    Fmp4AVPlayerView.avlayer?.frame = bounds
  }

}

