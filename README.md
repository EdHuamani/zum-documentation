# zum-despliegue en los diferentes ambientes

* Manual de despliegue QA-UAT-Producción
* Manual de creación/preparación de instancias (considerar back-up de BD)
* SCP entre servidores Amazon
* Sugerencias de escalamiento

### Manual de despliegue QA-UAT-Producción


Pasos para conectarse al servidor por ssh
```sh
$ ssh -i key.pem ubuntu@200.120.02.01
```

Pasos para deployar la aplicación zum
```sh
$ cd /www/zum
$ git pull origin master
$ mvn clean
$ mvn install
$ mvn cp target/zum.war /opt/wildfly/standalone/deployments
```

Levantar el servidor de aplicaciones Wildfly 10:
nota:
```sh
$ cd /opt/wildfly/bin/
$ sh standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djboss.http.port=80&
```

nota:
para correr la aplicación para https reemplazar -Djboss.http.port=80 con -Djboss.https.port=443 debe quedar de la siguiente manera
```sh
$ cd /opt/wildfly/bin/
$ sh standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 -Dsun.jnu.encoding=UTF-8 -Dfile.encoding=UTF-8 -Djboss.https.port=443&
```

Comando para ver el log de la aplicación en tiempo real
nota: 
el parámetro -n significa la cantidad de líneas que se desea ver
```sh
$ tail -f /opt/wildfly/standalone/log/server.log -n 200
```

#### Opcional autodeploy con script

Existe un script en la raíz del servidor o descargar el archivo [zumdeploy.sh](https://github.com/ragdexD/zum-documentation/blob/master/zumdeploy.sh)

Nota: necesita permisos de escritura
```sh
$ cd
$ sh zumdeploy.sh
$ Compile zum project? [Y/N]: yes
```


### Manual de creación/preparación de instancias (considerar back-up de BD)

Revisar la [documentación de aws](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) para mas detalles.
Sobre el manejo de instancias RDS & backups de bases de datos revisar la [documentación de aws](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateInstance.html)
Programar backups en aws RDS revisar [documentación de aws](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.BackingUpAndRestoringAmazonRDSInstances.html)

#### Obtener backups de forma manual

nota: se tiene que instalar el cliente psql compatible con la versión del servidor actualmente es postgresql 9.5

```sh
$ pg_dump --host zumproject.ccrpyctfqs9v.us-east-1.rds.amazonaws.com --port 5432 --username "zum" --format custom --blobs --verbose --file "/home/ubuntu/bdzum_marsh_zumseguros.backup" "bdzum_marsh_zumseguros"
```

Levantar backup en una bd nueva:

```sh
$ pg_restore --host zumproject.ccrpyctfqs9v.us-east-1.rds.amazonaws.com --port 5432 --username "zum" -d bdzum_marsh_zumseguros "/www/ubuntu/bdzum_qa_zumseguros.backup"
```

### Copiar archivos entre servidores Amazon

Para mayor detalle de puede ver en el siguiente [link](https://es.wikipedia.org/wiki/Secure_Copy)

Copiando un archivo zip a otro servidor vía scp

nota: la carpeta que tiene permisos para ser transportados y/o recuperados vía scp solo es /home/ubuntu
```sh
$ scp -i key.pem bd_qa_zumseguros.zip ubuntu@20.200.2.16:/home/ubuntu
```

Descargando un archivo desde un servidor vía scp
```sh
$ scp -i key.pem ubuntu@20.200.2.16:/home/ubuntu/bd_qa_zumseguros.zip /path/local/
```

### Compilar estilos (sass)
nota: en el archivo ./src/main/webapp/resources/v3/scss/colors.scss existe una sección para marsh (azul) y zum (rojo) se tiene que comentar una de las paletas para no tener error antes de compilar.

La compilación es de la siguiente manera:
```sh
$ cd cd /www/zum
$ sass --update src/main/webapp/resources/v3/scss/styles.scss:src/main/webapp/resources/css/canalventa/stylenew.css
```

### Sugerencias de escalamiento
Se puede consultar mas detalles sobre este tema en la [documentación de aws](http://docs.aws.amazon.com/autoscaling/latest/userguide/autoscaling-load-balancer.html)

Tutorial:
http://docs.aws.amazon.com/autoscaling/latest/userguide/as-register-lbs-with-asg.html


