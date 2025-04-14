%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

%option noyywrap

%%

"//".*                  { printf("Comment "); return '\n'; }
"p"                     { printf("print "); return Print; }
"f"                     { printf("floatdcl "); return Floatdcl; }
"i"                     { printf("intdcl "); return Intdcl; }
  /* exclui f, i, p porque ya estan definidos como palabtras claves*/
[a-eghj-oq-z]           { printf("id "); yylval.symbol = yytext[0]; return Name; }
[0-9]+                  { printf("inum "); yylval.dval = atoi(yytext); return Number; }
"="                     { printf("assign "); return '='; }
"+"                     { printf("plus "); return '+'; }
"*"                     { printf("times "); return '*'; }
"-"                     { printf("minus "); return '-'; }
"/"                     { printf("divided "); return '/'; }
[0-9]+"."[0-9]+         { printf("fnum "); yylval.dval = atof(yytext); return Number; }
[ \t]                   { /* ignore whitespace */ }
\n                      { return '\n'; }           /* logical EOF */
.                       { return yytext[0]; }

%%
