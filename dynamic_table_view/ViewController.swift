//
//  ViewController.swift
//  dynamic_table_view
//
//  Created by Jeff Jeong on 2020/09/01.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import UIKit
import SwipeCellKit


let MY_TABLE_VIEW_CELL_ID = "myTableViewCell"

// 피드 데이터 모델
class Feed {
    let content : String
    var isFavorite : Bool = false // 하트
    var isThumbsUp : Bool = false // 따봉
    // 생성자
    init(content: String) {
        self.content = content
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var contentArray = [
        Feed(content: "simply dummy text of the printing and"),
        Feed(content: "um has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type "),
        Feed(content: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribestablished fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, co"),
        Feed(content: "ho loves pain itself, who seeks after it and wants to have it, simply because it is pai"),
        Feed(content: "established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, co"),
        Feed(content: "ho loves pain itself, who seeks after it and wants to have it, simply because it is pai"),
        Feed(content: "a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is thaai"),
        Feed(content: "ho loves pain ita reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is to have it, simply because it is pai"),
        Feed(content: "ho loves pain itself, who seeks after it and wants to have it, simplho loves pain ita reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is to have it, simply because it y because it is pai"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController - viewDidLoad() called")
        
        // 쎌 리소스 파일 가져오기
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: MY_TABLE_VIEW_CELL_ID)
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        
        self.myTableView.estimatedRowHeight = 120
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self

        print("contentArray.count : \(contentArray.count)")
        
    }

}


extension ViewController: UITableViewDelegate {



}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArray.count
    }

    // 쎌에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = myTableView.dequeueReusableCell(withIdentifier: MY_TABLE_VIEW_CELL_ID, for: indexPath) as! MyTableViewCell

        // 스와이프 쎌 을 위한 델리겟 연결
        cell.delegate = self
        
        // 데이터와 UI 연결
        if self.contentArray.count > 0 {
            
            let cellData = contentArray[indexPath.row]
            
            cell.updateUI(with: cellData)
        }
        
        cell.heartBtnAction = { [weak self] currentBtnState in
            guard let self = self else { return }
            //
            self.contentArray[indexPath.row].isFavorite = !currentBtnState
//            self.myTableView.reloadRows(at: [indexPath], with: .automatic)
        }

        return cell
    }

}

// 스와이프 쎌 델리겟 설정
//MARK: - SwipeTableViewCellDelegate
extension ViewController: SwipeTableViewCellDelegate {
    
    // 쎌에 대한 스와이프 액션
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // 데이터
        let dataItem = contentArray[indexPath.row] as Feed
        // 쏄
        let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
        
        // 액션방향에 따른 분기 처리
        switch orientation {
        case .left: // 왼쪽으로 스와이프 했을때
            
            let thumbsUpAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                print("따봉 액션 들어옴")
                
                // 액션에 따른 데이터 변경
                let updatedStatus = !dataItem.isThumbsUp
                dataItem.isThumbsUp = updatedStatus
                cell.hideSwipe(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    // 현재 스와이프 한 애만 리로드 하기
                    tableView.reloadRows(at: [indexPath], with: .none)
                })
            })
            
            // 액션 마크 꾸미기
            thumbsUpAction.title = dataItem.isThumbsUp ? "따봉 해제" : "따봉"
            thumbsUpAction.image = UIImage(systemName: dataItem.isThumbsUp ? "hand.thumbsup" : "hand.thumbsup.fill")
            thumbsUpAction.backgroundColor = dataItem.isThumbsUp ? .systemGray2 : #colorLiteral(red: 0.1887893739, green: 0.3306484833, blue: 1, alpha: 1)
            
            return [thumbsUpAction]
            
        case .right: // 오른쪽으로 스와이프 했을때
            // 하트 액션
            let heartAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                print("하트 액션 들어옴")
                // 액션에 따른 데이터 변경
                let updatedStatus = !dataItem.isFavorite
                dataItem.isFavorite = updatedStatus
                cell.hideSwipe(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    // 현재 스와이프 한 애만 리로드 하기
                    tableView.reloadRows(at: [indexPath], with: .none)
                })
            })
            
            // 액션 마크 꾸미기
            heartAction.title = dataItem.isFavorite ? "하트 해제" : "하트"
            heartAction.image = UIImage(systemName: dataItem.isFavorite ? "heart" : "heart.fill")
            heartAction.backgroundColor = dataItem.isFavorite ? .systemGray2 : #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            
            
            // 바텀 액션 클로러
            let closure: (UIAlertAction) -> Void = { (action: UIAlertAction) in
                // 쎌 액션 닫기
                cell.hideSwipe(animated: true)
                if let selectedTitle = action.title {
                    print("selectedTitle : \(selectedTitle)")
                    let alertController = UIAlertController(title: selectedTitle, message: "클릭됨", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            
            // 더보기 액션
            let moreAction = SwipeAction(style: .default, title: nil, handler: {
                action, indexPath in
                print("더보기 액션")
                
                let bottomAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                
                bottomAlertController.addAction(UIAlertAction(title: "댓글", style: .default, handler: closure))
                bottomAlertController.addAction(UIAlertAction(title: "상세보기", style: .default, handler: closure))
                bottomAlertController.addAction(UIAlertAction(title: "메세지보기", style: .default, handler: closure))
                bottomAlertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: closure))
                
                self.present(bottomAlertController, animated: true, completion: nil)
                
            })
            
            // 더보기 액션 꾸미기
            moreAction.title = "더보기"
            moreAction.image = UIImage(systemName: "ellipsis.circle")
            moreAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            
            // 삭제 액션
            let deleteAction = SwipeAction(style: .destructive, title: nil, handler: {
                action, indexPath in
                print("삭제 액션 ")
                self.contentArray.remove(at: indexPath.row)
            })
            
            // 삭제 액션 꾸미기
            deleteAction.title = "지우기"
            deleteAction.image = UIImage(systemName: "trash.fill")
            deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
            
            return [deleteAction, moreAction, heartAction]
        }
        
    }
    
    // 쎌 액션에 대한 옵션 설정
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        
        //
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = .drag
        
        return options
    }
    
    
}
