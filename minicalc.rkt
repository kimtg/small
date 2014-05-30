; (C) 2014 KIM Taegyoon
; Postfix Calculator
#lang racket
(require racket/gui/base)
(displayln "minicalc
The inexact result will be copied to the clipboard.
+ - * / ^ sqrt")
(define stack '())
(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))
(define (eval-string str)
  (eval (read (open-input-string str)) ns))

(define (check-num-op n)
  (if (< (length stack) n)
      (begin
        (printf "Not enough operands. Required: ~a. Given: ~a.\n" n (length stack))
        #f)
      #t))

(let loop ()
  (display "> ")
  (define line (read-line))
  (unless (eof-object? line)
    (define tokens (string-split line))
    (for ([tok tokens])      
      (cond [(member tok (list "+" "-" "*" "/"))
             (when (check-num-op 2)
               (set! stack (cons ((eval-string tok) (second stack) (first stack)) (drop stack 2))))]
            [(equal? tok "^")
             (when (check-num-op 2)
               (set! stack (cons (expt (second stack) (first stack)) (drop stack 2))))]
            [(equal? tok "sqrt")
             (when (check-num-op 1)
               (set! stack (cons (sqrt (first stack)) (rest stack))))]
            [else
             (define t (string->number tok))
             (when t
               (set! stack (cons t stack)))]
            ))
    (unless (empty? stack)
      (define result (first stack))
      (define result2 (exact->inexact result))
      (displayln (format "~a ~~ ~a" result result2))
      (send the-clipboard set-clipboard-string (~a result2) 0))
    (set! stack '())
    (loop)))
