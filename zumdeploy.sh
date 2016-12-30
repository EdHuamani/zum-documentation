#! /bin/bash
echo "stop wildfly.. .";
pkill -f standalone -9

f="zum.*"
to="/opt/wildfly/standalone/deployments/"
p="/www/zum"
of="/www/zum/target/"
server="/opt/wildfly/bin/"

echo -n "Compile zum project? [Y/N]: "
read yno
case $yno in

        [yY] | [yY][Ee][Ss] )
		echo "Compiling"
		# using clean and install maven
		cd $p
		git pull
		mvn clean
		#-Djavax.xml.accessExternalSchema=all using compile with jdk8
		mvn package -Djavax.xml.accessExternalSchema=all
		# end compile
                ;;

        [nN] | [n|N][O|o] )
                echo "Deploying.. .";
#                exit 1
                ;;
        *) echo "Continue"
            ;;
esac

	now=$(date +"%H:%M:%S")
	cd $to;
	rm -rf $f;
	cd $of;
	cp $f $to;

	red=`tput setaf 1`
	green=`tput setaf 2`
	reset=`tput sgr0`
	echo "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t ${red}deploy ${green} $now ${reset}"

#tail -f /opt/wildfly/standalone/log/server.log
echo "start wildfly.. .";
cd $server;
sh standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djboss.http.port=80 -Djboss.https.port=443&
