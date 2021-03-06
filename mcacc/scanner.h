#pragma once

#include <string>

#pragma once

#include <string>

#define YYSTYPE std::string

extern int yylex();
extern char* yytext;
void yyerror(std::string s);

// enum token { NEWLINE = 1, TEXT };

void start_command(std::string s);
void add_argument(std::string s);
void dispatch_command();
