%option case-insensitive
%option yylineno
%{
#include <cstdlib>
#include <QString>
#include <stdio.h>
#include <iostream>
#include <NodoAST.h>
#include "qlist.h"
#include "parser.h"

int yylex();
void yyerror(const char *s);
int linea=0; // Para contar lineas
int columna = 1; // para las columnas
int anterior = 0;
NodoAST *raiz;
%}

%option header-file="scanner.h"
%option outfile="scanner.cpp"
%option noyywrap
%option nounput

letra [a-zA-Z]+
numero [0-9]+
booleano ("verdadero"|"fals"("e"|"o")|"true")
decimal {numero}"."{numero}
caracter "\'"("\\")?({letra}|{numero})"\'"
identificador {letra}({letra}|{numero}|"_")*
cadena "\""[^"\""]*"\""
//sinosi ("sino")[[:blank:]]("si")

%x COM COMM

%%
INITIAL
{
    [[:blank:]] { columna++; }
    "<<" { BEGIN COM; }
    "<-" { BEGIN COMM; }
    "\t" { strcpy(yylval.TEXT, yytext); columna=26; }
    "\n" { linea++;  columna = 0; anterior = 0; }
    {numero} {   
        columna=columna+ anterior;  
        anterior = strlen(yytext);strcpy(yylval.TEXT, yytext);
        return ENTERO;
    }
    {decimal} {   
        columna=columna+ anterior;  
        anterior = strlen(yytext);
        strcpy(yylval.TEXT, yytext); 
        return DECIMAL;
    }
    {caracter} {   
        columna=columna+ anterior;  
        anterior = strlen(yytext);
        strcpy(yylval.TEXT, yytext); 
        return CARACTER;
    }
    {booleano} {   
        columna=columna+ anterior;  
        anterior = strlen(yytext);
        strcpy(yylval.TEXT, yytext); 
        return BOOLEANO;
    }
    {cadena} {   
        columna= columna+ anterior;  
        anterior = strlen(yytext);
        strcpy(yylval.TEXT, yytext); 
        return CADENA;
    }
    "&&" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_AND;
    }
    "!=" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_DIFERENTE;
    }
    "==" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_IGUAL;
    }
    ">"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MAYOR;
    }  
    ">="{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MAYOR_IGUAL;
    }
    "<"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MENOR;
    } 
  
    "<="{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MENOR_IGUAL;
    }
    "!" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_NOT;
    }
    "||" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_OR;
    } 
    "="{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_ASIGNACION;
    }
    "++"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_AUMENTO;
    }
    "--"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_DECREMENTO;
    }
    "/"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_DIVISION;  
    }
    "+"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MAS;
    }
    "-"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MENOS;
    }
    "*"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_POR;  
    }
    "^"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_POTENCIA;
    }
    "(" {
        columna=columna+ anterior;  
        anterior = strlen(yytext);
        strcpy(yylval.TEXT, yytext); 
        return tk_PARIZQ; 
    }
    ")" {   
        columna=columna+ anterior;  
        anterior = strlen(yytext);
        strcpy(yylval.TEXT, yytext); 
        return tk_PARDER;
    }
    "]" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_CORDER;
    }
    "[" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_CORIZQ;
    }
    "}" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_LLVDER;
    }
    "{" {
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_LLVIZQ;
    }
    ";"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_PUNTOCOMA;
    }
    "para"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_PARA;
    }
    "imprimir"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_IMPRIMIR;
    }
    "repetir"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_REPETIR;
    }
    "show"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_SHOW;
    }
    "si"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_SI;
    }
    "sino"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_SINO;
    } 
    "public"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_PUBLIC; 
    }
    "main"{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return tk_MAIN;
    }
    {identificador}{
        columna=columna+anterior;
        anterior=strlen(yytext);
        strcpy(yylval.TEXT,yytext);
        return IDENTIFICADOR;
    }
    . {
        columna=columna+ anterior;  
        anterior = strlen(yytext);strcpy(yylval.TEXT, yytext);
        /*errorT *nuevoE = new errorT("Lexico",yytext,linea, columna);
        listaErrores->append(*nuevoE);*/
        std::cout <<yytext <<" Error Lexico en la linea "<< linea << " Columna:"<< columna<<  std::endl;
    }
}
<COMM>"->" { BEGIN INITIAL; }
<COMM>"\n" {linea++;};
<COMM>.;
<COMM><<EOF>> { yyerror("unclosed comment"); }
<COM>"\n" { linea++; columna = 0; BEGIN INITIAL; };
<COM>.;
%%