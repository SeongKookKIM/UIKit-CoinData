# CoinData App - 실시간 코인 가격 조회

시연영상 URL: https://sam-blog-image.s3.ap-northeast-2.amazonaws.com/CoinSeeVideo.mp4

<br/>
이 프로젝트는 코인 API를 활용하여 실시간으로 다양한 암호화폐의 가격 변동을 시각적으로 확인할 수 있는 플랫폼입니다. 사용자들은 간편하게 원하는 코인을 검색하고, 직관적인 그래프 UI를 통해 실시간 가격 추이를 확인할 수 있습니다. 로그인한 사용자는 자신만의 관심 코인을 북마크하여 편리하게 관리할 수 있습니다.

<p align="center">
  <img src="https://github.com/user-attachments/assets/3ee3e83d-1c7d-4e49-86ec-a4ebd615b4da" alt="이미지1 설명" width="200" />
</p>
- 간편한 검색: 다양한 코인을 빠르게 검색하여 실시간 가격을 확인할 수 있습니다.

<br/>
<br/>
<br/>

<p align="center">
  <img src="https://github.com/user-attachments/assets/3dbe179b-b3bb-4be8-8546-20c89a1d4b95" alt="이미지1 설명" width="200" />
</p>
- 직관적인 그래프 UI: 실시간으로 업데이트되는 가격 그래프를 통해 시각적인 데이터 분석이 가능합니다.

<br/>
<br/>
<br/>

<p align="center">
  <img src="https://github.com/user-attachments/assets/2fb263d9-84f9-4731-8e20-cb34a18ea882" alt="이미지1 설명" width="200" />
</p>
- 개인 맞춤 북마크: 로그인한 사용자는 관심 있는 코인을 북마크하여 언제든지 빠르게 확인할 수 있습니다.

## 개발도구 및 스텍

### 개발 기간

2024.07.25 ~ 2024.08.17

### 개발 환경

- **Swift**: 5.9
- **Xcode**: 15.4
- **iOS**: 17.5
- **Node.js**: 22.5.1
- **Yarn**: 1.22.22

### 기술 스택

- **iOS**: UIKit
- **Server**: Express
- **Database**: MongoDB
- **Software Architecture**: MVVM
- **비동기 처리**: Combine + Swift Concurrency

### Dependencies

- **iOS**
  - DGChart: 5.1.0
- **Node.js**
  - TypeScript: 5.5.4
  - Express: 4.19.2
  - jsonwebtoken: 9.0.2

### 서버 설정 및 배포

- **서버 설치**: yarn install
- **배포 환경**: Vercel

<br/>

## 주요 기능 소개

1. 자동 로그인

- 로그인 시 액세스 토큰(30분)과 리프레시 토큰(7일)을 키체인에 저장합니다.
  서버에서 토큰의 만료일을 확인하며, 액세스 토큰이 만료되면 리프레시 토큰을 사용해 유효성을 검사하고, 통과할 경우 액세스 토큰을 재발행하여 자동 로그인을 처리합니다.

2. XCTest를 사용한 단위 테스트

- 각 뷰의 주요 기능에 대해 XCTest를 활용하여 단위 테스트를 진행합니다.
  이를 통해 기능별 오류를 사전에 방지하고, 발견된 문제를 신속히 수정할 수 있습니다.

3. Extension 사용

- 자주 사용되는 UI 구성 요소나 공통 함수는 extension을 사용하여 관리합니다.
  이를 통해 코드의 재사용성과 수정의 용이성을 높였습니다.

4. 서버 통신 오류 처리

- 데이터베이스 조회나 로그인 과정에서 발생할 수 있는 오류는 서버에서 처리한 후 클라이언트로 반환합니다.
  반환된 오류는 레이블을 통해 UI로 시각화하여 사용자에게 명확히 전달합니다.

5. 회원가입 및 로그인 시 유효성 검사

- 닉네임: 최소 2자 이상.
- 아이디: 영문과 숫자 조합으로 최소 6자 이상.
- 비밀번호: 소문자, 대문자, 숫자, 특수기호를 포함하여 최소 8자 이상.
- 비밀번호 재확인: 비밀번호가 일치하는지 확인하는 기능을 추가하여 안전한 회원가입을 지원합니다.

```
테스트 계정

ID: test123
PW: Test123@
```

이 기능들을 통해 사용자는 더욱 안전하고 편리하게 서비스를 이용할 수 있으며, 시스템은 자동화된 로그인과 철저한 유효성 검사로 안정성을 높였습니다.

## 트러블 슈팅

1. 실시간 데이터 업데이트 문제

- 문제: 실시간으로 코인 가격을 업데이트해야 하지만, 현재는 10분 단위로 데이터가 갱신됩니다.

- 해결 계획: 무료 소켓 API를 찾아서 적용한 후, 실시간 데이터를 제공하도록 개선할 예정입니다.

<br/>

2. 테스트 코드 작성 시 발생한 문제

- 문제: isSecureTextEntry 속성에 따라, textFields와 secureTextFields로 나누어야 하는 상황이 발생.

- 해결 방법: 테스트 코드 작성 시, isSecureTextEntry 속성에 맞게 다음과 같이 처리해야 했습니다.

```
let nicknameTF = app.textFields["signUpNickname"]
let idTF = app.textFields["signUpID"]
let passwordTF = app.secureTextFields["signUpPW"]
let passwordCheckedTF = app.secureTextFields["signUpPWCheck"]
```

![image](https://github.com/user-attachments/assets/c5e3b9cf-561f-49ed-928d-104c14b854d3)

- 추가 해결 방법: 자동 생성되는 강력한 비밀번호 입력 기능(Automatic Strong Password) 문제는 .textContentType = .newPassword로 설정하여 해결하였습니다.

3. 아키텍처 변경으로 인한 복잡도 증가

- 문제: 처음에는 단순히 코인 가격을 확인하는 기능만 구현하려 했지만, 로그인 및 북마크 기능을 추가하면서 확장성이 필요해졌습니다. 이를 고려하지 않은 초기 설계로 인해 코드가 복잡해졌습니다.

- 해결 방법: 프로젝트를 MVC 아키텍처로 개발하던 중, 코드의 복잡도가 증가함에 따라 MVVM 아키텍처로 변경하여 유지보수성과 확장성을 개선하였습니다.
