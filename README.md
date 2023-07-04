README

Segunda practica del experto en DevOps:

TERRAFORM

1. inicializacion con el comando
      
        Terraform init
   
desde la carpeta /terraform (tiene que estar en el path de windows esta carpeta y ejecutarse desde ahi, he tenido errores debido a los dos motivos)  // inicio del despliegue con terraform
se identifica los ficheros y se inicializa en installa el proevedor de azurre

2. Creacion del plan, define lo que tiene que hacer en azure, estructura no crea aun. es un paso opcional pero buena practica.

        terraform plan -out=myplan

    en este punto preguntara por el log in de azure y necesitaremos poner
        
        az login

    abrirar una ventana del navegador por defecto para introducir las credenciales de unir

    Cuando termine creara un fichero ilegible pero en la consola podremos ver los resultados  
    el siguiente paso podria ser validar la configuracion (antes de contruir el plan)

        Terraform fmt
  
    y por ultimo contruir el plan
        
        terraform apply "myplan" (Terraform apply -auto-approve) --esta ultima si no se ha 
        
    hecho el plan antes
    
    para ver la ip de la maquina virtual para conectarse ejecuta los siguiente

        terraform refresh

    para conectarse on ssh desde linux como el profe se hace lo siguiente

        ssh contenedor@laipquehasalido  //contenedor es el usuario definido

    Tengo que probar en windows como se hace esto

    si no hay plan creado en este momento se contruye el plan

3. Destruir la infraestructura creada
    
        Terraform destroy


Error1: falta de aceptar las condiciones legales y no crea la VM 

    Creating the VM I get this error about accepted the legal terms and conditions antes de crear la VM y no me dejaba crearla

    I have to execute this:

    az vm image terms accept --publisher cognosys --offer CentOS-8-stream-free --plan CentOS-8-stream-free

    to aceept terms and contitions for the VM

Error2: Crear la clave publica de ssh, necesite ejecutar esto y luego te pregunta donde va el archivo guardado

     ssh-keygen -t rsa -b 2048

Documentacion del terraform Registry

    para crear la maquina virtual y definirla
        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
    para el clubster de Kubernetes
        https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster

son los dos importantes de la practica

PODMAN

Una vez en la maquina virtual linux para installar podman

    sudo dnf -y install podman httpd-tool openssl 
    
Con esto installo podman, la base de datos y la herramienta para el certificado

para preparar la appicacion web empezamos generando una carpeta

    mkdir webserver && cd webserver 

Ahora creamos una base de datos con los usuarios que puede acceder a ese servicio web

    httpasswd -cBd .cred test D3v0ps.2023

Siguiente paso es crear el certificado autofirmado para esa aplicacion 
empezamos generando la clave y la guardamos en el fichero localhost.key de 2048 bits

    openssl genrsa -out localhost.key 2048

Ahora generamos el la peticion del certificado

    openssl requ -key localhost.key -new -out localhost.csr -subj "/C=ES/ST=Malaga/L=Malaga/O=DevOps/OU=Ejemplo/CN=vm1"

Ahora generamos en certificado

    openssl x509 -signkey localhost.key -in localhost.csr -req -days 365 -out localhost.crt

lo siguiente es crear index.html con una sola linea que diga hello Jose
Luego en fichero de configuracion de apache o nx (esta en el repositorio del profe)

    httpd.conf file

en este archivo se cargan los certificados y la clave tanto como los moduclos a utilizar asi como el directorio index.hml, tambien que busque un fichero con la extesion .ht* para la autentificacion
Falta crear ese ficher htaccess que usa apache y definir la autentificacion

Ahora el siguiente paso es conteneizar esto y crear una imagen para ello definimos el fichero 
    
    containerfile 

(ver video caso practico 2 parte) esto definira una copiara archivos que hemos creado aqui al directorio adecaudo de la imagen que crearemos

Luego se crea esa imagen con PODMAN con un comando similar al de docker

    sudo podman build -t webserver

Esto descargara la imangen httpd y luego copiara los archivos que hemos descrito en el containerfile

    Sudo podman images 

me mostrara la imagen generada local mente en el servidor

podria desplegarla desde aqui, pero en ese caso vamos a subirla primero al conteiner registry de Azure, para poder subir la imagen necesita ser etiquetada (casopractico2)

    sudo podman tag loclahost/webserver:latest ptaritepui.acurecr.io/webserver:casopractico2

donde ptaritupuei.azurecr e la url que cree en azure 

Ahora necesito autenticareme en el conteneir registry (me la dio terraform cuando termino el despliegue de la arquitectura, como son datos sensible le digo explicitamente que lo imprima)
    terraform output acr_admin_pass

ahora me autentico

    sudo podman login URL 

me pedira user and password
ahora voy a subir la imagen etiquetada

    sudo postman push url/etiqueta

esto subira a azure esa imagen que he creado

lueog borramos las imagenes en local
    
    sudo podman rm image (id)

si esta etiquetada me pide un force

AHora se crea el contenedor a partir de esa imagen en Azure

    sudo podman create --name web -p 8080:443 url/webserver:etiqueta

donde url del profe es ptaritepui y la etiqueta es casopractico2

con esto se descarga y levanta el contenedor

Tengo que iniciar el contenedor, con esto veo los arrancados y los no arrancados 

    sudo podman ps -a

el -a me enseña los no inicializados

Quiero que ese contenedor sea un servicio en el SO con lo cual lo puedo reiniciar la maquina se reinicie el servicio web tambien.

    sudo podman generate systemd --new --files --name web

una diferencia con Docker es que puedo hacer esto en podman, esto hace que el SO controle este contenedor, y genera un fichero que se llama container-web.services que puedo gestionar a traves del sistema operativo

Hay que copiar ese archivo container-web.server a la ruta /etc/systemd/system/

    sudo cop -z container-web.services /etc/systemd/system/

tambien hay que advertir al systema operativo de lo que tiene que hacer para ello se usa este comando

    sudo systemctl daemo-reload

para que re-lea ese directorio que hay ficheros nuevos ubicados alli

ahora necesitaremos inicializar el contenedor a nivel de systema operativo

    sudo systemctl enable container-web.service --now

esto significa que la siguiente vez que la maquina se reinicie recordara reiniciar este contenedor tambien.

    sudo systemctl status container-web.services
    sudo podman ps

estos dos comandos me mostraran el contendor andando ahora, y cuando reinicie la maquina tambien seguira andando

    curl -k https://localhost:8080

esto necesitara las credenciales

    curl -k https://test:D3v=ps.2023@localhost:8080

si hacemos Sudo reboot y reinicio la maquina, esto seguira funcionando, me conecto a traves del navegador web con la ip externa tambien mostraria eso poniendo esta url

Https://13.87.157:8080 me diria que no es seguro, conf avanzada, acceder y con las credenciales debe entrar el servidor web tambien


Ahora con la clase 36 y 37 empieza la teoria de Kubernetes












ANSIBLE


