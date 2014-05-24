; 주민등록번호 검증기
; Resident registration number validator

(println "Resident registration number validator")

(define (resregnum? a)
  (setq s 0)  
  (for (i 0 11)    
    (setq s (+ s (* (+ 2 (mod i 8)) (int (a i))))))
  (setq s (mod (- 11 (mod s 11)) 10))
  (= s (int (a 12))))
 
 (while true
  (print "> ")
  (setq rrn (read-line))
  (println (resregnum? rrn)))
 