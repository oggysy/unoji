//
//  ViewController.swift
//  unoji
//
//  Created by 小木曽佑介 on 2023/02/25.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet private weak var ropeView: UIView!
    @IBOutlet private weak var ropeViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var mainIllustrationImageView: UIImageView!
    private var ropeViewStartPosition: CGFloat?
    //　ropeが下に移動する最大のtop位置を変数に格納
    private let ropeMaxLength: CGFloat = -70

    var washTimeModel = WashTimeModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    //　ropeViewをスワイプすると呼ばれる関数
    @objc
    func didPan(_ recognizer: UIPanGestureRecognizer) {
        //　ropeの初期位置をアンラップ
        guard let startPositon = ropeViewStartPosition else {
            return
        }
        //　スワイプの移動量を変数pointに格納
        let swipeAmountToPortrait = recognizer.translation(in: self.view).y
        //　現在のropeの位置＋y軸の移動量を足して予測されるtop位置を変数expectedRopePositonに格納
        let expectedRopePositon = ropeViewTopLayoutConstraint.constant + swipeAmountToPortrait

        //　予測される移動位置がropeMaxLengthを超えていなければスワイプ量を現在位置に足す
        //　超える場合はropeMaxLengthに指定
        if expectedRopePositon <= ropeMaxLength {
            ropeViewTopLayoutConstraint.constant += swipeAmountToPortrait
            //            print(ropeViewTopLayoutConstraint.constant)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        } else {
            ropeViewTopLayoutConstraint.constant = ropeMaxLength
        }

        //　スワイプ終了時に呼ばれる処理
        if recognizer.state == .ended {
            //　もしスワイプ終了時にropeの位置がropeMaxLengthになっていればwashTimeModelのwashTimeを現在日時に設定し、水が流れるアニメーション実行
            if ropeViewTopLayoutConstraint.constant == ropeMaxLength {
                washTimeModel.washTime = Date()
                flushWater()
            }
            //　ropeを初期位置に戻し、animationしながら元の位置に戻る
            self.ropeViewTopLayoutConstraint.constant = startPositon
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    //　水が流れるアニメーション
    private func flushWater() {
        let flushAnimation = {
            let view = LottieAnimationView(name: "flush_water_animation")
            view.frame = self.view.frame
            view.contentMode = .scaleToFill
            view.animationSpeed = 2.5
            view.loopMode = .playOnce
            return view
        }()
        //　メインビューにアニメーション表示
        view.addSubview(flushAnimation)
        flushAnimation.play()
        //　一定時間経過後に以下の処理
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            self.updateView()
            self.firstAnimation()
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.updateView()
            }
            flushAnimation.removeFromSuperview()
        }
    }

    // viewDidLoad時に行う処理
    private func configure() {
        ropeViewStartPosition = ropeViewTopLayoutConstraint.constant
        //　UIPanGestureRecognizerを初期化して変数に格納し、ropeViewに渡す
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(didPan(_:))
        )
        ropeView.addGestureRecognizer(panGesture)
    }

    // 経過時間とメインイラストのviewを更新
    private func updateView() {
        mainIllustrationImageView.image = UIImage(named: washTimeModel.displayIllustration)
        elapsedTimeLabel.text = washTimeModel.elapsedTimeConvertForDisplay()
    }

    // メインイラストがふわっと出現するアニメーション
    private func firstAnimation() {
        mainIllustrationImageView.alpha = 0.0
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseIn], animations: {
            self.mainIllustrationImageView.alpha = 1.0
        }, completion: nil)
    }
}
