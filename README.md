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

#### 이전 프로젝트들의 문제점 (거대한 클래스, 복잡한 의존성, 메모리 누수, 유연하지 못한 View) 해결하기 위해 깊이 고민

**🧐 설계에 앞서 고민한 점**

배보다 배꼽이 더 커지는 상황을 방지하고자 했습니다.

아키텍쳐 및 디자인 패턴 등을 추가적으로 알아보며, 모든 것이 좋고 효과가 좋아보여서 마치 쇼핑을 하듯 많이 담게되지 않도록 꼭 필요하며 다음과 같은 질문에 적합한지 판단했습니다.

1. 생산성을 올려주는가?
   1.  (아키텍쳐 및 디자인 패턴의 도입이, 오히려 세분화된 추상화로 인해 생산성이 떨어지는 것을 방지하기위해)
2. 과거의 문제점을 개선하거나 해결해주는가?
3. 가독성 좋아지는가?
4. 코드가 여러상황에 유연해지는가?
5. 코딩할 때 무의식적인 실수를 방지해줄 수 있는가?

**고민이후의 결과**

MVC 아키텍쳐에서 UI Code와 Logic 코드의 분리 필요성을 느낌 (거대한 ViewController 및 복잡한 의존성 문제)

=> MVVM의 도입

=> Presentation Logic 분리를 위해 코딩하는 시간이 조금 더 걸릴 수 있지만, 프로젝트가 커져도 Unit Test가 편리

=> 과거의 문제점 (복잡한 의존성, 거대한 클래스) 해결 가능하다고 판단 + ViewModel의 추상화로 유연해지는 구조

=> 무의식적으로 ViewController가 비대해지는 상황을 방지할 수 있음

=> 유지보수가 편해지므로, 시간이 지날 수록 생산성이 증가한다고 판단

나아가 Coordinator를 통해 View 전환 Code 통합 관리의 필요성 (유연한 View 전환 대응)

=> View 전환 코드 하드 코딩 X, 메소드 한줄로 자유로운 View 전환 (여러 상황에 유연 + 가독성 증가)

=> View는 ViewModel의 데이터를 표현만하는 단일 책임을 지게됨

ARC를 고려하여 ViewModel 및 Coordinator가 Retain Cycle이 생기지 않도록,  선제적인 레퍼런스 카운트 관리

#### **현재 프로젝트에 맞는 MVVM - C 구조 도입**

<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143764461-8c8ef2a6-6d36-4df1-a5f3-ced1b57d165b.jpeg" width="650" height="370"/>
</p>

=> Testable한 구조, View에선 불필요한 화면전환 Code를 가지지 않으며 여러 상황에 맞는 자유로운 View 전환 가능

=> 적극적인 의존성 주입 및 분리를 통해 보다 유연하고 Test 하기 쉬운 환경을 조성

=> MVVM 계산기를 만들어 보며 Logic 및 UI Code 분리에 대한 이해, RxSwift bind의 편리함을 알게됨

=> 적재적소에 맞는 코드 작성 / 의존성 줄이기 / 자유로운 뷰 전환 구조 / Testable한 구조

=> 통신을 담당하는 APIService는 ViewModel에 의존성 주입 및 분리

***

### 📕성능

상속이 필요하지 않은 class는 final class로 선언 , 클래스 내부에서만 사용되는 property에 대하여 적극적으로 private 선언

**=> 메소드 인라이닝과 컴파일러 최적화를 통해 성능 개선**

빠른 Scroll시 성능저하 방지를 위해 이미지 통신 Cancel

처음 검색 화면의 문제점 정의

* **실제 프로젝트**에서, 검색 화면에서 **최대 검색 데이터 수는 50개**
* 빠른 스크롤로 맨 밑으로 TableView 이동시 이전의 스크롤되는 이미지 통신이 모두 진행됨
* 데이터 속도가 느린 상황이라면, 이전의 셀 이미지 통신때문에 보여져야 할 셀의 이미지 통신이 느려질 수 있음
* 또한, 원하는 검색 결과가 맨밑에 있었다면 중간에 있는 셀들의 이미지 통신은 유저 입장에선 비효율적 (데이터 소모값 증가)

**🧐 개선하며 깨달은 점**

=> Cell의 Life Cycle을 고려하여, Cell이 재활용 상태가 될때 해당 image 비동기 통신의 DataTask가 Cancel 되도록

=> 빠른 스크롤시 중간 부분의 셀은 이미지 통신이 이루어지지 않고, 마지막 부분이 바로 이미지 통신 진행

```swift
final class SearchTableViewCell: UITableViewCell {
    private var cellImageDataTask: URLSessionDataTask?
override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageDataTask?.cancel()
        self.searchVinylImageView.image = nil
    }
```



### 📗메모리 누수

예상하지 못한 강한 참조로 인해, Retain Cycle이 발생하지 않게

* View와 ViewModel에서 다른 클래스의 참조를 주의있게 진행했습니다.
* 또한 항상 자신을 참조하는 상황의 클로저 에선, 캡쳐리스트를 사용했습니다.

View는 Coordinator를 약한 참조하며, ViewModel을 강하게 참조

* 추가 참조가 없어 Retain Cycle이 생기지 않도록 설계 해당 View가 사라지면 ViewModel도 메모리 해제가 됨

View 및 ViewModel에서 클로저로 인한 참조로 Retain Cycle 발생하지 않기 위해

* weak, unowned 캡쳐리스트 사용

Profile - Leaks 및 CFGetRetainCount 활용하여 디버깅 및 검증

```swift
final class SignUpViewController: UIViewController {
  private weak var coordiNator: AppCoordinator?
  private var viewModel: SignUpViewModelProtocol
  //Coordinator type method 설명추가
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

###  📘복잡한 의존성

View에서 직접 ViewModel 객체를 만들지 않고 ViewModel Protocol에 의존(의존성 분리), Coordinator를 통해 ViewModel을 생성하고 주입 (의존성 주입)

=> 추후 서비스한지 어느정도의 시간이지나면 생길 리팩토링에서 View와 ViewModeld의 결합도를 낮추기 위함

=> UI 및 Unit Test에 보다 유연하게 대응 및 Test 진행 가능해짐

=> 리팩토링시 보다 적은 리소스 투입

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

**🧐고민하며 깨달은 점**

통신이 필요한 ViewModel에만 통신 API 객체를 만들어줌

=> 싱글턴 패턴으로 통신 객체를 사용하면, 특정 API의 Mock Test를 위해서 전체 메소드에 영향이 가는 수정이 이루어질 수 있고 Test 과정 자체가 불편하고 복잡해짐

=> 싱글턴 패턴으로 통신 객체에 접근 하지 않음

=> 통신이 필요하지 않은 ViewModel에서 통신 객체에 접근 가능성을 배제, 접근 가능한 상황과 접근하기 힘든 상황은 완전 다른 것이라고 판단

=> 의존성 분리를 통해 유연하게 통신이 분리된 Mock 통신 객체로 API Test 가능, 미리 설정해둔 MockAPIService 객체로 빠르고 정확하게 Test 가능

### ✅ 프로젝트 적용: Search View 및 Vinyl Detail View Mock APIService Test 진행

* Search API 구현전 Mock Test 선제 진행하여 개발
* Vinyl Detail View Mock Test 진행으로, 바이닐 상세 API 연속 조회시 응답이 오지 않는 에러 이슈 즉시 발견

**🧐고민한점**

* Exceptation과 fulfill, wait으로 실제 통신을 하여 Test 진행이 가능
* 하지만, 서버가 다운되거나 개발환경에서 인터넷이 끊긴 상황이라면 테스트가 불가능
* 서버통신이 가능한 상황에서도 Test가 가능하며, 통신이 분리된 Test진행도 가능해야함
* 따라서, MockAPIService 서버통신이 분리된 Test 진행이 가능하도록 변경

### 🔵 싱글턴 디자인 패턴과 NSCache를 사용하여 image 캐싱

보관함 데이터는 CoreData를 통해 캐싱

=> 설명필요

검색화면 및 상세화면의 image는 NSCache를 사용하여 캐싱

**고민하며 깨달은 점**

=> 한번 검색하여 보관한 가수 및 앨범의 제목을, 다음에 앱을 실행하여 또 다시 검색하는 경우가 적을 것으로 생각하여 디바이스 내부 저장 공간에 캐싱 데이터를 저장하는 방법을 선택하지 않음

=> 싱글턴 디자인 패턴의 사용으로 앱이 종료되면 캐싱 데이터도 소멸하도록 설계, 또한 이미지 캐싱을 Thread Safe 하게진행 (Swift의 싱글턴 패턴은 사용시점에 초기화되고, dispatchonce 적용되어 쓰레드 Safe 하므로)

=> 이미지 캐싱까지 디바이스에 파일디스크 형태로 이루어지면, 시간이 지날수록 앱을 통해 많은 공간을 차지하여 유저의 리스크 증가

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



### 🔴 RxSwift를 이용한 반응형 검색화면

=> Input 데이터를 비동기 데이터를 통한 스트림으로 관리하는 법을 이해

**🧐고민하며 깨달은 점**

=> 이스케이핑 클로저를 통한 통신 함수 대신, Observable을 통한 return이 가능한 비동기 코드 사용 

```swift
.flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data?]> in
                return self.searchAPIService.searchVinyl(vinylName: vinyl)
            }
```

(비동기 통신 Code 부분의 가독성 증가)

=> TextField에 addTarget .editingChanged 메소드를 이용해 검색API를 구현할 수 있지만, 1글자의 변화상태마다 통신이 이루어지므로 비효율적으로 판단. 

=> DispatchQueue를 통해 Delay 상태를 구현할 수 있지만 코드의 가독성 저하 및 별도의 DispatchQueue 작업이 이루어지므로 쓰레드에 관련해 더욱 조심히 디버깅 및 코딩이 진행되어야 함. (추가 리소스 발생)

=> debounce 및 observeOn 을 통해 직관적이며 간편하게 쓰레드 관리가 가능

=> 유저경험을 높임, 원하는 Word를 검색하고나면 검색 버튼을 눌르지 않아도 자동으로 검색 진행

**1️⃣ Vinyl 이름을 ViewModel의 VinylName에 bind 진행**

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

**2️⃣ ViewModel 생성자를 통해, VinylName으로 검색 통신 진행 및 스트림 생성**

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

**3️⃣ 통신된 Data를 통해 TableView Update**

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
