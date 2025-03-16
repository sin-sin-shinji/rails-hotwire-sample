## 環境構築

### 必要なもの
- Git
- Docker
- Ruby 3.4.2
- Rails 8.0.1
- MySQL 8.4
- Node.js 22.x

### セットアップ手順

* リポジトリをクローン

```sh
git clone https://github.com/sin-sin-shinji/rails-hotwire-sample.git
cd rails-hotwire-sample
```

* Dockerを使用する場合

```sh
# Build docker
docker-compose build

# Install gems
docker-compose run --rm app bundle install

# DB migration
docker-compose run --rm app bundle exec rails db:create db:migrate

# Start server
docker-compose up -d
```

* Local PC上に構築する場合

```sh
# Install gems
bundle install

# DB migration
bundle exec rails db:create db:migrate

# Start server
bundle exec rails s -p 3000 -b 0.0.0.0
```


### lint

```sh
# Rubocop実行 （チェックのみ）
bundle exec rubocop

# チェック & 修正
bundle exec rubocop -a
```

### Test

* テストは以下を利用している
  * rspec
  * capybara
  * playwright


```sh
# テスト実行
RAILS_ENV=test bundle exec rspec

# springを用いて、実行する場合
bin/rspec
```
