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
