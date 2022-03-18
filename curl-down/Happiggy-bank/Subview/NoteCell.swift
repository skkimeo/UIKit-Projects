//
//  NoteCell.swift
//  Happiggy-bank
//
//  Created by sun on 2022/03/13.
//

import UIKit

import Then

/// 쪽지 리스트에서 사용할 셀
class NoteCell: UITableViewCell {
    
    // MARK: - @IBOulet
    
    /// 색깔에 따라 쪽지 이미지 혹은 배경색을 변경할 뷰
    @IBOutlet var noteImageView: UIImageView!
    
    @IBOutlet weak var placeHolderView: UIImageView!
    
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
        self.configurePlacHolderView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected
        else { return }
        
        self.frontDateLabel.isHidden = true
        self.contentLabel.isHidden = false
        self.backDateLabel.isHidden = false
        
        self.contentLabel.alpha = .zero
        self.backDateLabel.alpha = .zero
        
        /// 쪽지 이미지 애니메이션
        UIView.transition(
            with: self.noteImageView,
            duration: Metric.noteAnimationDuration,
            options: [.transitionCurlDown, .curveEaseOut]
        ) {
            self.noteImageView.isHidden = false
        } completion: { _ in
            self.placeHolderView.isHidden = true
        }

        /// 내용 애니메이션
        UIView.animate(
            withDuration: Metric.contentsAnimationDuration,
            delay: Metric.contentsAnimationDelay
        ) {
            self.contentLabel.alpha = 1
            self.backDateLabel.alpha = 1
        }
    }
    
    /// 플레이스 홀더 뷰 초기 설정 : 점선 생성
    private func configurePlacHolderView() {
        self.placeHolderView.image = UIImage()
        
        /// 점선
        let borderLayer = CAShapeLayer().then {
            $0.strokeColor = UIColor.systemGray.cgColor
            $0.lineDashPattern = [10, 5]
            $0.frame = Metric.placeHolderViewBounds
            $0.fillColor = nil
            $0.path = UIBezierPath(rect: Metric.placeHolderViewBounds).cgPath
        }

        self.placeHolderView.layer.addSublayer(borderLayer)
    }
    
    /// 쪽지 이미지뷰 초기 설정: 모서리 둥글게 설정
    private func configureNoteImageView() {
        self.noteImageView.image = UIImage()
    }
}
