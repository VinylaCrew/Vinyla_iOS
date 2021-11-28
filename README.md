# Vinyla_iOS

### 국내 및 해외 바이닐 저장 및 공유, 나만의 장르 분석 서비스

***

* 목차
  * 앱 실행 화면
  * 아키텍쳐 설계 및 고려한 점

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
<img src="https://user-images.githubusercontent.com/55793344/143679368-6d5b9792-dd55-49ae-a51b-41a3ec1a0af1.gif" width="250" height="550"/>
</p>

> 바이닐 검색 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679500-28e7f67a-a0f3-4b79-a945-bed5ba24cb64.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679503-7804a526-0f84-4a99-967a-da5220dcfb0c.gif" width="230" height="550"/>
</p>

> 바이닐 상세정보 확인 + 저장 화면
<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143679555-953d7258-e579-4186-9c87-8b219225e276.png" width="250" height="550"/>
<img src="https://user-images.githubusercontent.com/55793344/143679561-6d71fc9b-bf0d-4e9a-affb-f5c9e673fe94.png" width="250" height="550"/>
</p>

***

### 🔍 설계 및 고려한 점

### 이전 프로젝트들의 문제점 (거대한 클래스, 복잡한 의존성, 메모리 누수, 유연하지 못한 View) 해결하기 위해 깊이 고민

MVC 아키텍쳐에서 UI Code와 Logic 코드의 분리 필요성을 느낌, (거대한 ViewController 및 복잡한 의존성 문제)

나아가 Coordinator를 통해 View 전환 Code를 통합 관리의 필요성 (유연한 View 전환 대응)

**현재 프로젝트에 맞는 MVVM - C 구조 도입**

<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143764461-8c8ef2a6-6d36-4df1-a5f3-ced1b57d165b.jpeg" width="450" height="370"/>
</p>

=> Testable한 구조, View에선 불필요한 화면전환 Code를 가지지 않으며 여러 상황에 맞는 자유로운 View 전환 가능

=> 적극적인 의존성 주입 및 분리를 통해 보다 유연하고 Test 하기 쉬운 환경을 조성

=> MVVM 계산기를 만들어 보며 Logic 및 UI Code 분리에 대한 이해, RxSwift bind의 편리함을 알게됨

### 성능

상속이 필요하지 않은 class는 final class로 선언 , 클래스 내부에서만 사용되는 property에 대하여 적극적으로 private 선언

**=> 메소드 인라이닝과 컴파일러 최적화를 통해 성능 개선**

빠른 Scroll시 성능저하 방지를 위해 이미지 통신 Cancel

=> Cell의 Life Cycle을 고려하여, Cell 재활용 상태가 될때 해당 image 비동기 통신 Cancel

```swift
final class SearchTableViewCell: UITableViewCell {
    private var cellImageDataTask: URLSessionDataTask?
override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageDataTask?.cancel()
        self.searchVinylImageView.image = nil
    }
```



### 메모리 누수

View는 Coordinator를 약한 참조하며, ViewModel을 강하게 참조하지만 추가 참조가 없어 Retain Cycle이 생기지 않도록 설계 해당 View가 사라지면 ViewModel도 메모리 해제가 됨

```swift
final class SignUpViewController: UIViewController {
  private weak var coordiNator: AppCoordinator?
  private var viewModel: SignUpViewModelProtocol
static func instantiate(viewModel: SignUpViewModelProtocol, coordiNator: AppCoordinator) -> UIViewController {
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

### 복잡한 의존성

View에서 직접 ViewModel 객체를 만들지 않고 ViewModel Protocol에 의존(의존성 분리), Coordinator를 통해 ViewModel을 생성하고 주입 (의존성 주입)

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

=> 통신이 분리된 Mock 통신 객체로 API Test 가능

통신이 필요한 ViewModel에만 통신 API 객체를 만들어줌

=> 싱글턴 패턴으로 통신 객체에 접근 하지 않음, 통신이 필요하지 않은 View에서 통신 객체에 접근 가능성을 배제 및 상황에 맞는 싱글턴 디자인패턴 사용

### 프로젝트 적용: Search View 및 Vinyl Detail View Mock APIService Test 진행

* Search API 구현전 Mock Test 선제 진행하여 개발
* Vinyl Detail View Mock Test 진행으로, 바이닐 상세 API 연속 조회시 응답이 오지 않는 에러 이슈 즉시 발견



### 싱글턴 디자인 패턴과 NSCache를 사용하여 image 캐싱

보관함 데이터는 CoreData를 통해 캐싱

검색화면 및 상세화면의 image는 NSCache를 사용하여 캐싱

=> 싱글턴 디자인 패턴의 사용으로 앱이 종료되면 캐싱 데이터 소멸

=> 한번 검색하여 보관한 가수 및 앨범의 제목을, 다음에 앱을 실행하여 또 다시 검색하는 경우가 적을 것으로 생각하여 디바이스 내부 저장 공간에 캐싱 데이터를 저장하는 방법을 선택하지 않음

=> 검색과정에서 같은 Word를 다시 검색하고 빠른 스크롤을 위한 이미지 캐싱은 필수라고 생각

```swift
class NSCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {
    }
}
```

```swift
func setImageURLAndChaching(_ imageURL: String?) {

        guard let imageURL = imageURL else { return }

        DispatchQueue.global(qos: .background).async {

            let cachedKey = NSString(string: imageURL)

            if let cachedImage = NSCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }

            guard let url = URL(string: imageURL) else { return }

            let dataTask = URLSession.shared.dataTask(with: url) { (data, result, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        NSCacheManager.shared.setObject(image, forKey: cachedKey)
                        self?.image = image
                    }
                }
            }
                dataTask.resume()

        }
    }
```



### RxSwift를 이용한 반응형 검색화면

=> 데이터를 스트림으로 관리하는 법을 이해

=> 이스케이핑 클로저를 통한 통신 함수 대신, Observable을 통한 return이 가능한 비동기 코드 사용

Vinyl 이름을 ViewModel의 VinylName에 bind 진행

```swift
//View
vinylSearchBar.rx.text
            .orEmpty
            .distinctUntilChanged() // 중복 데이터 스트림 반복 X
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .skip(1)
            .bind(to: viewModel.vinylName)
            .disposed(by: disposeBag)
```

ViewModel 생성자를 통해, VinylName으로 검색 통신 진행 및 스트림 생성

```swift
//ViewModel
init(searchAPIService: VinylAPIServiceProtocol = VinylAPIService()) {
        self.searchAPIService = searchAPIService
        _ = vinylName
            .flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data?]> in
                return self.searchAPIService.searchVinyl(vinylName: vinyl)
            }
            .bind(to: vinylsData)
            .disposed(by: disposeBag)
}
```

통신된 Data를 통해 TableView Update

```swift
//View
viewModel.vinylsData
            .observeOn(MainScheduler.instance) // UI 업데이트는 메인쓰레드에서 이루어지도록
            .catchErrorJustReturn([])
            .bind(to: searchTableView.rx.items) { tableView, index, element in
                //Cell Vinyl관련 UI요소 업데이트
                return cell
            }.disposed(by: disposeBag)
```





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
