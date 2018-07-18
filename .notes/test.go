package main

import (
        "fmt"

        "github.com/rafaeldias/async"
)

func fib(p, c int) (int, int) {
  return c, p + c
}

func main() {
        d := 0

        // execution in series.
        res, e := async.Waterfall(async.Tasks{
                fib,
                fib,
                fib,
                func(p, c int) (int, error) {
                        try {
                            a := 1 / d
                        }
                        return a, nil
                },
        }, 0, 1)

        if e != nil {
              fmt.Printf("Error executing a Waterfall (%s)\n", e.Error())
        }

        fmt.Println(res[0].(int)) // Prints 3
}