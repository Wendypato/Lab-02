%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

double varvalue[26];
%}

%union {
    double dval;
    char symbol;
}

%token <symbol> Name
%token <dval> Number
%token Floatdcl Print Intdcl
%type <dval> expression

// para quitar la ambiguedad
%left '+' '-'
%left '*' '/'

%%

input:
      /* empty */
    | input '\n'
    | input statement '\n'
    ;

statement:
      Floatdcl Name
    | Intdcl Name
    | Name '=' expression       { varvalue[$1 - 'a'] = $3; }
    | Print Name                { printf("%f\n", varvalue[$2 - 'a']); }
    ;

expression:
      expression '+' expression   { $$ = $1 + $3; }
    | expression '-' expression   { $$ = $1 - $3; }
    | expression '*' expression   { $$ = $1 * $3; }
    | expression '/' expression   { $$ = $1 / $3; }
    | '(' expression ')'          { $$ = $2; }
    | Number                      { $$ = $1; }
    | Name                        { $$ = varvalue[$1 - 'a']; }
    ;

%%

int main(int argc, char **argv) {
    FILE *fd;

    if (argc == 2) {
        if (!(fd = fopen(argv[1], "r"))) {
            perror("Error: ");
            return -1;
        }

        yyset_in(fd);
        yyparse();
        fclose(fd);
    } else {
        printf("Usage: %s filename\n", argv[0]);
    }

    return 0;
}
