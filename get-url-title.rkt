#lang racket
; Gets the title of a website.
(require net/url)
(define (read-url url)
  (port->string (get-pure-port (string->url url) #:redirections 9)))

(define (get-url-title url)
  (define text (read-url url))
  (first (regexp-match* #rx"(?i:<title>(.*?)</title>)" text #:match-select second)))

(let loop ()
  (display "Enter URL: ")
  (define url (read-line (current-input-port) 'any))
  (unless (eof-object? url)
    (displayln (get-url-title url))
    (loop)))
