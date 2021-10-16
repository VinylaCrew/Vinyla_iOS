# Vinyla_iOS

### 국내 및 해외 바이닐 저장 및 공유, 나만의 장르 분석 서비스

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

> Home View

<img src="https://user-images.githubusercontent.com/55793344/132819324-3264e2f2-a32d-470e-9dda-1f27e4532432.png" width="375" height="812"> <img src="https://user-images.githubusercontent.com/55793344/132819338-b22fb5d9-78b8-44a4-b0a4-5a74520c4156.png" width="375" height="812"> 

> 보관함 View

<img src="https://user-images.githubusercontent.com/55793344/132819665-c983f9c1-eda5-4e7c-9d94-8ba07d526c20.gif" width="375" height="812">
