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


