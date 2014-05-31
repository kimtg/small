; (C) 2014 KIM Taegyoon
#lang racket
(require racket/gui/base)

(displayln "MiniCalc - Postfix Calculator")
(displayln "+ - * / ^ sqrt")
(displayln "Racket expressions can be entered.")
(displayln "The inexact result will be copied to the clipboard.")
(define stack '())
(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))
(define (eval2 x)
  (eval x ns))

(define (check-num-op n)
  (if (< (length stack) n)
      (begin
        (printf "Not enough operands. Required: ~a. Given: ~a.\n" n (length stack))
        #f)
      #t))

(let loop ()
  (with-handlers ([exn? (lambda (e) (displayln e) (loop))])
    (cond [(not (empty? stack))
           (define result (first stack))
           (define result2 result)
           (when (number? result)
             (set! result2 (exact->inexact result)))
           (printf "~a\n" result2)
           (printf "> ~a " result)
           (set! stack (list result))
           (send the-clipboard set-clipboard-string (~a result2) 0)]
          [else (display "> ")])
    (define line (read-line))
    (unless (eof-object? line)
      (define code (read (open-input-string (~a "(" line ")"))))
      (for ([token code])
        (case token
          [(+ - * /)
           (when (check-num-op 2)
             (set! stack (cons ((eval2 token) (second stack) (first stack)) (drop stack 2))))]
          [(^)
           (when (check-num-op 2)
             (set! stack (cons (expt (second stack) (first stack)) (drop stack 2))))]
          [(sqrt)
           (when (check-num-op 1)
             (set! stack (cons (sqrt (first stack)) (rest stack))))]
          [else
           (define t (eval2 token))
           (when t
             (set! stack (cons t stack)))]))
      (loop))))
