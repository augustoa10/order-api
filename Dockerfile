FROM augustoa10/ruby-rails:6.0.2.1

WORKDIR /root

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY app app
COPY bin bin
COPY config config
COPY db db
COPY lib lib
COPY public public
COPY vendor vendor
COPY config.ru package.json Rakefile ./

ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE c12e5c5a529444538578042449abd133df266c428ee2644aaf10fda3b5344e67f23f7e7224c6e81aa0170050e5721f2c88a8ed648c9e5568ecda51aeed33333a

RUN mkdir -p log

EXPOSE 3000

CMD ["bash", "-c", "rails db:migrate && rails server -p 3000 -b 0.0.0.0"]
