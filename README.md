# Vinyla_iOS

### 국내 및 해외 바이닐 저장 및 공유, 나만의 장르 분석 서비스
<img src="https://img.shields.io/badge/-RxSwift-red">

***

* 목차
  * 앱 실행 화면
  * 아키텍쳐 설계 및 고려한 점 [이동](#-설계-및-고려한-점)
  * 성능
  * 메모리 누수
  * 복잡한 의존성
  * Test
  * 싱글턴 디자인 패턴과 NSCache를 이용한 Image 캐싱
  * RxSwift 반응형 검색화면

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


**🧑‍💻 고민이후의 결과**

* MVC 아키텍쳐에서 UI Code와 Logic 코드의 분리 필요성을 느낌 (거대한 ViewController 및 복잡한 의존성 문제)
  * MVVM의 도입
  * Presentation Logic 분리를 위해 코딩하는 시간이 조금 더 걸릴 수 있지만, 프로젝트가 커져도 Unit Test가 편리
  * 과거의 문제점 (복잡한 의존성, 거대한 클래스) 해결 가능하다고 판단 + ViewModel의 추상화로 유연해지는 구조
  * 무의식적으로 ViewController가 비대해지는 상황을 방지할 수 있음
  * 유지보수가 편해지므로, 시간이 지날 수록 생산성이 증가한다고 판단

* 나아가 Coordinator를 통해 View 전환 Code 통합 관리의 필요성 (유연한 View 전환 대응)
  * View 전환 코드 하드 코딩 X, 메소드 한줄로 자유로운 View 전환 (여러 상황에 유연 + 가독성 증가)
  * View는 ViewModel의 데이터를 표현만하는 단일 책임을 지게됨

* ARC를 고려하여 ViewModel 및 Coordinator가 Retain Cycle이 생기지 않도록,  선제적인 레퍼런스 카운트 관리




#### **현재 프로젝트에 맞는 MVVM - C 구조 도입**

<p align="center">
<img src="https://user-images.githubusercontent.com/55793344/143764461-8c8ef2a6-6d36-4df1-a5f3-ced1b57d165b.jpeg" width="650" height="370"/>
</p>

* Testable한 구조, View에선 불필요한 화면전환 Code를 가지지 않으며 여러 상황에 맞는 자유로운 View 전환 가능

* MVVM 계산기를 만들어 보며 Logic 및 UI Code 분리에 대한 이해, RxSwift bind의 편리함을 알게됨

* 적재적소에 맞는 코드 작성 / 의존성 줄이기 / 자유로운 뷰 전환 구조 / Testable한 구조

* 통신을 담당하는 APIService는 ViewModel에 의존성 주입 및 분리

***

### 📕성능

**☑️ 성능 향상을 위해**

* 상속이 필요하지 않은 class는 final class로 선언 
* 클래스 내부에서만 사용되는 property에 대하여 적극적으로 private 선언
* 통신 환경 고려, Caching이 필요한 부분을 적극적으로 찾아냄

**=> 메소드 인라이닝과 컴파일러 최적화를 통해 성능 개선**

**=> 유저의 통신 리소스는 줄이고, 데이터는 캐싱하여 성능 개선**  


**1️⃣ 바이닐 보관함 데이터는 CoreData를 통해 캐싱**

**왜 보관함 데이터가 캐싱이 필요했는지?**

* 바이닐 앨범의 썸네일 이미지, 제목, Artist, 바이닐 고유 ID 정도가 보관함 데이터로 저장
* 썸네일 이미지크기가 대략 200kb 이지만, 데이터가 100개라면 20mb 크기를 가짐
* 보관함에서 대표 이미지를 설정하고, 검색화면으로 이동 하므로
  * 보관함에 진입할때마다 통신을 진행하면 많은 통신 리소스가 투입되어짐
  * 또한 보관함 화면은 9개씩 데이터를 Paging하여 보여주기에
  * 자연스럽고 부드러운 Paging을 위해서 캐싱이 진행되어야했음

**=> 여러번 이미지 통신이 이루어 져야하는 부분을 최소화 하여 내부 데이터로 저장하여 성능상 이점을 챙기도록함**

**=> 바이닐 보관시 서버에 기록되며, 보관함 데이터는 내부 CoreData에 저장하여 보관함 화면에서 보여줌**

**=> 앱을 지우고 다시 로그인한 경우**

**=> 보관함에 진입시 통신을 통해 CoreData 캐싱을 진행하고(동기화) 다시 기존 방식으로 진행되도록 설계중**  


**2️⃣ 빠른 Scroll시 성능저하 방지를 위해 이미지 통신 Cancel**

**처음 검색 화면의 문제점 정의**

* 실제 프로젝트에서, 검색 화면에서 최대 검색 데이터 수는 50개
* 빠른 스크롤로 맨 밑으로 TableView 이동시 이전의 스크롤되는 이미지 통신이 모두 진행됨
* 데이터 속도가 느린 상황이라면, 이전의 셀 이미지 통신때문에 보여져야 할 셀의 이미지 통신이 느려질 수 있음
* 또한, 원하는 검색 결과가 맨밑에 있었다면 중간에 있는 셀들의 이미지 통신은 유저 입장에선 비효율적 (데이터 소모값 증가)

**🧐 개선하며 깨달은 점**

**=> Cell의 Life Cycle을 고려하여, Cell이 재활용 상태가 될때 해당 image 비동기 통신의 DataTask가 Cancel 되도록**

**=> 빠른 스크롤시 중간 부분의 셀은 이미지 통신이 이루어지지 않고, 마지막 부분이 바로 이미지 통신 진행**

```swift
final class SearchTableViewCell: UITableViewCell {
    private var cellImageDataTask: URLSessionDataTask?
override func prepareForReuse() {
        super.prepareForReuse()
        self.cellImageDataTask?.cancel()
        self.searchVinylImageView.image = nil
    }
```

***

### 📗메모리 누수

**❌ 이전 프로젝트의 문제점**

=> 예상하지 못한 강한 참조로 인해, Retain Cycle이 발생

=> 복잡한 참조 구조로, 어떠한 Class가 누수를 일으키는지 분석이 어려움

**☑️ 해결**

* View와 ViewModel에서 다른 클래스의 참조를 주의있게 진행했습니다.
  * View와 ViewModel의 의존성과 결합도를 낮추고
  * View와 ViewModel의 불필요한 Retain Count가 증가되지않도록
* 또한 항상 자신을 참조하는 상황의 클로저 에선, 캡쳐리스트를 사용했습니다.
  * 특히 ViewModel에서 이러한 경우를 더욱 확인하고 조심했습니다.

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

***

###  📘복잡한 의존성

**❌ 이전 프로젝트의 문제점**

=> MVC 아키텍쳐로 인해, 다른 ViewController를 의존하거나 다른 Class들을 직접 프로퍼티로 참조하여 결합도가 높아짐

=> 싱글턴 패턴으로 통신 객체에 접근하게 되어 Testable한 구조를 지니기 어려움, 모든 곳에서 통신 객체에 접근이 가능

**☑️ 해결**

View에서 직접 ViewModel 객체를 만들지 않고 ViewModel Protocol에 의존(의존성 분리), Coordinator를 통해 ViewModel을 생성하고 주입 (의존성 주입)

* 추후 서비스한지 어느정도의 시간이지나면 생길 리팩토링에서 View와 ViewModeld의 결합도를 낮추기 위함

* UI 및 Unit Test에 보다 유연하게 대응 및 Test 진행 가능해짐

* 리팩토링시 보다 적은 리소스 투입

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

***

### ✅ 프로젝트 적용: Search View 및 Vinyl Detail View Mock APIService Test 진행

* Search API 구현전 Mock Test 선제 진행하여 개발
  * Mock Data로 내부 CoreData 로직 구현 및 Test 진행 가능 (생산성 증가)
* Vinyl Detail View Mock Test 진행
  * **바이닐 상세 API 연속 조회시 응답이 오지 않는 에러 이슈 즉시 발견**

**🧐고민 및 깨달은 점**

* Test가 필요하지만, 검증하기가 까다로운 Code 부분을 정확하게 Unit Test진행 (최고 레벨디자인)
* Exceptation과 fulfill, wait으로 실제 통신을 하여 Test 진행이 가능
* 하지만, 서버가 다운되거나 개발환경에서 인터넷이 끊긴 상황이라면 테스트가 불가능
* 서버통신이 가능한 상황에서도 Test가 가능하며, 통신이 분리된 Test진행도 가능해야함
* 따라서, MockAPIService 서버통신이 분리된 Test 진행이 가능하도록 변경



### ✅ 보관함 최고 레벨디자인 Paging Unit Test 진행

* 최고 레벨은, 보관함 갯수가 500개를 넘길시 달성함
* Unit Test를 진행하여, 500개의 데이터를 저장시키고 올바른 순서대로 9개씩 Paging 되는지 Unit Test 진행
* 마지막 페이지에서 데이터 Index가 맞지 않아 Test 실패
  * 올바르게 Paging 되도록 Code 수정하여, Unit Test 성공

**🧐고민 및 깨달은 점**

* Test가 필요하지만, 검증하기가 까다로운 Code 부분을 정확하게 Unit Test진행 (최고 레벨디자인)
* Logic이 들어가는 View에서 Code의 검증이 필요한 부분은 Unit Test의 필요 및 필수
  * 추후 리팩토링 진행시 Side Effect를 Unit Test로 줄일 수 있음
  * 배포준비시 Unit Test가 실패한 부분을 중점적으로 다시 확인하면 됨

***

### 🔵 싱글턴 디자인 패턴과 NSCache를 사용하여 image 캐싱

#### 검색화면 및 상세화면의 image는 NSCache를 사용하여 캐싱

**🧐고민하며 깨달은 점**

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

***

### 🔴 RxSwift를 이용한 반응형 검색화면

#### Input 데이터를 비동기 데이터를 통한 스트림으로 관리하는 법을 이해

* 일반적인 이스케이핑 클로저를 통한 통신 함수 사용 대신 
  * Observable을 통한 return이 가능한 비동기 코드 사용 

```swift
.flatMapLatest{ [unowned self] vinyl -> Observable<[SearchModel.Data?]> in
                return self.searchAPIService.searchVinyl(vinylName: vinyl)
            }
```

**(비동기 통신 Code 부분의 가독성 증가)**

**🧐고민하며 깨달은 점**

* TextField에 addTarget .editingChanged 메소드를 이용해 검색API를 구현할 수 있지만, 1글자의 변화상태마다 통신이 이루어지므로 비효율적으로 판단. 
  * DispatchQueue를 통해 Delay 상태를 구현할 수 있지만 코드의 가독성 저하
  * 별도의 DispatchQueue 작업이 이루어지므로 쓰레드에 관련해 더욱 조심히 디버깅 및 코딩이 진행 (추가 리소스 발생)

* debounce 및 observeOn 을 통해 직관적이며 간편하게 쓰레드 관리가 가능
  * 가독성 증가 및 직관적인 쓰레드 관리 표시

* 유저경험을 높임
  * 원하는 Word를 검색하고나면 검색 버튼을 눌르지 않아도 자연스럽게 검색 진행 및 결과 표시

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

