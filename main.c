#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LIMITE 40

struct Cadenas{
    char caracter[30];
};

int cantidadCad = 0;

FILE *fd;
FILE *nuevofd;

void CargarCadenas(FILE *a,struct Cadenas cadenas[],char dir[],int cantCad);
void AbrirNuevoArch(FILE *nuevoa,char nuevaDir[]);
void ClasificarCadenas(FILE *nuevoa,struct Cadenas cadenaRecibida[],char nuevaDir[],int cantCad);

int main()
{
    //int cantidadCad = 0;
    struct Cadenas cadenas[LIMITE];
    char direccion[] = "C:\\prueba\\cadenas.txt";
    char DirArchNuevo[] ="C:\\prueba\\newClasificacion.txt";
    CargarCadenas(fd,cadenas,direccion,cantidadCad);
    ClasificarCadenas(nuevofd,cadenas,DirArchNuevo,cantidadCad);
    return 0;
}

void CargarCadenas(FILE *a,struct Cadenas cadenas[],char dir[],int cantCad){
    int c,j=0;
    a = fopen(dir,"rt");
    if(a == NULL){
        printf("Error al leer el archivo.");
    }else{
        printf("Archivo leido correctamente.");
    }

    while((c=fgetc(a)) != EOF){
        if(c != ','){
            cadenas[cantCad].caracter[j] = c;
            j++;
        }else{
            cantCad++;
            j=0;
        }
    }
    fclose(a);
}
void AbrirNuevoArch(FILE *nuevoa,char nuevaDir[]){
    nuevoa = fopen(nuevaDir,"at");
    if(nuevoa == NULL){
        printf("Error con el nuevo archivo.");
    }else{
        printf("Nuevo archivo OK.");
    }
}

void ClasificarCadenas(FILE *nuevoa,struct Cadenas cadenaRecibida[],char nuevaDir[],int cantCad){
    int i,j;
    int flag=0;
    for(i=0;i<cantCad;i++){
        if(cadenaRecibida[i].caracter[0] == '0' && (cadenaRecibida[i].caracter[1] == 'x' || cadenaRecibida[i].caracter[1] == 'X')){
            for(j=2;j<strlen(cadenaRecibida[i].caracter);j++){
                switch(cadenaRecibida[i].caracter[j]){
                    case 'a': break;
                    case 'b': break;
                    case 'c': break;
                    case 'd': break;
                    case 'e': break;
                    case 'f': break;
                    case 'A': break;
                    case 'B': break;
                    case 'C': break;
                    case 'D': break;
                    case 'E': break;
                    case 'F': break;
                    case '0': break;
                    case '1': break;
                    case '2': break;
                    case '3': break;
                    case '4': break;
                    case '5': break;
                    case '6': break;
                    case '7': break;
                    case '8': break;
                    case '9': break;
                    default: flag = 1;break;
                }
            }
            if(flag == 0){
                AbrirNuevoArch(nuevoa,nuevaDir);
                fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
                fprintf(nuevoa,"\tEs constante Hexadecimal.\n");
                fclose(nuevoa);
            }else{
                AbrirNuevoArch(nuevoa,nuevaDir);
                fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
                fprintf(nuevoa,"\tNo es constante.\n");
                fclose(nuevoa);
            }
        }else if(cadenaRecibida[i].caracter[0] != '0'){
            for(j=1;j<strlen(cadenaRecibida[i].caracter);j++){
                switch(cadenaRecibida[i].caracter[j]){
                    case '0': break;
                    case '1': break;
                    case '2': break;
                    case '3': break;
                    case '4': break;
                    case '5': break;
                    case '6': break;
                    case '7': break;
                    case '8': break;
                    case '9': break;
                    default: flag = 1;break;
                }
            }
            if(flag == 0){
                AbrirNuevoArch(nuevoa,nuevaDir);
                fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
                fprintf(nuevoa,"\tEs constante Decimal.\n");
                fclose(nuevoa);
            }else{
                AbrirNuevoArch(nuevoa,nuevaDir);
                fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
                fprintf(nuevoa,"\tNo es constante.\n");
                fclose(nuevoa);
            }
        }else if(cadenaRecibida[i].caracter[0] == '0'){
            for(j=1;j<strlen(cadenaRecibida[i].caracter);j++){
                switch(cadenaRecibida[i].caracter[j]){
                    case '0': break;
                    case '1': break;
                    case '2': break;
                    case '3': break;
                    case '4': break;
                    case '5': break;
                    case '6': break;
                    case '7': break;
                    default: flag = 1;break;
                }
            }
            if(flag == 0){
                AbrirNuevoArch(nuevoa,nuevaDir);
                fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
                fprintf(nuevoa,"\tEs constante Octal.\n");
                fclose(nuevoa);
            }else{
                AbrirNuevoArch(nuevoa,nuevaDir);
                fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
                fprintf(nuevoa,"\tNo es constante.\n");
                fclose(nuevoa);
            }
        }else{
            AbrirNuevoArch(nuevoa,nuevaDir);
            fwrite(cadenaRecibida[i].caracter,1,strlen(cadenaRecibida[i].caracter),nuevoa);
            fprintf(nuevoa,"\tNo es constante.\n");
            fclose(nuevoa);
        }
    }
}
