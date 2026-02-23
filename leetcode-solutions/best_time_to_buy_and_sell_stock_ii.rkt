; [Integers] -> Integer
; prices are the list of integers matching to consecutive days
; given prices = [7,1,5,3,6,4], expect 7
; given prices = [1,2,3,4,5], expect 4
; given prices = [7,6,4,3,1], expect 0
(define/contract (max-profit prices)
  (-> (listof exact-integer?) exact-integer?)
  (foldl
    (
     )
    0
    prices
    )
  )
