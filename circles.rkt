#lang racket
; (C) 2014 KIM Taegyoon

(require racket/gui)

(define frame
  (new (class frame%
         (define/augment (on-close) (send timer stop))
         (super-new))
       [label "Circles"]
       [width 400]
       [height 400]))

(define (paint canvas dc)
  (define-values (w h) (send dc get-size))
  (define r (/ (min w h) 2))

  ; center
  (define r2 (* r (random)))
  (define c (make-object color%
              (random 256)
              (random 256)
              (random 256)
              (random)))
  (send dc set-brush c 'solid)
  (define cx (* w (random)))
  (define cy (* h (random)))
  (send dc draw-ellipse (- cx r2) (- cy r2) (* r2 2) (* r2 2)))

(define canvas (new canvas%
                [parent frame]
                [paint-callback (lambda (canvas dc) (send dc clear))]))

(define timer (new timer%
                   [notify-callback (lambda () (paint canvas dc) (yield))]
                   [interval 500]))

(send frame maximize #t)
(define dc (send canvas get-dc))
(send dc set-smoothing 'smoothed)
(send dc set-background "white")
(send dc set-pen "white" 0 'transparent)
(send frame show #t)
