#! /bin/bash

## this is a wrapper script that has a few jobs:
# * import kickstart files and kickstart snippets
# * execute the importer script for yaml based configuration.
##
# Future work:
# * add envsub handling so that in place replacements can be performed if need be may be easier to do globally than using ksmeta.

import_kickstart() {
mkdir /var/lib/cobbler/kickstarts
cp -v /opt/import/kickstart/* /var/lib/cobbler/kickstarts/
#cp -v /opt/import/kickstart/* /var/lib/cobbler/templates/
}

import_kickstart_snippets() {
cp -v /opt/import/kickstart-snippets/* /var/lib/cobbler/snippets/
}

import_yamlconfigs() {
  ## just run the python script.
  /opt/cobblerimporter/base.py
}

_main() {
sleep 5
import_kickstart
import_kickstart_snippets
import_yamlconfigs

#cobbler get-loaders

cobbler mkloaders

cobbler sync

exit 0

}

_main
