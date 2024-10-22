# 저요저요 V1.0

> 취업 할 사람?? 저요저요!<br/>쉽게 이미지로 채용 공고를 등록하면, 이미지 분석을 통해 세부 채용 전형을 자동으로 분류해서 확인할 수 있는 앱


![image](https://github.com/user-attachments/assets/3d6dec24-915c-4e2f-9f50-b5895fd9b8b5)

## 프로젝트 환경

- 인원: iOS 개발자 1명
- 기간: 2024.09.15 ~ 2024.10.02 (V1.0 기준)
- 최소버전: iOS 16 +
- 기술 스택
    - **Framework**: SwiftUI, Vision
    - **Reactive Programming**: Combine
    - **Architecture**: MVVM
    - **네트워크**: Moya
    - **데이터베이스**: Realm
    - **데이터 분석**: OpenAI


<br/>

## 버전별 기능
- **V1.0**
  - [x] 공고 등록 및 분석 기능
  - [x] 공고 저장 기능
  - [x] 공고 조회 및 검색 기능
  - [x] 캘린더 조회 기능

<br/>

## 주요 기능

- **`공고 분석 화면` :** 공고 이미지의 텍스트를 읽어 상세 전형을 분류 및 수정할 수 있는 화면
    - 갤러리에서 공고 이미지를 선택하면 VNRecognizeTextRequest로 이미지의 텍스를 읽고,
        - 텍스트가 없는 경우 분석할 수 없는 이미지라고 Alert를 띄우거나
        - 텍스트가 있는 경우 텍스트 분석 단계(= 네트워크 통신)로 넘어갑니다.
    - 텍스트 분석은 OpenAI API를 사용하며, 회사명, 전체 모집 기간, 세부 전형 정보를 응답값으로 받아 화면에 표시합니다.
    - 이미지는 스크롤 및 zoom-in, out이 가능하며, 틀린 정보가 있다면 수정할 수 있습니다.
    - 정보 확인을 위하여 네비게이션 상단에 저장 버튼을 두지 않고 floating sheet의 가장 하단에 저장 버튼을 위치시켰습니다.
- **`공고 조회 & 검색 화면` :** 저장된 공고 목록을 조회 및 검색할 수 있는 화면
    - 초기 및 검색어가 없을 경우에는 등록한 전체 공고 목록을 조회할 수 있습니다.
    - 회사명을 검색하면 해당 검색어를 포함하는 회사명을 가진 공고들을 조회할 수 있습니다. 
- **`캘린더 화면`** : 해당 날짜에 모집과 전형을 진행하고 있는 회사를 캘린더에서 확인할 수 있는 화면
    - 상시 채용이 아닌 기간이 있는 회사만 캘린더에서 조회할 수 있습니다.
    - 날짜를 선택하면 해당 날짜에 전형을 진행하는 회사를 하단에서 목록으로 확안할 수 있습니다.

### 화면
|공고 분석 화면|공고 조회 및 검색 화면|캘린더 조회 화면|
|--|--|--|
|![image](https://github.com/user-attachments/assets/d3167d94-d01e-4e47-92b0-13437fcd4219)|![image](https://github.com/user-attachments/assets/cdfe9bd5-4bc8-4d2d-ad8e-fd3d4788c8b2)|![image](https://github.com/user-attachments/assets/2d8575b3-b0c3-45f7-b45c-0baf1efec089)|


<br/>

## 기술 스택 상세

- **Router Pattern과 Moya의 TargetType 활용**
    - 네트워크 설계시에 Router Pattern을 사용한 이유로는
        - 네트워크 요청을 추상화하여 코드 가독성과 유지보수성을 향상시켰습니다.
        - API 엔드포인트를 Router로 관리하여, 새로운 API 추가시 유연한 확장성을 보장할 수 있기 때문에 Router Pattern을 사용하였습니다.
    - Moya 라이브러리를 사용한 이유로는
        - Moya는 API 요청을 TargetType 프로토콜로 정의하기 때문에 모든 요청을 일관된 구조로 관리하기 때문에 API 요청이 명확하게 구성되고, 중복된 코드를 줄이며 코드의 가독성을 높일 수 있습니다.
- **SwiftUI + Combine + MVVM 아키텍처**
    - SwiftUI와 Combine을 함께 사용하면 선언적 UI와 반응형 프로그래밍의 장점을 결합하여 효율적인 데이터 처리와 동기화된 UI 업데이트가 가능해져서 코드의 간결성, 성능 최적화, 유지보수성을 높일 수 있습니다.
    - MVVM에서 데이터의 바인딩
        - View가 ViewModel의 데이터를 구독하고, ViewModel의 데이터가 변경되면 자동으로 View가 업데이트 되는 MVVM의 구조는 SwiftUI에서의 `@ObservedObject`, `@StateObject` 및 Combine의 `@Published` 프로퍼티와 잘 결합되기 때문에 MVVM의 구조를 사용하였습니다.
- **서버의 통신 모델(DTO)과 앱 내 데이터 모델(Model) 분리**
    - 서버의 DTO와 앱 내에서 사용하는 Model을 분리함으로써, 서버의 데이터 구조가 변경되더라도 앱 내 Model은 그대로 유지할 수 있고, 앱 내부의 비즈니스 로직이나 UI 로직이 불필요하게 변경되는 것을 방지할 수 있습니다.
- **Vision 프레임워크를 사용하여 이미지에서 텍스트를 추출하는 OCR 객체**
    - iOS 16부터는 텍스트 인식 관련 기능이 더욱 개선된 버전인 `VNRecognizeTextRequestRevision3` 이 지원되기 때문에 해당 버전을 사용하여 성능을 최적화시켰습니다.
    - UIImage를 받아서 `비동기적`으로 텍스트를 인식하고, 인식된 텍스트를 반환하거나 텍스트가 없거나 오류가 발생하면 에러를 반환합니다. Combine의 Future를 사용하여 비동기적으로 결과를 처리합니다.
- **NavigationLazyView를 사용하여 초기 뷰 로드 최적화**
    - NavigationLazyView를 사용해서 init 시점에 불필요한 메모리 소비를 줄이고 뷰를 사용하는 시점에 rendering을 해서 앱의 성능을 향상시킬 수 있습니다.
- **Compositional Layout 및 기기 화면 사이즈의 비율에 맞춘 다양한 기기 화면에 대응하는 레이아웃 구현**
    - 기기의 가로, 세로 크기를 기반으로 각 컴포넌트의 CGSize를 비율로 계산해서 컴포넌트의 크기를 사용하기 때문에 다양한 기기에 맞는 화면을 구현할 수 있습니다.

 <br/>
 
# 트러블 슈팅
### FirstResponder로 Keyboard를 비활성화 시키고자 하였을 때 다른 컴포넌트가 비활성화되는 문제
FirstResponder가 빈 화면이 아닌 다른 컴포넌트일 때 Keyboard가 dismiss 되지 않고 해당 컴포넌트가 비활성화되는 문제가 발생함.
해결) FirstResponder로 keyboard를 비활성화 시키는 방법은 동일하게 사용하지만, 범위를 개별 View에 설정하지 않고 APP 전체에 설정함
```swift
struct Jeo_yoApp: App {
   var body: some Scene {
       WindowGroup {
           ApplicantListView()
               .onAppear(perform: {
                   UIApplication.shared.addTapGestureRecognizer()
               })
       }
   }
}
```
