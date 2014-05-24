#lang racket
; (C) 2014 KIM Taegyoon
; clue from: http://rosettacode.org/wiki/Mandelbrot_set#Racket
(require racket/draw)
(define max-iteration 255)

(define (iterations a z i)
  (let loop ([z z] [i i])  
    (if (or (>= i max-iteration) (> (magnitude z) 2))
        i
        (loop (+ (* z z) a) (add1 i)))))

(define (iter->color i)
  (if (>= i max-iteration)
      (make-object color% "black")
      (let ([bright (modulo i 256)])
        ;(make-object color% bright 0 (- 255 bright)))))
        (make-object color% (- 255 bright) (- 255 bright) (- 255 bright)))))

(define (mandelbrot width height)
  (define target (make-bitmap width height))
  (define dc (new bitmap-dc% [bitmap target]))
  (for* ([x width] [y height])
    (define real-x (- (* 3.0 (/ x width)) 2.25))
    (define real-y (- (* 2.5 (/ y height)) 1.25))
    (send dc set-pen (iter->color (iterations (make-rectangular real-x real-y) 0 0)) 1 'solid)
    (send dc draw-point x y))
  (send target save-file "mandelbrot.png" 'png))

(mandelbrot 600 500)
