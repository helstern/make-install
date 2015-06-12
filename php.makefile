SHELL=/bin/bash
PHP_INSTALL_ROOT=$(HOME)/.php_versions
SRC_ROOT=$(HOME)/src
PHP_SRC_ROOT=$(HOME)/src

php-install: PHPINSTALL_VERSION=0.0.3
php-install:
	wget -O php-install-$(PHPINSTALL_VERSION).tar.gz https://github.com/helstern/php-install/archive/v$(PHPINSTALL_VERSION).tar.gz
	tar -xzvf php-install-$(PHPINSTALL_VERSION).tar.gz
	cd php-install-$(PHPINSTALL_VERSION) && sudo $(MAKE) install
	rm -rf php-install-$(PHPINSTALL_VERSION)

chphp: CPHP_VERSION=0.0.1
chphp:
	wget -O chphp-$(CPHP_VERSION).tar.gz https://github.com/marcosdsanchez/chphp/archive/v$(CPHP_VERSION).tar.gz
	tar -xzvf chphp-$(CPHP_VERSION).tar.gz
	cd chphp-$(CPHP_VERSION)/ && sudo $(MAKE) install
	rm -rf chphp-$(CPHP_VERSION)
	@echo 'source /usr/local/share/chphp/chphp.sh' > ~/.bashrc.d/chphp.sh
	chmod +x ~/.bashrc.d/chphp.sh

php5.3: PHP_VERSION=5.3.28
php5.3: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php5.3: PHP_SRC_DIR=$(PHP_SRC_ROOT)/php-$(PHP_VERSION)
php5.3: php-uninstall php5.3-install php-configure php-src-clean

php5.4: PHP_VERSION=5.4.24
php5.4: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php5.4: PHP_SRC_DIR=$(PHP_SRC_ROOT)/php-$(PHP_VERSION)
php5.4: php-uninstall php-install php-configure xdebug-pecl-install xdebug-pecl-enable php-src-clean

php5.5: PHP_VERSION=5.5.8
php5.5: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php5.5: PHP_SRC_DIR=$(PHP_SRC_ROOT)/php-$(PHP_VERSION)
php5.5: php-uninstall php-install php-configure xdebug-pecl-install xdebug-pecl-enable php-src-clean

php5.6: PHP_VERSION=5.6.9
php5.6: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php5.6: PHP_SRC_DIR=$(PHP_SRC_ROOT)/php-$(PHP_VERSION)
php5.6: php-uninstall php-install php-configure xdebug-pecl-install xdebug-pecl-enable php-src-clean

php5.3-install:
	php-install php $(PHP_VERSION) --install-dir $(PHP_INSTALL_DIR) -- \
		--with-config-file-path=$(INSTALL_DIR)/etc --with-config-file-scan-dir=$(PHP_INSTALL_DIR)/etc \
		--enable-debug \
		--with-pcre-regex --with-openssl --with-pdo-mysql --with-gettext --with-gd --enable-sockets --with-xsl

php-install:
	php-install php $(PHP_VERSION) --install-dir $(PHP_INSTALL_DIR) -- \
		--with-config-file-path=$(INSTALL_DIR)/etc --with-config-file-scan-dir=$(PHP_INSTALL_DIR)/etc \
		--enable-debug \
		--with-pcre-regex --with-openssl --with-pdo-mysql --with-gettext --with-gd --enable-intl --enable-sockets --with-xsl

php-uninstall:
	rm -rf $(PHP_INSTALL_DIR)

php-configure: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php-configure:
	cp $(PHP_SRC_DIR)/php.ini-development $(PHP_INSTALL_DIR)/etc/php.ini

xdebug-pecl-install:
	source ~/.bashrc.d/chphp.sh && chphp $(PHP_VERSION) && pecl install xdebug

xdebug-pecl-enable: XDEBUG_SO=$(shell find $(PHP_INSTALL_DIR) -name 'xdebug.so' 2>/dev/null)
xdebug-pecl-enable:
	echo zend_extension="$(XDEBUG_SO)" > $(PHP_INSTALL_DIR)/etc/xdebug.ini

php-src-clean:
	rm -rf $(PHP_SRC_DIR)
