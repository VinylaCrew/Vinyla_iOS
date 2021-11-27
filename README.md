# Vinyla_iOS

### 국내 및 해외 바이닐 저장 및 공유, 나만의 장르 분석 서비스

***

> 로그인 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679020-dae05bd9-3919-4718-97bb-dbe48da00e3f.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679138-4a7bae32-221d-4b80-a335-8e040feadc83.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679139-8060a08e-a4e2-40f7-a769-c5b1e2757099.png" width="250" height="550"/>
</p>
> 홈화면 + 레벨 디자인 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679261-beb9457a-85d5-42d3-8237-b76f6159fd9b.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679262-ab0c1c0b-94d0-4c5d-a4f6-92bec0a85899.png" width="250" height="550"/>
</p>
> 바이닐 보관함 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679349-547d2241-c7f9-40de-9cf1-ceff681d6eda.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679368-6d5b9792-dd55-49ae-a51b-41a3ec1a0af1.gif" width="250" height="450"/>
</p>
> 바이닐 검색 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679500-28e7f67a-a0f3-4b79-a945-bed5ba24cb64.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679503-7804a526-0f84-4a99-967a-da5220dcfb0c.gif" width="230" height="550"/>
</p>
> 바이닐 상세정보 확인 + 저장 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679555-953d7258-e579-4186-9c87-8b219225e276.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679561-6d71fc9b-bf0d-4e9a-affb-f5c9e673fe94.png" width="230" height="550"/>
</p>
***

🔍 설계

이전 프로젝트들의 문제점 (거대한 클래스, 복잡한 의존성, 메모리 누수, 유연하지 못한 View) 해결하기 위해 깊이 고민

MVC 아키텍쳐에서 UI Code와 Logic 코드의 분리 필요성을 느낌, 나아가 Coordinator를 통해 View 전환 Code를 통합 관리

=> Testable한 구조, View에선 불필요한 화면전환 Code를 가지지 않음

성능

상속이 필요하지 않은 class는 final class로 선언 , property에 대하여 적극적으로 private 선언

=> 메소드 인라이닝과 컴파일러 최적화를 통해 성능 개선

빠른 Scroll시 성능저하 방지를 위해 이미지 통신 cancel

메모리 누수

View는 Coordinator를 약한 참조하며, ViewModel을 강하게 참조하지만 추가 참조가 없어 Retain Cycle이 생기지 않도록 설계 해당 View가 사라지면 ViewModel도 메모리 해제가 됨

```swift
final class SignUpViewController: UIViewController {
  private weak var coordiNator: AppCoordinator?
  private var viewModel: SignUpViewModel?
static func instantiate(viewModel: SignUpViewModel, coordiNator: AppCoordinator) -> UIViewController {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(identifier: "SignUp") as? SignUpViewController else {
            return UIViewController()
        }
        viewController.viewModel = viewModel
        viewController.coordiNator = coordiNator
        return viewController
    }
}
```



해당 View에서 사용되는 클래스는 다른 View에서 참조가 이루어지지 않도록 설계

복잡한 의존성

View에서 직접 ViewModel 객체를 선언하여 만들지 않음 ViewModel Protocol에 의존, Coordinator를 통해 ViewModel 의존성 주입 및 분리

```swift
func moveToSignUPView() {
let signUpView = SignUpViewController.instantiate(viewModel: SignUpViewModel(), coordiNator: self)
guard let windowRootViewController = self.windowRootViewController else { return }
windowRootViewController.pushViewController(signUpView, animated: true)
    }
```

ViewModel에서 통신 클래스를 의존성 주입 및 분리

```swift
final class SearchViewModel {
init(searchAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.searchAPIService = searchAPIService
  }
 //Mock APIService Test
  init(searchAPIService: VinylAPIServiceProtocol = MockAPIService()) {
        self.searchAPIService = searchAPIService
  }
}
```

=>  통신이 분리된 Mock 통신 객체로 API Test 가능

* Search View 및 Vinyl Detail View Mock APIService Test 진행
  * Search API 구현전 Mock Test 선제 진행하여 개발
  * Vinyl Detail View Mock Test 진행으로, 바이닐 상세 연속 조회시 응답이 오지 않는 에러 이슈 즉시 발견

***

- MVVM-C 구조 도입
    - 적재적소에 맞는 코드 작성 / 의존성을 줄이기 위해 / 자유로운 뷰 전환 구조 / Testable한 구조
- 유저에게 바이닐을 책장에서 넘기는 유저 경험 제공
 - Collection View Cell 안에 Collection View를 넣는 구조로 구현
 - 자연스러운 페이징 효과 및 좋은 성능으로 구현 완료
- 내부 이미지 캐싱, NSCache Manager를 통해 해결 (오픈소스 사용 X)
- 내부 플로우 및 데이터 Test => CoreData를 활용해서 진행
   - 통신을 줄이기 위해 동기화 로직 Test 진행
- 홈화면 레이아웃 커스텀 , XS 이하의 화면 해상도에선 스크롤 View로 전환되도록
- XS 보다 큰 기기의 경우 최근 바이닐 크기 및 스크롤 View 레이아웃 계산 로직을 통해 비율을 맞추어줌
- Todo
   - 보관함 저장하기 1,2 View 상세 바이닐 이미지 변경되도록
   - 리드미 구조정리
