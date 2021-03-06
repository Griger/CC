# NameIT

![licencia](https://img.shields.io/badge/license-GPL%203.0-blue.svg)

Proyecto para la asignatura de Cloud Computing del Máster Universitario en Ingeniería Informática por la Universidad de Granada (**UGR**).

Este proyecto pretende ser una plataforma para realizar experimentos realizados con la investigación en Generación de Lenguaje Natural (GLN). Durante el desarrollo de mi TFG he tenido que leer varios papers relacionados con el estudio del lenguaje natural, en particular mi TFG se centraba en la generación de expresiones de referencia para una objeto dentro de una escena, es decir, generar una descripción que identifique unívocamente a un objeto dentro de una escena.

En muchos de estos artículos se empleaba alguna plataforma en la que se le presentaba a varios usuarios distintas imágenes que ellos tenían que describir a fin de obtener información sobre cómo nos expresamos los seres humanos, y en particular cómo describimos los objetos. También se realizan este tipo de experimentos para por ejemplo ver cómo llama cada cuál a un determinado color que se le muestra o una textura concreta. Hasta donde yo conozco en cada experimento cada cual establece su plataforma para poder realizar esta experimentación, ya sea a través de una aplicación online o de forma presencial. NameIT pretende ser una plataforma en la cual los usuarios puedan alojar una batería de imágenes que se le presentarán a todos aquellos que accedan al experimento, donde se le formulará una pregunta común a todas las preguntas ("¿Qué color es este?") o una pregunta asociada a cada foto. En definitiva se pretende construir una plataforma de experimentación.

## Funcionamiento

La aplicación será muy sencilla, tras haberse dado de alta en NameIT se podrá acceder a crear un nuevo experimento. En este nuevo experimento añadiremos las imágenes que se desean para el mismo, subiéndolas a la plataforma, así como la pregunta o preguntas asociadas a las mismas. Entonces se creará una sitio para tal experimento (que se estudiará la opción de poder ser privado a fin de controlar el grupo que realiza el experimento, o añadir algún código de acceso al mismo) al que accederán distintas personas, que no han de estar dados de alta en la plataforma y realizarán el experimento que se les presente. Los resultados de los experimentos se podrán a disposición de los usuarios que han creado el experimento.

Además se incluirá una componente de red social en esta aplicación, de modo que otros investigadores puedan seguir el trabajo de otros y ponerse en contacto con ellos, a fin de crear una red de investigación en la generación de lenguaje natural lo suficientemente rica. Así se podrá solicitar "amistad" a otro usuario de la plataforma para estar informado sobre los experimentos que realiza y acceder a otro tipo de información.

## Infraestructura virtual

Esta aplicación se estructurará con un arquitectura basada en microservicios ya que me parece una arquitectura tremendamente flexible y de relativa facilidad de implementación. Además es de la infraestructura de la que tengo mayor información y me parece muy útil y adecuada para este proyecto, porque el modo en el que está pensada la aplicación es muy modular, que es, al fin y al cabo, como estamos acostumbrados a pensar a la hora de programar aplicaciones monolíticas.

Los servicios que se incorporarán a esta aplicación serían:

- Base da datos de tipo documental, **MongoDB**, donde se almacenarán las imágenes y otros tipos de información relacionada con la plataforma. Este tipo de base de datos nos da una gran escalabilidad, alta disponibilidad y un buen rendimiento.
- A fin de manejar de la mejor forma posible la información relativa al componente de red social de esta aplicación y conocer este tipo de bases de datos se empleará una base de datos basada en grafos, **Neo4j**.
- Se incorporará un servicio de **log** para obtener información sobre el funcionamiento y uso de la aplicación.
- El núcleo de la arquitectura estará implementado en Python empleando el framework web **Flask** que es más ligero y en ofrece toda la funcionalidad necesaria para llevar a cabo esta aplicación. Aquí se centraría la interfaz de usuario.
- Servicio de **login de usuario**.
- Aquellos **módulos necesarios para la gestión de usuarios y red social** que se podrían agrupar en un servicio.
- Aquellos **módulos necesarios para la creación y gestión de experimentos** que lo podríamos agrupar en otro.

Una documentación más extensa de este proyecto puede encontrarse en el [sitio web del proyecto](https://griger.github.io/CC/).

Además en el respositorio de [ejercicios](https://github.com/Griger/Ejercicios-CC) de este proyecto podemos encontrar algunos ejercicios adicionales de la asignatura: hasta ejercicio 2 del tema 1.

##Provisionamiento

El provisionamiento se ha realizado a través del sistema de orquestación de máquinas virtuales **Vagrant**, con lo cual lo que tendremos que hacer en primer lugar será gestionar la máquina virtual que queramos provisionar mediante este gestor. Esto, si seguimos los tutoriales básicos de Vagrant que hay [en la misma web de la herramienta](https://www.vagrantup.com/docs/getting-started/), nos creará un fichero *Vagrantfile*, en el directorio que elijamos, en el que añadiremos las directivas necesarias para realizar el provisionamiento. Este provisionamiento se puede hacer empleando cualquier tipo de máquina virtual, desde una creada en VirtualBox, que son las que tendremos si realizamos los primeros pasos que se nos muestran en la guía de la web de Vagrant, hasta máquina virtuales en AWS que son las que se han empleado en el provisionamiento con Ansible.

Así para realizar el provisionamiento con Ansible, lo que se aconseja debido a su versatilidad y comodidad, lo que haremos es añadir el [playbook](provision/Ansible/playbook.yml) de ansible en el mismo directorio donde esté el *Vagrantfile* y añadir al *Vagrantfile* la siguiente directiva de provisionamiento (se ha de instalar ansible en la máquina local en la que estemos trabajando; en el caso de trabajar con Arch el comando para realizar tal acción sería `pacman -S ansible`):

```bash
config.vm.provision :ansible do |ansible|
  ansible.playbook = "playbook.yml"
end
```

Por otro lado, para realizar el provisionamiento con chef, aunque no se aconseja ya que puede resultar más complejo, lo que haremos es copiar el directorio [cookbooks](provision/Chef/cookbooks) en el mismo directorio donde se encuentre el *Vagrantfile* y añadir al *Vagrantfile* la siguiente directiva de provisionamiento:

```bash
config.vm.provision "chef_solo" do |chef|
  chef.add_recipe "provision"
end
```
También hemos de asegurarnos de cambiar en [la receta chef](provision/Chef/cookbooks/recipes/default.rb) el path para el directorio que se creará con la directiva `directory`, ya que este caso la ruta depende de la máquina en la que estemos trabajando.

Además hemos de asegurarnos antes de que en la máquina remota esté disponible `chef solo` que lo podemos instalar con el siguiente comando `curl -L https://www.opscode.com/chef/install.sh | bash` desde el directorio home. [Aquí](https://griger.github.io/CC/documentos/provisionamiento) podemos ver unas pruebas de funcionamiento de estos provisionamientos.

Por último hemos de asegurarnos de que podamos sincronizar ficheros que haya en nuestro ordeandor con la instancia AWS, para ello instalaremos el paquete `rsync` en nuestro ordeandor y añadiremos la siguente línea al *Vagrantfile*:

```bash
config.vm.synced_folder ".", "/vagrant", disabled: true, type: "rsync"
```
## Orquestación

Para poder configurar automáticamente toda la topología de máquinas virtuales en la que desplegaremos nuestro proyecto necesitaremos instalar en nuestra máquina local tango **vagrant** como **virtualbox** además de disponer de una cuenta en [AWS](https://aws.amazon.com/es/?nc2=h_lg).

Una vez añamos tengamos creada dicha cuenta necesitaremos crear un usuario así como un grupo de seguridad, para lo cual se proporciona un [tutorial](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html) en la misma web de AWS. Con este tutorial craremos un usuario, lo añadiremos a un grupo también creado en el que se le dan los privilegios necesarios para operar sobre las instancias que creemos en AWS y crearemos también una par de claves para poder conectar, a través de conexión SSH, a las instancias desde nuestra máquina.

También crearemos un grupo de seguridad con este tutorial, este grupo es el que le asociaremos a las distintas máquinas que creemos y controlará los permisos de entrada y salida que tienen las máquinas asociadas a él. Para poder conectarnos a nuestras máquinas he creado un grupo al que le he dado los siguientes permisos:

![Permisos del grupo de seguridad](img/permisosGrupo.png)

Luego en el directorio que prefiramos crearemos un archivo que podemos llamar por ejemplo *aws-credentials* con el siguiente contenido:

```bash
export AWS_KEY='access key ID del usuario creado'
export AWS_SECRET='secret access key de nuestro usuario creado'
export AWS_KEYNAME='el nombre del archivo con la clave ssh creada sin extensión'
export AWS_KEYPATH='path al archivo .pem que hemos bajado con la clave ssh creada'
```
Podemos acceder a acces key ID y a la secret acces key siguiendo un [tutorial](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html) de AWS. Una vez tengamos este archivo creado, copiaremos los archivos del [directorio orquestación](https://github.com/Griger/CC/tree/master/orquestacion) de este repositorio en el mismo directorio donde hemos creado el archivo anterior. Entonces en el archivo *Vagrantfile* modificaremos el grupo al que asociamos las dos instancias de AWS que se crean, cambiando el valor del parámetro `aws.security_groups` por el nombre del grupo que hemos creado nosotros (líneas 26 y 53 del *Vagrantfile*) y también cambiaremos la región dónde se crearán las máquinas por aquella en la que hayamos creado las claves SSH (líneas 24 y 51). Entonces desde el directorio donde hemos copiado estos archivos, ejecutaremos las siguientes órdenes de consola:

```bash
source aws-credentials
vagrant up
```
esto creará y provisionará con los playbooks de Ansible correspondientes las tres máquinas que conforman la topología de red definida en el *Vagrantfile* (local, ppal y data). Para ver algunos detalles de la topología configurada y capturas de funcionamiento ir [aquí](https://griger.github.io/CC/).

##Contenedores

Ya hemos visto anteriormente la red de máquinas que queremos definir para desplegar nuestra aplicación, así como el provisionamiento que realizamos sobre cada una de ellas. Lo que hemos hecho ahora es traducir esta arquitectura a 3 imágenes Docker que nos permitirán definir los contenedores Docker necesarios para nuestro despligue, provisionando tales imágenes haciendo uso de los [dockerfiles](https://github.com/Griger/CC/tree/master/dockerfiles) correspondientes. Así tenemos las siguientes imágenes subidas a Docker Hub:

* [Local](https://hub.docker.com/r/griger/maquinalocal/)
* [Principal](https://hub.docker.com/r/griger/maquinappal/)
* [Data](https://hub.docker.com/r/griger/maquinadata/)

Podemos descarga cada imagen empleando el comando pull que se expecifica en la propia página de la imagen, no obstante se proporciona un [script](https://github.com/Griger/CC/blob/master/dockerfiles/scriptDescargayCracion.sh) que descargará las 3 imágenes y creará sendos contenedores a partir de ellas.

Para más detalles ir [aquí](https://griger.github.io/CC/documentos/contenedores).

##Despliegue Final

Para el despliegue final de esta asignatura hemos hecho uso de las siguientes herramientas:

* **Ansible** como sistema de provisionamiento.
* **Vagrant** como sistema de orquestación.
* **AWS** para desplegar máquinas virtuales.
* **Docker** como sistema de contenedores para empaquetar los paquetes necesarios para ejecutar la aplicación.
* **mlab** como DaaS.
* **Sematext** como servicio de log.

Para ver detalles sobre las decisiones tomadas en este diseño ir [aquí](https://griger.github.io/CC/documentos/despliegue).
