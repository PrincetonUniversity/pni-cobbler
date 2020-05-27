
## cobbler distro setup:
```bash
1  bash /opt/import/quickstart-cobbler.sh
2  cobbler sync
3  cobbler sync
4  ls /var/lib/tftpboot/
5  ls /var/lib/tftpboot/grub/
6  cd /var/lib/tftpboot/
7  ls
8  ls images
9  cat hello.txt
10  ls grub/
11  ls
12  cobbler profile list
13  cobbler profile report Centos7Base
14  cat /var/lib/cobbler/kickstarts/default.ks
15  ls /var/lib/cobbler/kickstarts/
16  ls /var/lib/cobbler/kickstarts/default.ks
17  cat /var/lib/cobbler/kickstarts/default.ks
18  cat /var/lib/cobbler/kickstarts/sample.ks
19  cat /var/lib/cobbler/kickstarts/sample_end.ks
20  cobbler profile edit --name=Centos7Base --kickstart=/var/lib/cobbler/sample_end.ks
21  cobbler profile edit --name=Centos7Base --kickstart=sample_end.ks
22  ls /var/lib/cobbler/
23  ls /var/lib/cobbler/kickstarts/
24  cobbler profile edit --name=Centos7Base --kickstart=/var/lib/cobbler/kickstarts/sample_end.ks
25  cobbler sync
26  cobbler system edit --name=asuslaptop --profile=Centos7-x86_64
27  cobbler sync
28  cd /opt/import/
29  ls
30  cd centos7/
31  ls
32  ls EFI/
33  ls EFI/BOOT/
34  cd ../springdale7/
35  ls
36  cobbler import --path=./ --name=sd7
37  cobbler distro report
38  cobbler signature update
39  cobbler import --path=./ --name=sd7
40  cobbler signature report
41  cobbler import -h
42  cobbler import --path=./ --name=sd7 --breed=rhel7
43  ls /var/www/cobbler/ks_mirror/
44  ls /var/www/cobbler/ks_mirror/sd7/
45  cobbler distro list
46  cobbler distro report
47  cobbler profile report
48  rm -frv /var/www/cobbler/ks_mirror/sd7
49  cobbler import --path=./ --name=sd7 --breed=rhel7
50  ls
51  cd isolinux/
52  ls
53  cobbler distro add --name=SD7 --kernel=./vmlinuz --initrd=./initrd.img
54  cobbler distro report
55  ls
56  cd ..
57  ls EFI/BOOT/
58  ls
59  ls LiveOS/
60  ls isolinux/
61  cobbler distro add --name=SD7 --kernel=./isolinux/vmlinuz --initrd=./isolinux/initrd.img
62  cd isolinux/
63  ls -ltha
64  pwd
65  cobbler distro add --name=SD7 --kernel=$PWD/vmlinuz --initrd=$PWD/initrd.img
66  cobbler profile list
67  cobbler distro list
68  cobbler profile rm Centos7Base
69  cobbler profile remove Centos7Base
70  cobbler profile remove --name=Centos7Base
71  cobbler profile add --distro=SD7 --name=SD7base
72  cobbler system edit --name=asuslaptop --profile=SD7base
73  cobbler sync
74  cobbler profile report
75  cobbler profile report
76  cobbler distro report
77  cobbler distro edit --name=SD7 --ksmeta="tree=http://springdale.math.ias.edu/data/puias/7/x86_64/os/"
78  cobbler sync
79  cobbler distro report
80  cobbler distro edit --name=SD7 --ksmeta="tree=http://springdale.math.ias.edu/data/puias/7/x86_64/"
81  cobbler sync
82  cobbler distro report
83  cobbler distro edit --name=SD7 --kickstart=sample_end.ks
84  cobbler profile report
85  cobbler profile edit --name=SD7base --kickstart=/var/lib/cobbler/kickstarts/sample_end.ks
86  cobbler sync
87  cobbler distro edit --name=SD7 --ksmeta="tree=http://springdale.math.ias.edu/data/puias/7/x86_64/os"
88  cobbler sync
89  cd ../../
90  ls
91  cd sd7-pxe/
92  ls
93  cobbler distro add --name=SD7 --kernel=$PWD/vmlinuz --initrd=$PWD/initrd.img
94  cobbler distro add --name=SD7pxe --kernel=$PWD/vmlinuz --initrd=$PWD/initrd.img
95  cobbler profile edit --name=SD7base --distro=SD7pxe
96  cobbler sync
97  cobbler distro edit --name=SD7pxe --ksmeta="tree=http://springdale.math.ias.edu/data/puias/7/x86_64/os"
98  cobbler sync
```

## XML RPC Access via python
```bash
[root@10 /]# python
Python 2.7.5 (default, Apr  2 2020, 13:16:51)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> exit()
[root@10 /]# python3
Python 3.6.8 (default, Apr  2 2020, 13:34:55)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import xmlrpclib
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ModuleNotFoundError: No module named 'xmlrpclib'
>>> exit()
[root@10 /]# pip
pip3     pip-3    pip-3.6  pip3.6   
[root@10 /]# pip3 install xmlrpclib
WARNING: Running pip install with root privileges is generally not a good idea. Try `pip3 install --user` instead.
Collecting xmlrpclib
  Could not find a version that satisfies the requirement xmlrpclib (from versions: )
No matching distribution found for xmlrpclib
[root@10 /]# python3
Python 3.6.8 (default, Apr  2 2020, 13:34:55)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import xmlrpc
>>> server = xmlrpc.server("http://10.140.0.101:9000/cobbler_api")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: module 'xmlrpc' has no attribute 'server'
>>> server = xmlrpc.Server("http://10.140.0.101:9000/cobbler_api")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: module 'xmlrpc' has no attribute 'Server'
>>> server = xmlrpc.client.ServerProxy("http://10.140.0.101:9000/cobbler_api")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: module 'xmlrpc' has no attribute 'client'
>>> server = client.ServerProxy("http://10.140.0.101:9000/cobbler_api")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'client' is not defined
>>> server = xmlrpc.Server("http://10.140.0.101:9000/cobbler_api")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: module 'xmlrpc' has no attribute 'Server'
>>> import xmlrpc.client
>>> server = xmlrpc.client.ServerProxy("http://10.140.0.101:9000/cobbler_api")
>>> ss = read('/var/lib/cobbler/web.ss')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'read' is not defined
>>> from pathlib import Path
>>> token = Path('/var/lib/cobbler/web.ss').read_text()
>>> print(token)
xxxxxxxxxxxx
>>> shandle = server.login('',token)
>>> distro_id = server.new_distro(shandle)
>>> print(distro_id)
___NEW___distro::TAmAJCctODskqJm7nXAVAEZXcto2lDTc8Q==
>>> server.modify_distro(distro_id, 'name', 'sd7', shandle)
True
>>> server.modify_distro(distro_id, 'kernel', '/opt/import/isos/sd7-pxe/vmlinuz', shandle)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/lib64/python3.6/xmlrpc/client.py", line 1112, in __call__
    return self.__send(self.__name, args)
  File "/usr/lib64/python3.6/xmlrpc/client.py", line 1452, in __request
    verbose=self.__verbose
  File "/usr/lib64/python3.6/xmlrpc/client.py", line 1154, in request
    return self.single_request(host, handler, request_body, verbose)
  File "/usr/lib64/python3.6/xmlrpc/client.py", line 1170, in single_request
    return self.parse_response(resp)
  File "/usr/lib64/python3.6/xmlrpc/client.py", line 1342, in parse_response
    return u.close()
  File "/usr/lib64/python3.6/xmlrpc/client.py", line 656, in close
    raise Fault(**self._stack[0])
xmlrpc.client.Fault: <Fault 1: "<class 'cobbler.cexceptions.CX'>:'kernel not found: /opt/import/isos/sd7-pxe/vmlinuz'">
>>> server.modify_distro(distro_id, 'kernel', '/opt/import/sd7-pxe/vmlinuz', shandle)
True
>>> server.modify_distro(distro_id, 'initrd', '/opt/import/sd7-pxe/initrd.img', shandle)
True
>>> server.save_distro(distro_id,shandle)
True
```
