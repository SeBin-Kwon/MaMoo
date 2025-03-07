# 🎬 MAMOO

> MAMOO는 오늘의 추천 영화를 확인하고, 영화를 검색할 수 있는 앱입니다.

- **기간:** 9일 (25.01.24 ~ 25.02.01)

- **인원:** 1명

## 🍿 주요 기능

- 온보딩 및 프로필 설정
  - 앱 최초 실행시 온보딩 페이지가 나옵니다.
  - 닉네임과 이미지로 프로필을 설정할 수 있습니다.
  - 이후 메인 및 설정 화면에서 프로필을 수정할 수 있습니다.

- 메인 화면
  - 프로필 편집
    - 닉네임과 이미지를 수정할 수 있습니다.
  - 최근 검색어 저장
    - 검색한 단어는 자동으로 저장이 됩니다.
    - 최근 검색어를 누르면 바로 검색 됩니다.
    - 엑스 버튼 및 전체 삭제로 최근 검색어를 지우실 수 있습니다.
  - 오늘의 영화 추천
    - 추천하는 오늘의 영화 20개를 볼 수 있습니다.

- 영화 검색
  - 원하는 영화를 검색할 수 있습니다.

- 영화 상세 정보
  - 선택한 영화에 대해 상세한 정보를 볼 수 있습니다.
- 영화 좋아요 저장
  - 영화에 좋아요 표시를 할 수 있고 이는 무비박스에 담기게 됩니다.
- 탈퇴 기능

## 🛠️ 기술 스택

Swift, UIKit, SnapKit, Kingfisher, Alamofire, TMDB API



## 🔍 기술 설명

> 모든 뷰는 UIKit **Codebase**로 구성했습니다.

### 폴더 구조

- Base
- Custom
- Extension
- Manager
- Model
- Present
  - Onboarding
  - Profile
  - Main
  - Search
  - Setting

### Base

- View마다 반복되는 공통 메서드, UI들을 CustomView로 관리했습니다.

### Networking

- TMDB API와 Alamofire를 이용하여 네트워크 통신을 구현하였습니다.

- NetworkManager를 만들어 싱글톤 패턴을 적용하였습니다.
- Decodable로 제약 설정한 제네릭을 활용하여 여러 API를 하나의 메서드로 대응할 수 있도록 했습니다.
- API는 열거형을 활용하여 header와 endPoint, parameter를 관리했습니다.
- 열거형 및 얼럿을 통해 상태코드를 처리하였습니다.

### UserDefaults

- UserDefaultsManager를 만들어 싱글톤 패턴을 적용하였습니다.
- Property Wrapper에 값을 가져오고 세팅하는 제네릭 함수를 호출하여 타입에 유연하게 대응할 수 있도록 했습니다.
- UserDefaultsProtocol를 만들어서 제네릭에 제약을 설정했습니다.

### 검색 기능

- SearchBar를 통해 검색 시, 네트워크 호출 후 CollectionView에 검색 결과를 표현했습니다.
- 결과가 없을 경우, 중복 검색일 경우 등 예외 처리하였습니다.
- 검색한 텍스트를 UserDefaults에 저장하여 최근 검색어를 구현하였습니다.

### 페이지네이션

- UICollectionViewDataSourcePrefetching 프로토콜을 채택하여 페이지네이션을 구현하였습니다.

### 좋아요 기능

- 영화 별 id를 통해 각각의 셀을 고유하게 버튼 상태를 업데이트 할 수 있도록 했습니다.
- NotificationCenter를 이용하여 여러 뷰에 동시에 값을 전달할 수 있도록 했습니다.



## 🚨 트러블슈팅

### 1. 셀의 재사용성으로 인한 좋아요 버튼의 바인딩 이슈

- 컬렉션뷰 셀 안의 버튼이 재사용성 문제 때문에 버튼 상태가 제대로 동작하지 않음
- 처음엔 셀의 인덱스와 버튼 상태를 담은 리스트의 인덱스로 해결하였음
- 하지만 이는 영화 id를 키값으로 갖는 좋아요 딕셔너리와 호환되지 않음
- 또한 UserDefaults의 값을 그대로 버튼 액션에 따라 업데이트하려 해도 ViewController는 이를 알 수 없어 UI가 갱신되지 않음
- 컬렉션뷰 셀은 100% 조건처리를 해야 재사용성 문제가 발생하지 않음
- 이는 조건 처리가 아니라면 각각의 셀을 고유하게 처리해야 함을 의미함
- 인덱스가 아니더라도 id를 통해서 셀을 고유하게 처리할 수 있음
- ViewController에도 영화 id를 키값, 좋아요 상태를 밸류값으로 갖는 딕셔너리로 셀을 처리해야 함을 깨달음
- 각 셀마다의 영화 id로 좋아요 딕셔너리 밸류에 접근하고, 그 bool값을 해당 셀 버튼에 업데이트해줌
- 그 후 노티피케이션으로 좋아요 딕셔너리 및 UserDefaults에 데이터 전달함
- 다른 뷰의 좋아요도 같이 반영되면서 해결함

