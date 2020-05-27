#!/usr/bin/env python3

## will need for putting a proper arg handler in front of it
import argparse
import os
import logging

## need this to actually talk to the XMLRPC library
import xmlrpc.client

from pathlib import Path

import yaml


## for now this is a brute force setup that pulls a set of configs from envvar and configures.

# XMLRPC api documented here: https://github.com/cobbler/cobbler/wiki/Cobbler-XMLRPC-API

## this just steals the security token used by cobbler's internal tools
## this will be used to authenticate locally to the service.

cobblerSystemToken = Path("/var/lib/cobbler/web.ss").read_text()

## these values should absolutely have checks in place to make sure they are set. They currently do not.
cobblerServer = os.environ["SERVICEHOSTNAME"]
cobblerPort = os.environ["CLIENTPORT"]
confpath = "/opt/import/"
distropath = confpath + "distros/"


class cobblerInterface:
    def __init__(self):
        self.cobblerConnection()

    def cobblerConnection(self):
        ## this just sets up the actual RPC connection so we can use this information in subsequent functions.
        serverURL = f"http://{cobblerServer}:{cobblerPort}/cobbler_api"
        self.serverHandle = xmlrpc.client.ServerProxy(serverURL)
        self.sToken = self.serverHandle.login("", cobblerSystemToken)
        # return (serverHandle, sToken)

    def add_distro(
        self, distroname, kernelfile="vmlinuz", initrdfile="initrd.img", tree=None
    ):
        distro_id = self.serverHandle.new_distro(self.sToken)

        self.serverHandle.modify_distro(distro_id, "name", distroname, self.sToken)

        self.serverHandle.modify_distro(
            distro_id,
            "kernel",
            os.path.join(f"{distropath}/{distroname}/{kernelfile}"),
            self.sToken,
        )
        self.serverHandle.modify_distro(
            distro_id,
            "initrd",
            os.path.join(f"{distropath}/{distroname}/{initrdfile}"),
            self.sToken,
        )

        # this should be repurposed to a more generic ksmeta input.
        if tree:
            self.serverHandle.modify_distro(
                distro_id, "ksmeta", os.path.join(f"tree={tree}"), self.sToken,
            )

        self.serverHandle.save_distro(distro_id, self.sToken)
        pass

    def add_host(self):
        pass


def main():

    cobble = cobblerInterface()
    cobble.add_distro(
        "sd7", tree="http://springdale.math.ias.edu/data/puias/7/x86_64/os/"
    )

    exit(0)


if __name__ == "__main__":
    main()
