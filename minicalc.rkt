; (C) 2014 KIM Taegyoon
; Postfix Calculator
#lang racket
(displayln "minicalc (C) 2014 KIM Taegyoon")
(displayln "+ - * / ^ sqrt")
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
    (unless (empty? stack) (displayln (first stack)))
    (set! stack '())
    (loop)))