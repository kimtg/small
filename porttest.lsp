#!/usr/bin/newlisp
(println "porttest (C) 2013 KTG")
(define (net-open? host port)
  (let (s (net-connect host port 3000))
    (if s (begin (net-close s) true) nil)))
(print "host: ")
(setq host (read-line))
(print "port: ")
(setq port (int (read-line)))
(while true
  (println (date) " " host " " port " " (if (net-open? host port) "open" "closed"))
  (sleep 1000))
