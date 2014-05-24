#!/usr/bin/newlisp
; (C) 2012-2014 KIM Taegyoon
(set-locale "C")
(load (append (env "NEWLISPDIR") "/guiserver.lsp")) 
(define pi (mul 2 (asin 1)))

(gs:init) 

(gs:frame 'Window 100 100 400 400 "SweepSecond")
(gs:set-border-layout 'Window)
(gs:canvas 'MyCanvas)
(gs:set-background 'MyCanvas 0 0 0)
(gs:add-to 'Window 'MyCanvas "center")
(gs:window-resized 'Window 'window-resized-action)
(gs:set-visible 'Window true)

(define (window-resized-action w h) (gs:delete-tag 'Tick)
  (define bounds (gs:get-bounds 'MyCanvas))
  (define cx (/ (bounds 2) 2))
  (define cy (/ (bounds 3) 2))
  (define r (min cx cy))
  (gs:set-stroke (mul r 0.02))
  (for (angle 0 (mul 2 pi) (div pi 6))
    (gs:fill-circle 'Tick (+ cx (mul r 0.95 (sin angle))) (+ cy (mul r 0.95 (cos angle))) (/ r 30) '(1 1 1)))
  (for (angle 0 (mul 2 pi) (div pi 30))
    (gs:fill-circle 'Tick (+ cx (mul r 0.95 (sin angle))) (+ cy (mul r 0.95 (cos angle))) (/ r 90) '(1 1 1)))
  (gs:draw-circle 'Tick cx cy r '(1 1 1)))

(define time-offset ((now) 9))

(while (gs:check-event 10000)
  ;	(define time-string (date (date-value) 0 "%b %d %H:%M:%S"))

  (define bounds (gs:get-bounds 'MyCanvas))
  (define cx (/ (bounds 2) 2))
  (define cy (/ (bounds 3) 2))
  (define r (min cx cy))
  (gs:set-stroke (mul r 0.02))
  
  (define n (now time-offset))
  (define sec (add (n 5) (div (n 6) 1000000)))
  (define min1 (add (n 4) (div sec 60)))
  (define hour (add (% (n 3) 12) (div min1 60)))
  
  (gs:delete-tag 'Hour)
  (gs:draw-line 'Hour cx cy cx (- cy (mul r 0.5)) '(0.2 0.2 1))
  (gs:rotate-tag 'Hour (mul hour 30) cx cy)

  (gs:delete-tag 'Min)
  (gs:draw-line 'Min cx cy cx (- cy (mul r 0.8)) '(0 1 0))
  (gs:rotate-tag 'Min (mul min1 6) cx cy)

  (gs:delete-tag 'Sec)
  (gs:draw-line 'Sec cx cy cx (- cy (mul r 0.95)) '(1 0 0))
  (gs:rotate-tag 'Sec (mul sec 6) cx cy)
  
  (gs:delete-tag 'Hub)
  (gs:fill-circle 'Hub cx cy (/ r 20) '(1 1 1))
	(sleep 33)
)
