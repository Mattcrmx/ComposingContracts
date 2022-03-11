import Contracts
import DateUtils (date, diff)

main :: IO ()
main = do
  let sampleDate = "1200GMT 1 Feb 2010"
      sampleDate' = "1200GMT 1 Feb 2012"
      parsedDate = date sampleDate
      parsedDate' = date sampleDate'
  print (show parsedDate)

  let c = Currency "EUR"
      am = 100
      am' = 1000
      ctr = zcb parsedDate am c
  print (show ctr)
  let difference = diff parsedDate parsedDate'
  print difference

  let ctr2 = zcb parsedDate' am' c
      c3 = ctr `andC` ctr2
  print c3

  let c4 = give ctr2
      c5 = give c3

  print c4
  print c5
