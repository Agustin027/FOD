
//1.A)

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
    claves:   array[1..M-1] Of alumnos;
    hijos:    array[1..M] Of integer;
  End;
  arbol = file Of nodo;


Var 
  arbolB: arbol;
  //-------------------------------------------------------------
  //1.B)  N=(M-1)*A+M*B+C
  //    N: tamaño del nodo en bytes.
  //    A: tamaño del registro en bytes.
  //    B: tamaño de cada enlace en a un hijo en bytes.
  //    C: tamaño que ocupa la variable que indica 
  //       la cantidad de claves en bytes.
  //
  //     Persona=65 bytes
  //     Nodo=  512 bytes
  //     Entero= 4 bytes
  //     512=(M-1)*65+M*4+4
  //     M= 8 
  //
  //     Como M=8, el orden del árbol es 8. Oséa que 
  //     cada nodo puede tener 7 Registros persona y 8 hijos.
  //-------------------------------------------------------------
  //1.C) Organizar el archivo con toda la información de los alumnos 
  //     como un árbol B implica que el valor de 𝑀 (orden del árbol) 
  //     determina la cantidad de claves y punteros que cada nodo puede 
  //     manejar.
  //-------------------------------------------------------------
  //1.D) Usaria el legajo o el Dni como clave de búsqueda. Por que 
  //     son únicos para cada alumno y no se repiten.
  //-------------------------------------------------------------
  //1.E) Se buscaria la clave en el nodo raíz, si no se encuentra
  //     se toma el hijo anterior a la clave buscada y se vuelve a
  //     buscar en ese nodo. Se repite el proceso hasta llegar a un
  //     nodo hoja.
  //     
  //     Mejor caso: 1 lectura, la clave se encuentra en el nodo raíz.
  //     Peor caso: h lecturas, h es la altura del árbol, osea esta en 
  //                un nodo hoja.
  //-------------------------------------------------------------
  //1.F) Podrian haber mas lecturas ya que el arbol esta optimizado
  //     para la busqueda por legajo o dni. Si se busca por otro campo
  //     se podrian hacer mas lecturas.
  // -------------------------------------------------------------
