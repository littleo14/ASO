#!/bin/bash
#Primer punto: ¿Es el usuario root?
function Comprobar_root(){
    #Se comprueba el numero del usuario con "id -u"
    #Si el número es 0, entonces es el root. Cualquier otro no es root.
    if [ $(id -u) -ne 0 ]; 
    then
        exit
    fi
}
#Segundo y tercer punto. Sacar el contenido de paquetes.txt y meterlo en una array.
function Meter_paquete(){
    #presupongo que el script y paquetes.txt estarán en la misma carpeta siempre.
    datospaquetes=$(cat ./paquetes.txt)
    for linea in $datospaquetes; 
    do
        vectorpaquetes[$i]="$linea"
        ((i++))
    done
}
#Cuarto punto. Aqui es donde se realizan las acciones.
function Accionpaquetes(){
    for PaqueteyAccion in ${vectorpaquetes[@]}; 
    do
    #separamos los vectores en sus componentes.
    paquete=$( echo $PaqueteyAccion | cut -d ":" -f1 )
    accion=$( echo $PaqueteyAccion | cut -d ":" -f2 )
    #preparamos la variable con la que saber si está instalado o no.
    instalacion=$( whereis $paquete | grep bin| wc -l )
    #Primero comprobamos el tipo de accion que realizamos.
    echo $paquete
    if [ $accion == "add" ]; 
    then
        if [ $instalacion -eq 0 ];
        then
            sudo apt install $paquete
        fi
    elif [ $accion == "remove" ];
    #nota del autor: no tengo vim instalado, así que aunque la accion sea remove
    #No hará nada. Acordarse para no liarse.
    then
        if [ $instalacion -gt 0 ];
        then            
            sudo apt remove $paquete
        fi
    elif [ $accion == "status" ];
    then
        if [ $instalacion -eq 0 ];
        then
            echo "El paquete no está instalado"
        elif [ $instalacion -gt 0 ];
        then
            echo "El paquete está instalado"
        fi
    else
        echo "La accion del paquete no es una de las establecidas"
    fi
    done
}
Comprobar_root
Meter_paquete
Accionpaquetes