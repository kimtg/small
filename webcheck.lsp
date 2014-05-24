; webcheck (C) 2013 KIM Taegyoon
(println "webcheck - Web Update Checker (C) 2013 KIM Taegyoon")
(print "URL:")
(setq url (read-line))
(setq text-old (get-url url))
(while true
  (setq text-new (get-url url))
  (if (!= text-new text-old)
    (println (date) " changed. length=" (length text-new))
    (setq text-old text-new))
  (sleep 60000))