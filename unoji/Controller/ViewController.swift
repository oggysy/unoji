//
//  ViewController.swift
//  unoji
//
//  Created by 小木曽佑介 on 2023/02/25.
//

import UIKit
import Lottie
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet private weak var ropeView: UIView!
    @IBOutlet private weak var ropeViewTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var mainIllustrationImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UILabel!

    var washTimeModel = WashTimeModel()
    var timer = Timer()
    private var ropeViewStartPosition: CGFloat?
    //　ropeが下に移動する最大のtop位置を変数に格納
    private let ropeMaxLength: CGFloat = -70

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil
        )
        configure()
    }

    //　ropeViewをスワイプすると呼ばれる関数
    @objc
    func didPan(_ recognizer: UIPanGestureRecognizer) {
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
            //　もしスワイプ終了時にropeの位置がropeMaxLengthになっていれば以下の処理実行
            if ropeViewTopLayoutConstraint.constant == ropeMaxLength {
                updateView()
                washTimeModel = WashTimeModel.saveAndCreateWashTime(model: washTimeModel)
                // 水を流すアニメーション実行
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
            self.updateView()// Viewを更新
            self.firstAnimation()// ふわっと出現するアニメーション
            flushAnimation.removeFromSuperview()// flushanimation解除
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
        elapsedTimeLabel.textColor = .darkGray
        titleTextLabel.textColor = .darkGray
        // スワイプ誘導の矢印を表示させる
        let arrowAnimation = {
            let view = LottieAnimationView(name: "arrow")
            view.frame = CGRect(x: 50, y: 90, width: 50, height: 80)
            view.contentMode = .scaleToFill
            view.loopMode = .loop
            return view
        }()
        view.addSubview(arrowAnimation)
        view.sendSubviewToBack(arrowAnimation)
        arrowAnimation.play()
    }

    // 経過時間とメインイラストの値を更新しviewも更新
    func updateView() {
        //　この関数が呼ばれたらtimerをストップ
        timer.invalidate()
        let realm = try! Realm()
        // 変数lastTimeに前回のwashTime変数の値を代入する nilの場合は今の時刻
        let lastTime = realm.objects(WashTimeModel.self).last?.washTime ?? Date()
        washTimeModel.update(by: lastTime)
        mainIllustrationImageView.image = UIImage(named: washTimeModel.setDisplayIlustration())
        elapsedTimeLabel.text = washTimeModel.formatElapsedTime()
        // 10分後にupdateViewが呼ばれるようにする
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: false, block: { _ in
            self.updateView()
        })
    }

    // willEnterForegroundNotification用のupdateview
    @objc func updateView(notification: Notification) {
        updateView()
    }

    // メインイラストがふわっと出現するアニメーション
    private func firstAnimation() {
        mainIllustrationImageView.alpha = 0.0
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [.curveEaseIn], animations: {
            self.mainIllustrationImageView.alpha = 1.0
        }, completion: nil)
    }
}
