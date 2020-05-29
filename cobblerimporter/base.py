#!/usr/bin/env python3

## will need for putting a proper arg handler in front of it
import argparse
import os
import logging

## need this to actually talk to the XMLRPC library
import xmlrpc.client

from pathlib import Path

import bios

return_codes = {"no_profiles_found": 1, "no_distro_files_found": 2}

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

    def add_distro(self, dPath, distro_data):
        distro_id = self.serverHandle.new_distro(self.sToken)

        self.serverHandle.modify_distro(
            distro_id, "name", distro_data["name"], self.sToken
        )

        self.serverHandle.modify_distro(
            distro_id,
            "kernel",
            os.path.join(f"{dPath}/{distro_data['kernel']}"),
            self.sToken,
        )
        self.serverHandle.modify_distro(
            distro_id,
            "initrd",
            os.path.join(f"{dPath}/{distro_data['initrd']}"),
            self.sToken,
        )

        # this should be repurposed to a more generic ksmeta input.
        if distro_data["ksmeta"]:
            ksmeta = " ".join(
                [f"{key}={value}" for key, value in distro_data["ksmeta"].items()]
            )
            logging.debug(f"distro ksmeta: {ksmeta}")
            self.serverHandle.modify_distro(
                distro_id, "ksmeta", os.path.join(ksmeta), self.sToken,
            )

        self.serverHandle.save_distro(distro_id, self.sToken)
        pass

    def add_host(self):
        pass

    def add_profile(self, pDict):
        profile_id = self.serverHandle.new_profile(self.sToken)
        self.serverHandle.modify_profile(profile_id, "name", pDict["name"], self.sToken)
        self.serverHandle.modify_profile(
            profile_id, "distro", pDict["distro"], self.sToken
        )
        self.serverHandle.modify_profile(
            profile_id, "kickstart", pDict["kickstart"], self.sToken
        )
        self.serverHandle.save_profile(profile_id, self.sToken)

    def sync(self):
        self.serverHandle.sync(self.sToken)


def main():

    logging.basicConfig(format="%(asctime)s %(message)s", level=logging.DEBUG)

    ## look in opt/import or wherever confs are stored for a set of subdirectories to use for import.
    distrodirs = [f.path for f in os.scandir(distropath) if f.is_dir()]
    logging.debug(f"distro directories: {distrodirs}")

    cobble = cobblerInterface()

    ## if yaml file exists import.
    distro_count = 0  ## this is a check
    for dPath in distrodirs:
        # dPath = os.path.join(f"/{distro}/")
        dFile = os.path.join(f"{dPath}/distro.yaml")

        if os.path.isfile(dFile):
            logging.debug(f"Adding Distro From: {dPath}")
            distro_doc = bios.read(dFile)

            logging.debug(f"Distro Data: {distro_doc}")
            cobble.add_distro(dPath=dPath, distro_data=distro_doc)
            distro_count += 1
        else:
            logging.debug(f"No distro file found in {dPath}")

    if distro_count == 0:
        exit(return_codes["no_distro_files_found"])

    profiles_file = f"{confpath}/profiles.yaml"

    if os.path.isfile(profiles_file):
        logging.debug(f"profiles file {profiles_file} located. loading...")
        profiles = bios.read(profiles_file)
        logging.debug(f"Profiles: {profiles}")
        for label, prof in profiles.items():
            logging.debug(f"adding profile {label}")
            cobble.add_profile(prof)
    else:
        logging.error("no profiles found, can not proceed. exiting.")
        exit(return_codes["no_profiles_found"])

    cobble.sync()

    exit(0)


if __name__ == "__main__":
    main()
