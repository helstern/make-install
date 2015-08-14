SHELL=/bin/bash
APPENGINE_INSTALL_ROOT=$(HOME)/.appengine
APPENGINE_JAVA_SDK=appengine-java-sdk-1.9.25

uninstall-java-sdk:
	rm -rf $(APPENGINE_INSTALL_ROOT)/$(APPENGINE_JAVA_SDK)

install-java-sdk:
	mkdir --parent $(APPENGINE_INSTALL_ROOT)
	wget --directory-prefix $(APPENGINE_INSTALL_ROOT) https://storage.googleapis.com/appengine-sdks/featured/$(APPENGINE_JAVA_SDK).zip
	unzip -d $(APPENGINE_INSTALL_ROOT) -- $(APPENGINE_INSTALL_ROOT)/$(APPENGINE_JAVA_SDK).zip
	rm $(APPENGINE_INSTALL_ROOT)/$(APPENGINE_JAVA_SDK).zip

path-java-sdk:
	echo $(APPENGINE_INSTALL_ROOT)/$(APPENGINE_JAVA_SDK)/bin/





