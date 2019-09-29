#lang racket
; (C) 2013-2019 KIM Taegyoon

(require racket/gui)
(require racket/date)

(define (toRadians ratio)
  (+ (* (- ratio) pi 2) pi))

(define frame
  (new (class frame%
         (define/augment (on-close) (send timer stop))
         (super-new))
       [label "SweepSecond"]
       [width 400]
       [height 400]))

(define brushHour (make-object brush% "deepskyblue"))
(define brushMin (make-object brush% "lawngreen"))
(define brushSec (make-object brush% "crimson"))

(define (drawHand dc center radius radians brush sideWeight)
  (define cx (send center get-x))
  (define cy (send center get-y))
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
  (send dc set-brush brush)
  (send dc draw-polygon (list pFrom pSide1 pTo pSide2)))

(define (drawTick dc center radius length radians)
  (define cx (send center get-x))
  (define cy (send center get-y))
  (define pTo (make-object point%
                (+ cx (* radius (sin radians)))
                (+ cy (* radius (cos radians)))))
  (define pFrom (make-object point%
                  (+ cx (* radius (- 1 length) (sin radians)))
                  (+ cy (* radius (- 1 length) (cos radians)))))
  (send dc draw-lines (list pTo pFrom)))

(define (paint canvas dc)
  (send dc set-background "black")
  (send dc clear)  

  (define now (current-date))
  (define hour (date-hour now))
  (define minute (date-minute now))
  (define second (+ (date-second now) (- (/ (current-inexact-milliseconds) 1000) (current-seconds))))

  (send dc set-text-foreground "white")
  ;  (send dc draw-text (date->string now #t) 0 0)
  (send frame set-status-text (date->string now #t))

  (define-values (w h) (send dc get-size))
  (define r (/ (min w h) 2))
  (define center (make-object point% (/ w 2) (/ h 2)))

  (define radSec (toRadians (/ second 60)))
  (define radMin (toRadians (/ (+ minute (/ second 60)) 60)))
  (define radHour (toRadians (/ (+ (remainder hour 12) (/ minute 60)) 12)))

  ; minute ticks
  (send dc set-pen (make-object pen% "white" (/ r 120)))
  (for ([rad (in-range 0 (* pi 2) (/ (* pi 2) 60))])
    (drawTick dc center (* r 0.95) 0.06 rad))

  ; hour ticks
  (send dc set-pen (make-object pen% "white" (/ r 60)))
  (for ([rad (in-range 0 (* pi 2) (/ (* pi 2) 12))])
    (drawTick dc center (* r 0.95) 0.2 rad))

  ; 0 3 6 9 ticks
  (send dc set-pen (make-object pen% "white" (/ r 30)))
  (for ([rad (in-range 0 (* pi 2) (/ (* pi 2) 4))])
    (drawTick dc center (* r 0.95) 0.2 rad))

  ; rim
  (send dc set-pen "white" (/ r 60) 'solid)
  (send dc set-brush "" 'transparent)
  (send dc draw-ellipse (- (send center get-x) r) (- (send center get-y) r) (* r 2) (* r 2))

  ; hands
  (send dc set-pen "" 0 'transparent)
  (drawHand dc center (* r 0.5) radHour brushHour (/ 1.1 0.5))
  (drawHand dc center (* r 0.8) radMin brushMin (/ 1.0 0.8))
  (drawHand dc center (* r 0.9) radSec brushSec (/ 0.5 0.9))

  ; center
  (define r2 (/ r 20))
  (send dc set-brush "white" 'solid)
  (send dc draw-ellipse (- (send center get-x) r2) (- (send center get-y) r2) (* r2 2) (* r2 2)))

(define cv (new canvas%
                [parent frame]
                [paint-callback paint]))

(define interval (quotient 1000 60))

(define timer (new timer%
                   [notify-callback (lambda () (send cv refresh))]
                   [interval interval]))

(send frame create-status-line)
(send (send cv get-dc) set-smoothing 'smoothed)
(send frame show #t)