He optado por instalar el entorno virtual de desarrollo virualenv para Python, siguiendo las instrucciones de su [web](https://virtualenv.pypa.io/en/stable/installation/) he instalado la última versión liberada, 15.0.3, con el comando:

```shell
sudo pip3 install virtualenv
```

Si quisiéramos instalar otra versión, com por ejemplo la 14.0.6 no tendríamos más que modificar el comando anterior del siguiente modo:

```shell
sudo pip3 install virtualenv==14.0.6
```

No obstante esto haría que la versión actual de virtualenv que tuviésemos instalada (si la teníamos) se desinstale, para poder emplear varias versiones distintas de virtualenv lo que haremos será emplearlo de forma local tal y como se explica en la web. Para ello nos descargaremos el tar.gz de la versión que deseemos, por ejemplo, podemos descargar dicho fichero comprimido para la última versión de [aquí](https://pypi.python.org/pypi/virtualenv/15.0.3) y en una consola haríamos los siguiente, desde el directorio donde se encuentre el archivo descargado:

```shell
tar xvfz virtualenv-15.0.3.tar.gz
cd virtualenv-15.0.3/
python3 virtualenv.py myVE
```

esto creará (empleando esta versión de virualenv) el entorno virtual myVE pudiendo especificar otro nombre de archivo con otra ruta, por ejemplo ../myVE para en nuestro caso crear el entorno en la carpeta Descargas en lugar de la carpeta Descargas/virtualenv-15.0.3.


