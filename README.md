# GoYacc Example: Parsing Phone Nubmers

On GopherCon 2018, Sugu gave a wonderful
[presentation](https://about.sourcegraph.com/go/gophercon-2018-how-to-write-a-parser-in-go#using-goyacc)
on how to write a parser usign GoYacc.

This example adds more topics to Sugu's example, including:

- Generating AST
- Error reporting
- Tracing position of errors

To build the run this example, type the following command:

```bash
goyacc a.y && go test -v
```
