# 베이스 이미지로 Node.js 21 버전을 사용합니다.
FROM node:21

# 작업 디렉토리를 생성하고 설정합니다.
WORKDIR /app

# package.json과 yarn.lock 파일을 복사합니다.
COPY package.json yarn.lock ./

# 의존성을 설치합니다.
RUN yarn install

# 모든 소스 파일을 복사합니다.
COPY . .

# TypeScript를 컴파일합니다.
RUN yarn build

# 서버를 시작합니다.
CMD ["yarn", "start"]