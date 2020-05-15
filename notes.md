
## cobbler distro setup:
```
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
