# CampingProject
## 캠토리지(2022.03 중 앱스토어 배포 예정)
- 개인이 가진 캠핑 장비를 목록화하여 관리하고 친구들과 서로의 장비 목록을 공유 할 수 있는 앱
<img width="1253" alt="스크린샷 2022-03-14 오후 1 33 39" src="https://user-images.githubusercontent.com/21233207/158111082-5e5825a3-784b-4b7f-a20f-52a079d37aaa.png">

**개발 환경**

Swift

**사용 라이브러리**
<pre><code># Pods for CampingProject
 pod 'Alamofire', '~> 5.2'
 pod "BSImagePicker", "~> 3.1"
 pod 'TextFieldEffects'
 pod 'RxSwift'
 pod 'RxCocoa'
 pod 'Kingfisher'</code></pre>

**상세 기능**
1. **로그인 & 회원가입**
![Simulator Screen Shot - iPhone 12 - 2022-03-13 at 17.42.08.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f9636f59-6d7a-4053-86c7-a013c2d1ef98/Simulator_Screen_Shot_-_iPhone_12_-_2022-03-13_at_17.42.08.png)

![Simulator Screen Shot - iPhone 12 - 2022-03-13 at 20.16.52.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1dda54dc-7cbe-4dee-94d0-5dbbaeee44d2/Simulator_Screen_Shot_-_iPhone_12_-_2022-03-13_at_20.16.52.png)

![Simulator Screen Shot - iPhone 12 - 2022-03-13 at 17.44.08.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/f596a190-2233-401c-b23f-5cf3bd1c0e19/Simulator_Screen_Shot_-_iPhone_12_-_2022-03-13_at_17.44.08.png)

![Simulator Screen Shot - iPhone 12 - 2022-03-13 at 17.44.16.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/c23dc267-c3a5-462f-80fb-443b88f59be3/Simulator_Screen_Shot_-_iPhone_12_-_2022-03-13_at_17.44.16.png)

- 이메일 인증을 통해 중복 방지
- 로그인 시 서버에서 JWT토큰을 사용자 인증 용도로 사용

**개인정보 처리방침**
https://github.com/kojeonggeun/CamtoragePrivacyPolicy
