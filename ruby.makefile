SHELL=/bin/bash
RUBY_INSTALL_ROOT=$(HOME)/.rubies
SRC_ROOT=$(HOME)/src
RUBY_SRC_ROOT=$(HOME)/src

ruby-install: RUBYINSTALL_VERSION=0.5.0
ruby-install:
	wget -O ruby-install-$(PHPINSTALL_VERSION).tar.gz https://github.com/helstern/php-install/archive/v$(PHPINSTALL_VERSION).tar.gz
	tar -xzvf ruby-install-$(PHPINSTALL_VERSION).tar.gz
	cd ruby-install-$(RUBYINSTALL_VERSION) && sudo $(MAKE) install
	rm -rf ruby-install-$(RUBYINSTALL_VERSION)

chruby: CHRUBY_VERSION=0.3.9
chruby:
	wget -O chruby-$(CHRUBY_VERSION).tar.gz https://github.com/postmodern/chruby/archive/v$(CHRUBY_VERSION).tar.gz
	tar -xzvf chruby-$(CHRUBY_VERSION).tar.gz
	cd chruby-$(CHRUBY_VERSION) && sudo $(MAKE) install
	rm -rf chruby-$(CHRUBY_VERSION)
	sudo make install
	@echo 'source /usr/local/share/chruby/chruby.sh' > ~/.bashrc.d/chruby.sh
	chmod +x ~/.bashrc.d/chruby.sh

ruby2.1: RUBY_VERSION=2.1.3
ruby2.1: RUBY_FLAVOUR=ruby
ruby2.1: RUBY_INSTALL_DIR=$(RUBY_INSTALL_ROOT)/$(RUBY_FLAVOUR)-$(RUBY_VERSION)
ruby2.1: RUBY_SRC_DIR=$(RUBY_SRC_ROOT)/$(RUBY_FLAVOUR)-$(RUBY_VERSION)
ruby2.1: ruby-uninstall ruby-install ruby-configure ruby-src-clean

ruby-uninstall:
	rm -rf $(RUBY_INSTALL_DIR)

ruby-install:
	ruby-install $(RUBY_FLAVOUR) $(RUBY_VERSION) --install-dir $(RUBY_INSTALL_DIR)

ruby-configure:
	source $(CHRUBY_PATH)/chruby.sh; \
		chruby $(RUBY_FLAVOUR) $(RUBY_VERSION); \
		gem update --system; \
		gem install --no-ri --no-rdoc bundler passenger rails rspec pry cucumber less sass ruby-debug-ide

ruby-src-clean:
	rm -rf $(RUBY_SRC_DIR)
