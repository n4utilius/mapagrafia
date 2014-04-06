GoogleSpreadsheet = require "google-spreadsheet"

tmp = {
  1: { value: 28175 }
  2: {value: 155053 }
  3: {value: 3641 }
  4: {value: 5883 }
  5: {value: 52426 }
  6: {value: 21108 }
  7: {value: 201361 }
  8: {value: 102091 }
  9: {value: 97353 }
  10: { value: 57214 }
  11: { value: 22861 }
  12: { value: 168826 }
  13: { value: 93066 }
  14: { value: 198419 }
  15: { value: 15615 }
  16: { value: 309659 }
  17: { value: 5517 }
  18: { value: 52355 }
  19: { value: 53476 }
  20: { value: 23116 }
  21: { value: 189861 }
  22: { value: 43946 }
  23: { value: 6948 }
  24: { value: 87368 }
  25: { value: 123706 }
  26: { value: 119421 }
  27: { value: 16145 }
  28: { value: 52439 }
  29: { value: 21944 }
  30: { value: 185262 }
  31: { value: 11544 }
  32: { value: 80173 }
}


exports.get = (key, cb) ->
  cb(null, tmp)
