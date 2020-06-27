package exampleparser

import (
	"fmt"
	"testing"
)

func parse(pn string) *astPhoneNumber {
	l := newLexer(pn)
	_ = yyParse(l)
	return l.result
}

func TestParse(t *testing.T) {
	fmt.Printf("%++v\n", parse("123-456-7890"))
	fmt.Printf("%++v\n", parse("123 456 7890"))
	fmt.Printf("%++v\n", parse("(123)456-7890"))
	fmt.Printf("%++v\n", parse("(123)456 7890"))
}
