%{
    #include <iostream>
    #include "scanner.h"//se importa el header del analisis sintactico
    #include "NodoAST.h"
    #include "qdebug.h"
    extern int yylineno; //linea actual donde se encuentra el parser (analisis lexico) lo maneja BISON
    extern int columna; //columna actual donde se encuentra el parser (analisis lexico) lo maneja BISON
    extern char *yytext; //lexema actual donde esta el parser (analisis lexico) lo maneja BISON
    extern NodoAST *raiz; // Raiz del arbol

    int yyerror(const char* mens)
    {
        std::cout << mens <<" "<<yytext<< std::endl;
        return 0;
    }
%}
//error-verbose si se especifica la opcion los errores sintacticos son especificados por BISON
%defines "parser.h"
%output "parser.cpp"
%error-verbose
%locations

%union{
//se especifican los tipo de valores para los no terminales y lo terminales
char TEXT [256];
class NodoAST *nodito;
}

//TERMINALES DE TIPO TEXT, SON STRINGS
%token<TEXT> ENTERO;
%token<TEXT> DECIMAL;
%token<TEXT> CARACTER;
%token<TEXT> BOOLEANO;
%token<TEXT> CADENA;
%token<TEXT> tk_AND;
%token<TEXT> tk_DIFERENTE;
%token<TEXT> tk_IGUAL;
%token<TEXT> tk_MAYOR;
%token<TEXT> tk_MAYOR_IGUAL;
%token<TEXT> tk_MENOR;
%token<TEXT> tk_MENOR_IGUAL;
%token<TEXT> tk_NOT;
%token<TEXT> tk_OR;
%token<TEXT> tk_ASIGNACION;
%token<TEXT> tk_AUMENTO;
%token<TEXT> tk_DECREMENTO;
%token<TEXT> tk_DIVISION;
%token<TEXT> tk_MAS;
%token<TEXT> tk_MENOS;
%token<TEXT> tk_POR;
%token<TEXT> tk_POTENCIA;
%token<TEXT> tk_PARIZQ;
%token<TEXT> tk_PARDER;
%token<TEXT> tk_CORDER;
%token<TEXT> tk_CORIZQ;
%token<TEXT> tk_LLVDER;
%token<TEXT> tk_LLVIZQ;
%token<TEXT> tk_PUNTOCOMA;
%token<TEXT> tk_PARA;
%token<TEXT> tk_IMPRIMIR;
%token<TEXT> tk_REPETIR;
%token<TEXT> tk_SHOW;
%token<TEXT> tk_SI;
%token<TEXT> tk_SINO;
%token<TEXT> tk_PUBLIC;
%token<TEXT> tk_MAIN;
%token<TEXT> IDENTIFICADOR;

/*No terimanesl*/
%type<nodito> INICIO;//
%type<nodito> EXPA; // Aritmetica
%type<nodito> LEXPA; // lista de instrucciones

%left suma menos
%left multi division
%left potencia

%start INICIO
%%

INICIO : LEXPA { raiz = $$; };

LEXPA: LEXPA  EXPA puntocoma
        {
            $$=$1;
            NodoAST *nodo = new NodoAST(@2.first_line, @2.first_column,"operacion","operacion");
            nodo->add(*$2);
            $$->add(*nodo);
        }
        | EXPA puntocoma
        {
            $$ = new NodoAST(@1.first_line, @1.first_column,"lexp","lexp");
            NodoAST *nodo = new NodoAST(@1.first_line, @1.first_column,"operacion","operacion");
            nodo->add(*$1);
            $$->add(*nodo);
        }
;

EXPA:
         EXPA suma EXPA {NodoAST *nod = new NodoAST(@1.first_line, @1.first_column,"suma",$2);  nod->add(*$1); nod->add(*$3); $$=nod;}
        |EXPA menos EXPA {NodoAST *nod = new NodoAST(@1.first_line, @1.first_column,"resta",$2); nod->add(*$1); nod->add(*$3); $$=nod;}
        |EXPA multi EXPA {NodoAST *nod = new NodoAST(@1.first_line, @1.first_column,"multi",$2); nod->add(*$1); nod->add(*$3); $$=nod;}
        |EXPA division EXPA{NodoAST *nod = new NodoAST(@1.first_line, @1.first_column,"div",$2); nod->add(*$1); nod->add(*$3); $$=nod;}
        |EXPA potencia EXPA{ NodoAST *nod = new NodoAST(@1.first_line, @1.first_column,"potencia",$2); nod->add(*$1);  nod->add(*$3);  $$=nod ;  }
        |menos EXPA { $$ = new NodoAST(@1.first_line, @1.first_column,$1,$1); $$->add(*$2);}
        |entero { $$ = new NodoAST(@1.first_line, @1.first_column,"int",$1);}
        |caracter { $$ = new NodoAST(@1.first_line, @1.first_column,"char",$1);}
        |decimal { $$ = new NodoAST(@1.first_line, @1.first_column,"double",$1);}
        |booleano { $$ = new NodoAST(@1.first_line, @1.first_column,"bool",$1);}
        |cadena { $$ = new NodoAST(@1.first_line, @1.first_column,"string",$1);}
        |pari EXPA pard{$$=$2;}
;

%%
