# make-install
collection of makefiles used for various software installs

# install php

1 install php-install tool which does the heavy lifting of the install
   
    make -f php.makefile php-install

2 optional (but recommended), install chphp tool which allows you to switch between different versions of php
   
    make -f php.makefile chphp
    
3 install a php version by specifing a a version,  for example the latest one
   
    make -f php.makefile php7
    
4 optional, if you have installed chphp in step 2 help it pick up the change by restarting the terminal or running
   
    source ~/.bashrc.d/chphp.sh
    

