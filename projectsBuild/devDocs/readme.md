## Install

* manual

```
sudo apt install nodejs
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

rvm install "ruby-2.6.5"
source /etc/profile.d/rvm.sh

git clone https://github.com/freeCodeCamp/devdocs.git && cd devdocs

gem install execjs
gem install bundler
bundle install
bundle exec thor docs:download --default
bundle exec rackup
```

