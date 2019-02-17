Kyoto Cabinet
====

Install
----

```
$ rbenv --version
rbenv 1.1.1-39-g59785f6
$ sudo apt install libkyotocabinet-dev
$ wget https://fallabs.com/kyotocabinet/rubypkg/kyotocabinet-ruby-1.33.tar.gz
$ tar xvzf kyotocabinet-ruby-1.33.tar.gz
$ cd kyotocabinet-ruby-1.33
$ ruby extconf.rb
$ make
$ ruby test.rb
$ make install
/usr/bin/install -c -m 0755 kyotocabinet.so /home/koshigoe/.rbenv/versions/2.6.1/lib/ruby/site_ruby/2.6.0/x86_64-linux
```
