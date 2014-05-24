; get stock price from Naver
; get KOSPI from Koscom

(print "Enter item code: ")
(define code (read-line))

(define (get-stock code)
  (setq text (get-url (string "http://finance.naver.com/item/main.nhn?code=" code)))  
  (find {<dd>ÇöÀç°¡.+?([\d\.,]+)} text 0)  
  $1)

(define (get-kospi)
  (setq text (get-url "http://kosdb.koscom.co.kr/main/jisuticker.html"))  
  (find {KOSPI&.*?>([\d\.]+)} text 0)  
  $1)

(while true
  (println (date) " | KOSPI=" (get-kospi) ", " code "=" (get-stock code))
  (sleep (* 1000 60)))
