## 環境構築

### **1. 必要なもの**
- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- Ruby 3.4.2
- Rails 8.0.1
- MySQL 8.4

### **2. セットアップ手順**

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
docker-compose run --rm app rails db:create db:migrate

# Start server
docker-compose up -d
```
