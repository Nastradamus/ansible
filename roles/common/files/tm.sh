#!/bin/bash

systemctl stop avahi-daemon || true
systemctl stop netatalk || true

# Install Time Machine service on CentOS 7
# https://koji.fedoraproject.org/koji/buildinfo?buildID=1403661
# http://confoundedtech.blogspot.com/2011/07/draft-draft-ubuntu-as-apple-time.html
yum install -y rpm-build gcc make wget

yum install -y  perl-IO-Socket-INET6 perl-generators

# install netatalk
yum install -y avahi-devel cracklib-devel dbus-devel dbus-glib-devel libacl-devel libattr-devel libdb-devel libevent-devel libgcrypt-devel krb5-devel mysql-devel openldap-devel openssl-devel pam-devel quota-devel systemtap-sdt-devel tcp_wrappers-devel libtdb-devel tracker-devel

yum install -y bison docbook-style-xsl flex dconf

wget https://kojipkgs.fedoraproject.org//packages/netatalk/3.1.12/10.el7/src/netatalk-3.1.12-10.el7.src.rpm

rpm -ivh netatalk-3.1.12-10.el7.src.rpm

rpmbuild -bb ~/rpmbuild/SPECS/netatalk.spec

rpm -ivh ~/rpmbuild/RPMS/x86_64/netatalk-3.1.12-10.el7.x86_64.rpm

# configuration
cat > /etc/avahi/services/afpd.service << EOF
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
<name replace-wildcards="yes">%h</name>
<service>
<type>_afpovertcp._tcp</type>
<port>548</port>
</service>
<service>
<type>_device-info._tcp</type>
<port>0</port>
<txt-record>model=Xserve</txt-record>
</service>
</service-group>
EOF

cat > /etc/netatalk/afp.conf << EOF
[Global]

[Time Machine]
path = /mnt/mailcloud
valid users = vryagofarov
time machine = yes
EOF

cat > /etc/netatalk/afpd.conf << EOF
- -transall -uamlist uams_randnum.so,uams_dhx.so,uams_dhx2.so -nosavepassword -advertise_ssh
EOF

mkdir /mnt/mailcloud || true
chown vryagofarov:vryagofarov /mnt/mailcloud

cat > /etc/netatalk/AppleVolumes.default << EOF
/mnt/mailcloud TimeMachine allow:vryagofarov options:usedots,upriv,tm dperm:0775 fperm:0660 cnidscheme:dbd volsizelimit:200000

EOF


cat >> /etc/nsswitch.conf << EOF
hosts:  files mdns4_minimal dns mdns mdns4
EOF

# firewall-cmd --zone=public --permanent --add-port=548/tcp
# firewall-cmd --zone=public --permanent --add-port=548/udp
# firewall-cmd --zone=public --permanent --add-port=5353/tcp
# firewall-cmd --zone=public --permanent --add-port=5353/udp
# firewall-cmd --zone=public --permanent --add-port=49152/tcp
# firewall-cmd --zone=public --permanent --add-port=49152/udp
# firewall-cmd --zone=public --permanent --add-port=52883/tcp
# firewall-cmd --zone=public --permanent --add-port=52883/udp
# firewall-cmd --reload

systemctl enable avahi-daemon
systemctl enable netatalk
systemctl start avahi-daemon
systemctl start netatalk

