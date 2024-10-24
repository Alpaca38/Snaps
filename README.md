# Snaps

## 프로젝트 소개
> 좋아하는 사진을 탐색하고 저장할 수 있는 앱

### 화면
| 프로필 화면 | 토픽 화면 | 랜덤 사진 | 검색 화면 | 찜 화면 | 상세 화면 |
| --- | --- | --- | --- | --- | --- |
| ![Simulator Screenshot - iPhone 15 Pro - 2024-10-24 at 13 44 37](https://github.com/user-attachments/assets/8c974864-c38e-4c67-ae90-c6846c8e93bd) | ![Simulator Screenshot - iPhone 15 Pro - 2024-10-24 at 13 45 38](https://github.com/user-attachments/assets/5ca84388-94a4-4b8c-997a-c21b9b2ad41a) | ![Simulator Screenshot - iPhone 15 Pro - 2024-10-24 at 13 45 47](https://github.com/user-attachments/assets/aa4ae323-a7e5-4838-9892-717c4eebb122) | ![Simulator Screenshot - iPhone 15 Pro - 2024-10-24 at 13 46 37](https://github.com/user-attachments/assets/822d8482-7af8-40b3-a105-59c42485f294) | ![Simulator Screenshot - iPhone 15 Pro - 2024-10-24 at 13 47 05](https://github.com/user-attachments/assets/e1d35ad4-aefc-483a-b33c-39f297fdebac) | ![Simulator Screenshot - iPhone 15 Pro - 2024-10-24 at 13 47 18](https://github.com/user-attachments/assets/0287467e-f720-4577-a73a-d573944278fe)
 
### 최소 지원 버전
> iOS 15

### 개발 기간
> 2024.07.22 ~ 2024.07.29

### 개발 환경
- **IDE** : Xcode 15.4
- **Language** : Swift 5.7

### 핵심 기능
- **프로필**
  - 프로필 사진, 닉네임 및 MBTI 설정
  - 프로필 수정
- **사진 조회**
  - 카테고리에 따른 사진
  - 랜덤 사진
  - 원하는 사진 검색 및 필터링
- **사진 저장**
  - 원하는 사진 저장 및 필터링

### 사용 기술 및 라이브러리
- UIKit, SnapKit, MVVM
- RxSwift, RxDataSource
- Down Sampling
- Skeleton View
- Realm

### 주요 기술
#### 아키텍쳐
- **MVVM**
  - RxSwift를 이용해 데이터 바인딩을 구현
  - Input-Output 패턴을 이용해 VM과 VC의 데이터 바인딩을 구현

#### 네트워킹
- **Router**
  - REST API 통신
  - 라우터 패턴과 TargetType 프로토콜을 이용해 네트워크 작업을 추상화
  - RxSwift의 Single을 사용해 네트워크 요청이 실패 했을 때에도 스트림이 유지

- **네트워크 에러 처리**
  - 커스텀 에러를 만들어 상태코드에 따라 다르게 처리

#### UI/UX
- **UIKit & SnapKit**
  - 코드 기반 UI 구현
  - 오토레이아웃 관리

- **RxSwift & RxDataSource**
  - 반응형 프로그래밍 구현
  - 데이터 스트림 관리

- **Skeleton View**
  - 사용자 경험 향상을 위해 데이터 통신이 진행중인 것을 시각화

#### 페이지네이션
  - 오프셋 기반 페이지네이션

#### 다운 샘플링
  - Unsplash API로 이미지 데이터를 받아올 때 다운 샘플링

#### 로컬 DB
  - 찜한 사진 로컬 DB에 저장
  - Repository를 만들어 로컬 DB에 관련된 로직을 담당하게 함
  - 여러 뷰 컨트롤러에서 로컬 DB의 CRUD에 따른 상태 공유

