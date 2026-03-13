FROM legionio/legion

COPY . /usr/src/app/lex-consul

WORKDIR /usr/src/app/lex-consul
RUN bundle install
