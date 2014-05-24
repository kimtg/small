#lang racket
(require racket/date)

(displayln "porttest (C) 2014 KTG")
(define (tcp-open? host port)
  (with-handlers ((exn:fail:network? (lambda (e) #f)))
    (define-values (inp outp) (tcp-connect host port))
    (close-input-port inp)
    (close-output-port outp)
    #t))

(define (read-line2)
  (read-line (current-input-port) 'any))

(display "Host: ")
(define host (read-line2))
(display "Port: ")
(define port (string->number (read-line2)))
(let loop ()
  (displayln (format "~a ~a ~a ~a" (date->string (current-date) #t) host port 
                     (if (tcp-open? host port) "open" "closed")))
  (sleep 1)
  (loop))
