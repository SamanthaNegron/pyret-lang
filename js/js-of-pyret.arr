#lang pyret

provide *
import "compile-structs.arr" as C
import ast as A
import "anf.arr" as N
import "ast-split.arr" as AS
import "anf-simple-compile.arr" as AC
import "desugar.arr" as D

fun pretty(src): src.tosource().pretty(80).join-str("\n") end

fun make-compiled-pyret(program-ast, env):

  desugared = D.desugar(program-ast, env)
  anfed = N.anf-program(desugared)
#  split = AS.ast-split(anfed.body)
  split = AS.split-result-e([], anfed.body, set([]))
  compiled = AC.compile(split, anfed.imports)
  code = compiled.to-ugly-source()
  c = C.ok(code)
  
  {
    pyret-to-js-standalone: fun():
      raise("Cannot generate standalone JS")
    end,
    pyret-to-js-pretty: fun():
      C.ok(pretty(compiled))
    end,
    pyret-to-js-runnable: fun():
      c
    end
  }
end

