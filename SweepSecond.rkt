#lang racket
; (C) 2013-2014 KIM Taegyoon

(require racket/gui)
(require racket/date)

; define short names
(define-syntax-rule (: x ...) (send x ...))

(define (toRadians ratio)
  (+ (* (- ratio) pi 2) pi))

(define frame
  (new (class frame%
         (define/augment (on-close) (exit))
         (super-new))
       [label "SweepSecond"]
       [width 400]
       [height 400]))

(define brushHour (make-object brush% "deepskyblue"))
(define brushMin (make-object brush% "lawngreen"))
(define brushSec (make-object brush% "crimson"))

(define (drawHand dc center radius radians brush sideWeight)
  (define cx (: center get-x))
  (define cy (: center get-y))
  (define pTo (make-object point%
                (+ cx (* radius (sin radians)))
                (+ cy (* radius (cos radians)))))
  (define pFrom (make-object point%
                  (+ cx (* (/ radius 8) (sin (- radians pi))))
                  (+ cy (* (/ radius 8) (cos (- radians pi))))))
  (define pSide1 (make-object point%
                   (+ cx (* (/ radius 20) sideWeight (sin (- radians (/ pi 2)))))
                   (+ cy (* (/ radius 20) sideWeight (cos (- radians (/ pi 2)))))))
  (define pSide2 (make-object point%
                   (+ cx (* (/ radius 20) sideWeight (sin (+ radians (/ pi 2)))))
                   (+ cy (* (/ radius 20) sideWeight (cos (+ radians (/ pi 2)))))))
  (: dc set-brush brush)
  (: dc draw-polygon (list pFrom pSide1 pTo pSide2)))

(define (drawTick dc center radius length radians pen)
  (define cx (: center get-x))
  (define cy (: center get-y))
  (define pTo (make-object point%
                (+ cx (* radius (sin radians)))
                (+ cy (* radius (cos radians)))))
  (define pFrom (make-object point%
                  (+ cx (* radius (- 1 length) (sin radians)))
                  (+ cy (* radius (- 1 length) (cos radians)))))
  (: dc set-pen pen)
  (: dc draw-lines (list pTo pFrom)))

(define (paint canvas dc)
  (: dc set-background "black")
  (: dc clear)
  (: dc set-smoothing 'smoothed)
  
  (define now (current-date))
  (define hour (date-hour now))
  (define minute (date-minute now))
  (define second (+ (date-second now) (- (/ (current-inexact-milliseconds) 1000) (current-seconds))))
  
  (: dc set-text-foreground "white")
  ;  (: dc draw-text (date->string now #t) 0 0)
  (: frame set-status-text (date->string now #t))
  
  (define-values (w h) (: dc get-size))
  (define r (/ (min w h) 2))
  (define center (make-object point% (/ w 2) (/ h 2)))
  
  (define radSec (toRadians (/ second 60)))
  (define radMin (toRadians (/ (+ minute (/ second 60)) 60)))
  (define radHour (toRadians (/ (+ (remainder hour 12) (/ minute 60)) 12)))
  
  ; minute ticks
  (define pen (make-object pen% "white" (/ r 120)))
  (for ([rad (range 0 (* pi 2) (/ (* pi 2) 60))])
    (drawTick dc center (* r 0.95) 0.06 rad pen))
  
  ; hour ticks
  (set! pen (make-object pen% "white" (/ r 60)))
  (for ([rad (range 0 (* pi 2) (/ (* pi 2) 12))])
    (drawTick dc center (* r 0.95) 0.2 rad pen))
  
  ; 0 3 6 9 ticks
  (set! pen (make-object pen% "white" (/ r 30)))
  (for ([rad (range 0 (* pi 2) (/ (* pi 2) 4))])
    (drawTick dc center (* r 0.95) 0.2 rad pen))
  
  ; rim
  (: dc set-pen "white" (/ r 60) 'solid)
  (: dc set-brush "" 'transparent)
  (: dc draw-ellipse (- (: center get-x) r) (- (: center get-y) r) (* r 2) (* r 2))
  
  ; hands
  (: dc set-pen "" 0 'transparent)
  (drawHand dc center (* r 0.5) radHour brushHour (/ 1.1 0.5))
  (drawHand dc center (* r 0.8) radMin brushMin (/ 1.0 0.8))
  (drawHand dc center (* r 0.9) radSec brushSec (/ 0.5 0.9))
  
  ; center
  (define r2 (/ r 20))
  (: dc set-brush "white" 'solid)
  (: dc draw-ellipse (- (: center get-x) r2) (- (: center get-y) r2) (* r2 2) (* r2 2)))

(define cv (new canvas%
                [parent frame]
                [paint-callback paint]))

(define timer (new timer%
                   [notify-callback (lambda () (: cv refresh) (yield))]
                   [interval (quotient 1000 60)]))

(: frame create-status-line)
(: frame show #t)