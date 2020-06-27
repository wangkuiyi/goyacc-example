%{
package exampleparser

import (
    "fmt"
    "log"
    "strings"
    "unicode"
    "unicode/utf8"
)

// The following mimics an AST package of types representing tokens and
// other grammar elements.

type astArea string
type astPart1 string
type astPart2 string

type astPhoneNumber struct {
    area astArea
    part1 astPart1
    part2 astPart2
}

// The following defines the lexer required by goyacc-generated parser Go.

type lexer struct {
    input    string // the string being scanned
    start    int    // start position of this item
    pos      int    // current position in the input

    // Each parser instance has a lexer instance, so we save the parse result
    // in the lexer.
    result * astPhoneNumber
}

func newLexer(input string) *lexer {
        return &lexer{input: input}
}

func (l *lexer) Error(e string) {
    log.Panicf("lexer.Error at around %d~%d: %v", l.start, l.pos, e)
}

func (l *lexer) Lex(lval *yySymType) int {
        r := l.next()
        switch {
        case unicode.IsDigit(r):
                return l.emit(lval, DIGIT)  // goyacc generates const DIGIT.
        case strings.IndexRune("-() ", r) >= 0:
                return l.emit(lval, int(r)) // Use char value as token type.
        case r == 0:
                return 0 // indicate the end of lexing.
        }
        l.Error(fmt.Sprintf("Unknown character %c", r))
        return 0  // Unreachable.
}

func (l *lexer) emit(lval *yySymType, typ int) int {
        lval.token = l.input[l.start:l.pos]  // Refer to %union for field token.
        l.start = l.pos
        return typ
}

func (l *lexer) next() rune {
        if l.pos >= len(l.input) {
                return 0 // emit returns 0 to notify Lex EOF.
        }
        r, width := utf8.DecodeRuneInString(l.input[l.pos:])
        l.pos += width
        return r
}

%}

// Defines the goyacc-generated Go type yySymType struct.
%union{
    token string
    a astArea
    p1 astPart1
    p2 astPart2
    pn astPhoneNumber
}

%type <pn> phone_number
%type <a> area
%type <p1> part1
%type <p2> part2
%token <token> DIGIT
%left <token> '('
%left <token> ')'
%left <token> '-'
%left <token> ' '

%start phone_number

%%

area : DIGIT DIGIT DIGIT {
    $$ = astArea($1 + $2 + $3)
}
;

part1 : DIGIT DIGIT DIGIT {
    $$ = astPart1($1 + $2 + $3)
}
;

part2 : DIGIT DIGIT DIGIT DIGIT {
    $$ = astPart2($1 + $2 + $3 + $4)
}
;

phone_number
: area ' ' part1 ' ' part2 {
    setResult(yylex, $1, $3, $5)
}
| area '-' part1 '-' part2 {
    setResult(yylex, $1, $3, $5)
}
| '(' area ')' part1 ' ' part2 {
    setResult(yylex, $2, $4, $6)
}
| '(' area ')' part1 '-' part2 {
    setResult(yylex, $2, $4, $6)
}
;

%%

func setResult(l yyLexer, area astArea, part1 astPart1, part2 astPart2) {
    l.(*lexer).result = &astPhoneNumber{
        area : area,
        part1 : part1,
        part2 : part2,
    }
}
