
Const M = 4 ; {orden del árbol}

Type 

  alumnos = Record
    NyA: string[30];
    dni: integer;
    legajo: integer;
    anioI: integer;
  End;



  nodo = Record
    cant_alumnos: integer;
    claves:   array[1..M-1] Of integer;
    hijos:    array[1..M] Of integer;
  End;

  archivo = file Of alumnos;
  arbol = file Of nodo;
  //2.B) Nodo=512 bytes
  //     Entero=4 bytes
  //     En cada nodo se almacena los M-1 enlaces
  //     N = (M-1)*A+M*B+C
  //     A= (M-1)*4  
  //
  //     A es igual a (M-1)*4 por que se almacenan M-1 enlaces 
  //     y no el registro entero.
  //
  //     512 = (M-1)*(M-1)*4+M*4+4 o 512 = (M-1)*4+M*4+4
  //     M= 10 o 11                  M= 64
  //----------------------------------------------------------------
  //2.C) Un orden mayor en el árbol B generalmente conlleva beneficios 
  //     en términos de eficiencia en las operaciones, como menor altura 
  //     del árbol y menos accesos al disco, pero también puede requerir 
  //     más memoria. Es importante encontrar un /equilibrio entre estos 
  //     factores según las necesidades y restricciones del sistema.
  //----------------------------------------------------------------
  //2.D)   El proceso de búsqueda implica descender por las 
  //       ramas del  árbol B, utilizando las claves almacenadas en cada 
  //       nodo para guiar la búsqueda hacia la ubicación correcta del 
  //       alumno con el DNI 12345678.
  //        
  //        Lo hizo chatgpt 💀
  //----------------------------------------------------------------
  //2.E)  zzzz me aburri
