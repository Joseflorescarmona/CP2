README

Segunda practica del experto en DevOps:

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
        
        terraform apply "myplan" 
    
    si no hay plan creado en este momento se contruye el plan

3. Destruir la infraestructura creada
    
        Terraform destroy


Errors:

Creating the VM I get this error about accepted the legal terms and conditions antes de crear la VM y no me dejaba crearla

I have to execute this:

az vm image terms accept --publisher cognosys --offer CentOS-8-stream-free --plan CentOS-8-stream-free

to aceept terms and contitions for the VM

