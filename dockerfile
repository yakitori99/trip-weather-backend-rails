FROM ruby:3.0.2

# railsのアプリディレクトリを作成し、作業ディレクトリとして指定
RUN mkdir /app
WORKDIR /app

# 本番環境向けに環境変数を設定
ENV RAILS_ENV="production"
ENV NODE_ENV="production"

# nodejsとyarnをインストール(webpackをインストールする際に必要)
RUN apt-get update -qq && apt-get install -y nodejs yarn

# 依存パッケージをインストール
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# 必要ファイルをコピー
COPY . /app

# 起動スクリプトを実行
RUN chmod 744 /app/start.sh
CMD ["sh", "/app/start.sh"]
