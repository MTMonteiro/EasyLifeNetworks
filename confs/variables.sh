#!/bin/bash
# Initial information
#set -xv

VERSION="20151207"
LOGFILE="/var/log/eln.log"
ELNCONFDIR="/etc/EasyLifeNetworks"
ELNDIR="/usr/share/EasyLifeNetworks"


# [Linux]
OSNAME=`lsb_release -si`
OSVERSION=`lsb_release -sr | cut -d'.' -f1`


# [Network]
MACHINE=wifi # Machine name wifi
DOMAIN=uff.br # Domain name 
DOMAINWIFI=wifi.uff.br # Wifi Domain name
FQDN=$MACHINE'.'$DOMAIN # Machine name + . + Domain name
EXTINT=eth0 # External Interface
EXTIP=10.0.0.15 # External IP Address- last change (10.0.0.5)
EXTMASK=255.255.255.0 # External IP Mask-last change 255.255.255.0
EXTMASKB=`echo "obase=2;"${EXTMASK//./;} | bc | tr -d  '\n' | tr -dc '1\n' | awk '{ print length; }'` # External IP Mask bit format
INTINT=eth1 # Internal Interface
INTIP=192.168.122.230 # Interface IP Address
INTMASK=255.255.255.0 # Interface IP Mask
INTMASKB=`echo "obase=2;"${INTMASK//./;} | bc | tr -d  '\n' | tr -dc '1\n' | awk '{ print length; }'` # Internal IP Mask bit format
INTNET=`ipcalc $INTIP'/'$INTMASKB -n | cut -d'=' -f2`
#MONINT=eth2 # Monitoring interface
#MONIP=172.30.255.22 # Monitoring IP Address
#MONMASK=255.255.0.0 # Monitoring IP Mask
#MONMASKB=`echo "obase=2;"${MONMASK//./;} | bc | tr -d  '\n' | tr -dc '1\n' | awk '{ print length; }'` # Monitoring IP Mask bit format
NINTERFACES=2 # 2|3 - If 3 we ignore MONINT
DNSSERVER='75.75.75.75'
IGNAME=xfinity # Internet gateway name InternetGateway - Default Gateway name
IGIP=10.0.0.1 # Internet gateway IP - Default Gateway IP
REMOTEADMINPOINTS='192.168.122.1' # List of trustable machines for adminstrative purposes


# [NetDot]
NETDOTDB=Pg # Pg | mysql
NETDOTDBNAME=netdot # NetDot database name
NETDOTDBUSER=netdot_user # NetDot database user name
NETDOTDBPASSWD=123456 # NetDot database user password


# [PostgreSQL]
DBADMIN=postgres # PostgreSQL admin account. Think twice before change it.
DBADMINPASSWD=5102ltsoclazteuQ # PostgreSQL admin account password and also for database user "postgres". Use only alphanumeric characters and . and _. Must have 8 or + characters.


# [MariaDB]
MDBADMIN=root
MDBPASS=Batata


# [SNMPD]
SYSLOCATION='Data Center'
SNMPUSER=scifiroot
SNMPAUTH=SHA
SNMPPASSWD=scifiauthpass
SNMPPRIVPASSWD=scifiencpass
SNMPENCRYPTION=AES


# [LOG]
DURATION=104 # Weeks to retain logs. Two years.


# [LDAP]
LDAPSERVER=127.0.0.1 # LDAP server
#LDAPSERVER=ldap://127.0.0.1,ldap://200.200.200.200 # LDAP server
LDAPSUFIX='dc=uff,dc=br' # LDAP sufix
LDAPORG=`echo $LDAPSUFIX | cut -d',' -f1 | cut -d'=' -f2`
LDAPADMNAME='cn=Manager,'$LDAPSUFIX
LDAPADMPASSWD=Batatata # LDAP Administrator password

# Primary user
LDAPPRIMARYUID=cosmefc # LDAP UID
LDAPPRIMARYDISPLAYNAME='COSME FARIA CORREA' # LDAP CN. Must have two words at least
LDAPPRIMARYCN=`echo $LDAPPRIMARYDISPLAYNAME | cut -d' ' -f1`
LDAPPRIMARYFN=$LDAPPRIMARYCN # First Name
L=`echo $LDAPPRIMARYDISPLAYNAME | wc -w`
LDAPPRIMARYSN=`echo $LDAPPRIMARYDISPLAYNAME | cut -d' ' -f$L`
LDAPPRIMARYPASSWD=Beringela # LDAP primary user password
LDAPHASHPRIMARYPASS=$( slappasswd -h {CRYPT} -u -s $LDAPPRIMARYPASSWD )
LDAPHASHPRIMARYPASSNT=`printf $LDAPPRIMARYPASSWD | iconv -t utf16le | openssl md4 | cut -c10-`
LDAPPRIMARYUIDMAIL=$LDAPPRIMARYUID'@'$DOMAIN

# Secondary user
LDAPSECONDARYUID=johndoe # LDAP UID
LDAPSECONDARYDISPLAYNAME='JOHN DOE' # LDAP CN. Must have two words at least
LDAPSECONDARYCN=`echo $LDAPSECONDARYDISPLAYNAME | cut -d' ' -f1`
LDAPSECONDARYFN=$LDAPSECONDARYCN
L=`echo $LDAPSECONDARYDISPLAYNAME | wc -w`
LDAPSECONDARYSN=`echo $LDAPSECONDARYDISPLAYNAME | cut -d' ' -f$L`
LDAPSECONDARYPASSWD=Beringela # LDAP primary user password
LDAPHASHSECONDARYPASS=`slappasswd -h {CRYPT} -u -s $LDAPSECONDARYPASSWD`
LDAPHASHSECONDARYPASSNT=`printf $LDAPSECONDARYPASSWD | iconv -t utf16le | openssl md4 | cut -c10-`
LDAPSECONDARYUIDMAIL=$LDAPSECONDARYUID'@'$DOMAIN


# [OpenLDAP]
OLADMNAME='cn=Manager,'$LDAPSUFIX # OpenLDAP Administrator account
OLUSERBASEDNS='ou=People,'$LDAPSUFIX
OLGROUPBASEDNS='ou=Group,'$LDAPSUFIX
#OLGROUPOBJECTCLASS=posixgroup
#OLGROUPATTRIBUTE=memberuid
#OLGROUPSUSEMEMBEROF=false
OLGROUPOBJECTCLASS=groupofnames
OLGROUPATTRIBUTE=member
OLGROUPSUSEMEMBEROF=true


# [FreeIPA]
FIDMNAME='Directory Manager'
FIDMPASSWD=Mandioca # FreeIPA DM password
FIADMNAME='uid=admin,cn=users,cn=accounts,'$LDAPSUFIX # FreeIPA Administrator account
FIUSERBASEDNS='cn=users,cn=accounts,'$LDAPSUFIX
FIGROUPBASEDNS='cn=groups,cn=accounts,'$LDAPSUFIX
FIGROUPOBJECTCLASS=groupofnames
FIGROUPATTRIBUTE=member
FIGROUPSUSEMEMBEROF=true


# [Samba]
SAMBASID=S-1-5-21-1014769180-777746548-3660226278 # Samba SID
SAMBADOMAIN=WIFI # Samba Domain Name


# [Monitorix]
MONITORIXAUTH=y # MONITORIX authenticated - If you have to authenticate to see (y)es, (n)o or (g) you must belong a group
MONITORIXGROUP=NetAdmins # MONITORIX authenticated group


# [Radius]
RADIUSSERVER=127.0.0.1 # Radius server
RADIUSDOMAIN=uff.br # Radius domain
RADIUSACCOUNT='reader-radius' # Radius account - think twice before change
RADIUSACCPASS=Aspargos # Radius account password
RADIUSPASS=Taioba # Radius password for clients


# [RadSecProxy ]
# Get the file packet from rnp. It will be:
# - rnp-ca.crt
# - FQDN.crt - ex: wifi.uff.br.crt
# - FQDN.key - ex: wifi.uff.br.key
# - clients.conf
# - configura - Do not use it.
# - proxy.conf
# - radsecproxy.conf
# Put them in RadSecProxy/RNP directory


# [Shibboleth]
SHIBPASS=BeterrabaDoce # Shib password


# [SSHD]
SSHDAUTH=u # SSHD authenticated - If you have right to use (u)sers or (g)roup you must belong a group
SSHDGROUP=NetAdmins # SSHD authenticated group
SSHDUSERS='cosmefc' # users list with ssh right


# [Postfix]
RELAYHOST=mxrelay.uff.br
RELAYACC=manezinho
RELAYPASSWD=segredo


# [NTPD]
# Brazil's NTP Servers
NTPSERVERS="pool.ntp.br"
# To provide NTP internally. Comment both to disable them
NTPNETACCESS=$INTNET
NTPMASKACCESS=$INTMASK


# [Denyhosts]
LOCKTIME=4h # Deny Hosts lock time


# [Wiki]
WIKISITENAME='KnowledgeBase' # without spaces, please
WIKIDBSERVER='127.0.0.1'
WIKIDBNAME=wiki
WIKIDBUSER=wikiuser
WIKIDBPASS=Pitanga
WIKILANGUAGE='en' # or 'en' 'pt-br'
WIKILDAPLABEL='LDAPELN' 
WIKILDAPSERVER=$LDAPSERVER # or another machine


# [OTRS]
OTRSDBSERVER='127.0.0.1'
OTRSDBNAME=otrs
OTRSDBUSER=otrs
OTRSDBPASS=Pitanga
OTRSADMNAME=root@localhost	# Do not change
OTRSADMPASS=tQJL3DMY0DUxNziA	# Do not change
OTRSLANGUAGE='en' # or 'en' 'pt-br'
OTRSLDAPSERVER=$LDAPSERVER # or another machine


# [Certificates]
CERTCOUNTRY=BR
CERTSTATE='Rio de Janeiro'
CERTCITY='Niterói'
CERTORGANIZATION='UFF'


# [LogWatch]
LWACCOUNT=cosmefc@anywhere.com


# SCIFI
DIRELSCIFI=/usr/share/EasyLifeNetworks/ # Where ELSCIFI stay
ModDir=$DIRELSCIFI'modules/' # Where are modules
SCRIPTDIR=/usr/share/EasyLifeNetworks/scripts/ # Where are scripts
SCIFIVERION=12
SCIFISUBVERSION=0


# SCIFI Web Interface
SCIFIWEBUSERNAME='admin' # user name to access EasyLifeNetworks administrative web interface 
SCIFIWEBPASSWD='admin' # password to access EasyLifeNetworks administrative web interface 
SSLCERTIFICATEPASSWD='keystore' # keypass and keystore password for HTTPS certificate


# SCIFI Core
SCIFIPASSWD='sc1f1_206.' # password for linux user "EasyLifeNetworks".


# SCIFI Database
SCIFIDBPASSWD='EasyLifeNetworks' # password for default database user "EasyLifeNetworks". Use only alphanumeric characters and . and _.


# JBossAS
JBOSSPASSWD='JBAs_711.' # password for default user "jboss" to access jboss administrative interface and linux user "jboss".


# MRTG
MRTGAUTH=n # MRTG authenticated - If you have to authenticate to see (y)es, (n)o or (g) you must belong a group
MRTGGROUP=NetAdmins # MRTG authenticated group


# NAGIOS
NAGIOSAUTH=g # NAGIOS authenticated - If you have to authenticate to see (y)es or (g) you must belong a group
NAGIOSGROUP=NetAdmins # NAGIOS authenticated group
