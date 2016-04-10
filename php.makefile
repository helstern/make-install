SHELL=/bin/bash
PHP_INSTALL_ROOT=$(HOME)/.php_versions
SRC_ROOT=$(HOME)/src
PHP_SRC_ROOT=$(HOME)/src

php-install: PHPINSTALL_VERSION=0.0.4
php-install:
	wget -O php-install-$(PHPINSTALL_VERSION).tar.gz https://github.com/helstern/php-install/archive/v$(PHPINSTALL_VERSION).tar.gz
	tar -xzvf php-install-$(PHPINSTALL_VERSION).tar.gz
	cd php-install-$(PHPINSTALL_VERSION) && sudo $(MAKE) install
	rm -rf php-install-$(PHPINSTALL_VERSION)

chphp: CHPHP_VERSION=0.0.1
chphp:
	wget -O chphp-$(CHPHP_VERSION).tar.gz https://github.com/marcosdsanchez/chphp/archive/v$(CHPHP_VERSION).tar.gz
	tar -xzvf chphp-$(CHPHP_VERSION).tar.gz
	cd chphp-$(CHPHP_VERSION)/ && sudo $(MAKE) install
	rm -rf chphp-$(CHPHP_VERSION)
	@echo 'source /usr/local/share/chphp/chphp.sh' > ~/.bashrc.d/chphp.sh
	chmod +x ~/.bashrc.d/chphp.sh

php5.3: PHP_VERSION=5.3.29
php5.3: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php5.3: PHP_SRC_DIR=$(PHP_SRC_ROOT)/php-$(PHP_VERSION)
php5.3: php-uninstall php5.3-install php-configure intl-pecl-install intl-pecl-enable php-src-clean

php5.4: PHP_VERSION=5.4.25
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

php7: PHP_VERSION=7.0.5
php7: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php7: PHP_SRC_DIR=$(PHP_SRC_ROOT)/php-$(PHP_VERSION)
php7: php-uninstall php-install php-configure xdebug-pecl-install xdebug-pecl-enable php-src-clean

php5.3-install:
	php-install php $(PHP_VERSION) --install-dir $(PHP_INSTALL_DIR) -- \
		--with-config-file-path=$(PHP_INSTALL_DIR)/etc --with-config-file-scan-dir=$(PHP_INSTALL_DIR)/etc \
		--enable-debug \
		--enable-mbstring --enable-mbregex --enable-sockets --enable-pdo --enable-zend-multibyte --enable-gd-native-ttf --enable-exif \
		--enable-soap --enable-xmlreader --enable-ftp --enable-pcntl --enable-sysvsem --enable-sysvshm --enable-shmop \
		--with-pcre-regex --with-openssl --with-gettext --with-gd --with-xsl --with-readline \
		--with-mysql --with-pdo-mysql --with-pdo-pgsql --with-pdo-sqlite \
		--with-curlwrappers --with-jpeg-dir --with-png-dir --with-zlib --with-zlib-dir--with-gettext --with-kerberos --with-imap-ssl --with-iconv --with-pspell --with-xsl --with-curl --with-tidy --with-xmlrpc --with-readline

php-install:
	php-install php $(PHP_VERSION) --install-dir $(PHP_INSTALL_DIR) -- \
		--with-config-file-path=$(PHP_INSTALL_DIR)/etc --with-config-file-scan-dir=$(PHP_INSTALL_DIR)/etc \
		--enable-debug \
		--enable-mbstring --enable-intl --enable-sockets \
		--with-pcre-regex --with-openssl --with-pdo-mysql --with-gettext --with-gd --with-xsl \
		--with-readline

php-uninstall:
	rm -rf $(PHP_INSTALL_DIR)

php-configure: PHP_INSTALL_DIR=$(PHP_INSTALL_ROOT)/php-$(PHP_VERSION)
php-configure:
	cp $(PHP_SRC_DIR)/php.ini-development $(PHP_INSTALL_DIR)/etc/php.ini

intl-pecl-install:
	source ~/.bashrc.d/chphp.sh && chphp $(PHP_VERSION) && yes '' | pecl install intl
intl-pecl-enable:
	echo extension=intl.so > $(PHP_INSTALL_DIR)/etc/intl.ini


xdebug-pecl-install:
	source ~/.bashrc.d/chphp.sh && chphp $(PHP_VERSION) && pecl install xdebug

xdebug-pecl-enable: XDEBUG_SO=$(shell find $(PHP_INSTALL_DIR) -name 'xdebug.so' 2>/dev/null)
xdebug-pecl-enable:
	echo zend_extension="$(XDEBUG_SO)" > $(PHP_INSTALL_DIR)/etc/xdebug.ini

php-src-clean:
	rm -rf $(PHP_SRC_DIR)
