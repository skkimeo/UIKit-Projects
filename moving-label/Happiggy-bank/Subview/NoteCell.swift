//
//  NoteCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

/// 쪽지 리스트에서 사용할 셀
class NoteCell: UITableViewCell {
    
    // MARK: - @IBOulet
    
    /// 색깔에 따라 쪽지 이미지 혹은 배경색을 변경할 뷰
    @IBOutlet var noteImageView: UIImageView!
    
    /// 앞면(미개봉) 날짜 라벨
    @IBOutlet weak var frontDateLabel: UILabel!
    
    /// 뒷면(개봉) 날짜 라벨
    @IBOutlet weak var backDateLabel: UILabel!
    
    /// 뒷면에 나타날 쪽지 내용
    @IBOutlet weak var contentLabel: UILabel!
    
    
    // MARK: - Function
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureNoteImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected
        else { return }
        
        self.frontDateLabel.isHidden = true
        self.contentLabel.isHidden = false
        self.backDateLabel.isHidden = false
        
        self.contentLabel.alpha = 0
        self.backDateLabel.frame = self.frontDateLabel.frame
        
        // TODO: change to keyframe animation
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.contentLabel.alpha = 1
            }
        }
    }
    
    /// 쪽지 이미지뷰 초기 설정: 모서리 둥글게 설정
    private func configureNoteImageView() {
        self.noteImageView.image = UIImage()
        self.noteImageView.layer.cornerRadius = Metric.cornerRadius
    }
}
