docker-postfix
==============

Postfix on Docker.

## Requirement

-   MySQL
-   Docker 0.8 or higher

## Install

    docker build -t yuanying/postfix .
    sudo groupadd -g 1500 vmail
    sudo useradd -g vmail -u 1500 vmail -d /var/vmail
    sudo mkdir /var/vmail
    sudo chown vmail:vmail /var/vmail

## How to use

    docker run -d --link mysql:mysql \
      -e "MYSQL_PORT_3306_TCP_ADDR=172.0.0.24" \
      -e "MYSQL_PORT_3306_TCP_PORT=3306" \
      -e "POSTFIX_MYSQL_PASSWORD=postfixpassword" \
      -h 'mail.fraction.jp' \
      -v /var/vmail:/var/vmail \
      -p 25:25 \
      yuanying/postfix

## License

The MIT License (MIT)
Copyright (C) 2014 O.Yuanying, http://www.fraction.jp/

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
