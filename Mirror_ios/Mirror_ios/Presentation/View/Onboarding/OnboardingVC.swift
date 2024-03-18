//
//  OnboardingVC.swift
//  Mirror_ios
//
//  Created by 경유진 on 3/4/24.
//

import UIKit
import SnapKit

class OnboardingVC: UIPageViewController {
    // MARK: - Properties
    // 변수 및 상수, IBOutlet
    private var nextBtn: UIButton!
    
    private var pages = [UIViewController]()
    private var initialPage = 0
    
    private var pageControl: UIPageControl!
    
    // MARK: - Lifecycle
    // 생명주기와 관련된 메서드 (viewDidLoad, viewDidDisappear...)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setPages()
        configureUI()
        addView()
        layout()
    }
    
    // 온보딩 페이지 생성 - 총 5페이지
    private func setPages() {
        let page1 = OnboardingContentsVC(imageName: "subLogo",
                                         title: "\"미로:Mirror\"의 3가지 기능",
                                         content: "이미지 묘사, 물건 찾기, 문서 읽기\n총 3가지의 기능을 제공합니다.\n각 기능은 어플 하단 네비게이션바를 통해\n홈 / 물건 찾기 / 이미지 설명 / 문서 읽기\n순으로 사용하실 수 있습니다.", readingText: "미로:Mirror에서는 이미지 묘사, 물건 찾기, 문서 읽기 총 세가지의 기능을 제공합니다.\n각 기능은 어플 하단 네비게이션바를 통해 홈 / 물건 찾기 / 이미지 설명 / 문서 읽기 순으로 사용하실 수 있습니다.")
        let page2 = OnboardingContentsVC(imageName: "filledhomeIcon",
                                         title: "홈 화면",
                                         content: "앱 사용 가이드가 제공됩니다.", readingText: "홈 화면에서는 앱 사용 가이드가 제공됩니다.")
        let page3 = OnboardingContentsVC(imageName: "filledeyeIcon",
                                         title: "물건 찾기 기능",
                                         content: "앱 내에서 비디오가 실행되며,\n찾고자하는 물건을 말하고 해당 공간을 촬영하면\n물건을 감지했을 때 소리로 알림을 보냅니다.", readingText: "물건 찾기 기능에서는 앱 내에서 비디오가 실행되며, 찾고자하는 물건을 말하고 해당 공간을 촬영하면 물건을 감지했을 때 소리로 알림을 보냅니다.")
        let page4 = OnboardingContentsVC(imageName: "filledimageIcon",
                                         title: "이미지 설명 기능",
                                         content: "앱 내에서 카메라가 실행되며,\n카메라로 앞의 상황을 촬영하면\n해당 이미지를 분석하여 설명을 생성하고 읽어줍니다.", readingText: "이미지 설명 기능에서는 앱 내에서 카메라가 실행되며, 카메라로 앞의 상황을 촬영하면 해당 이미지를 분석하여 설명을 생성하고 읽어줍니다.")
        let page5 = OnboardingContentsVC(imageName: "filleddocumentIcon",
                                         title: "문서 읽기 기능",
                                         content: "앱 내에서 카메라가 실행되며,\n읽고자 하는 문서를 앞에 두고 촬영하면\n해당 이미지에서 텍스트를 추출하여 읽어줍니다.", readingText: "문서 읽기 기능에서는 앱 내에서 카메라가 실행되며, 읽고자 하는 문서를 앞에 두고 촬영하면 해당 이미지에서 텍스트를 추출하여 읽어줍니다.")

        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)

    }
    
    // PageController, Button - 페이지 액션때문에 contentsVC가 아닌 OnboardingVC에서 작업
    private func configureUI() {
        self.dataSource = self
        self.delegate = self
        self.setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.pageIndicatorTintColor = .customGray
        pageControl.currentPageIndicatorTintColor = .mainBlue
        pageControl.backgroundColor = .white
        pageControl.addTarget(self, action: #selector(pageControlHandler), for: .valueChanged)
        
        nextBtn = UIButton()
        nextBtn.backgroundColor = .mainBlue
        nextBtn.layer.cornerRadius = 8
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nextBtn.addTarget(self, action: #selector(butttonHandler), for: .touchUpInside)
    }
    
    private func addView() {
        view.addSubview(nextBtn)
        view.addSubview(pageControl)
    }
    
    private func layout() {
        nextBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(55)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
}

// MARK: - Helpers
// 설정, 데이터처리 등 액션 외의 메서드를 정의

// PageHandler, Button 액션 함수 정의
extension OnboardingVC {
    @objc func pageControlHandler(_ sender: UIPageControl) {
        guard let currnetViewController = viewControllers?.first,
              let currnetIndex = pages.firstIndex(of: currnetViewController) else { return }
        
        // 코드의 순서 상 페이지의 인덱스보다 pageControl의 값이 먼저 변한다.
        // 그러므로, currentPage가 크면 오른쪽 방향, 작으면 왼쪽 방향으로 움직이게 설정해 줌
        let direction: UIPageViewController.NavigationDirection = (sender.currentPage > currnetIndex) ? .forward : .reverse
        self.setViewControllers([pages[sender.currentPage]], direction: direction, animated: true)
    }
    
    @objc func butttonHandler(_ sender: UIButton) {
        switch sender.currentTitle {
        case "시작하기":
            UserDefaults.standard.set(true, forKey: "Onboarding")
            dismiss(animated: true)
        case "다음":
            goToNextPage()
            pageControl.currentPage += 1
            // 버튼으로 마지막 페이지 도착했을 때 버튼 title 바꾸기
            if pageControl.currentPage == 4 {
                nextBtn.setTitle("시작하기", for: .normal)
            }
            else {
                nextBtn.setTitle("다음", for: .normal)
            }
        default:
            break
        }
    }
    
    func goToNextPage() {
        // UIPageViewController에는
        guard let currentPage = viewControllers?[0],
              let nextPage = self.dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        self.setViewControllers([nextPage], direction: .forward, animated: true)
    }
}

// 페이지 슬라이딩 제스쳐로 넘기기 위한 extenstion
extension OnboardingVC: UIPageViewControllerDataSource {
    // 이전 뷰컨트롤러를 리턴 (우측 -> 좌측 슬라이드 제스쳐)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 현재 VC의 인덱스를 구합니다.
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    // 다음 보여질 뷰컨트롤러를 리턴 (좌측 -> 우측 슬라이드 제스쳐)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        guard currentIndex < (pages.count - 1) else { return nil }
        return pages[currentIndex + 1]
    }
}

extension OnboardingVC: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        guard let viewControllers = pageViewController.viewControllers,
              let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }

        pageControl.currentPage = currentIndex
        // 마지막 페이지 버튼 title 바꾸기
        if pageControl.currentPage == 4 {
            nextBtn.setTitle("시작하기", for: .normal)
        }
        else {
            nextBtn.setTitle("다음", for: .normal)
        }
    }
}
